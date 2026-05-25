#!/usr/bin/env bash
set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_FILE="${PROJECT_ROOT}/config/template.env"

if [[ ! -f "${CONFIG_FILE}" ]]; then
  echo "Missing config/template.env"
  echo "Create it with: cp config/template.env.example config/template.env"
  exit 1
fi

# shellcheck source=/dev/null
source "${CONFIG_FILE}"

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1"
    exit 1
  fi
}

require_safe_storage() {
  if [[ "${STORAGE}" == "local-lvm" ]]; then
    return 0
  fi

  if [[ "${ALLOW_UNSAFE_STORAGE:-false}" == "true" ]]; then
    echo "Storage ${STORAGE} is not the proven local-lvm path. Proceeding because ALLOW_UNSAFE_STORAGE=true."
    return 0
  fi

  echo "Storage ${STORAGE} is not the proven local-lvm path for this workflow."
  echo "Template conversion previously failed on unsupported storage backends such as NFS."
  echo "Use STORAGE=local-lvm or set ALLOW_UNSAFE_STORAGE=true only after validating this backend."
  exit 1
}

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run this on the Proxmox node as root."
  exit 1
fi

need_cmd qm
need_cmd pvesm
need_cmd wget
need_cmd ip

echo "Checking storage: ${STORAGE}"
if ! pvesm status | awk '{print $1}' | grep -qx "${STORAGE}"; then
  echo "Storage not found: ${STORAGE}"
  pvesm status
  exit 1
fi
require_safe_storage

echo "Checking bridge: ${BRIDGE}"
if ! ip link show "${BRIDGE}" >/dev/null 2>&1; then
  echo "Bridge not found: ${BRIDGE}"
  ip link show
  exit 1
fi

echo "Checking VMID: ${TEMPLATE_VMID}"
if qm status "${TEMPLATE_VMID}" >/dev/null 2>&1; then
  echo "VMID ${TEMPLATE_VMID} already exists."
  echo "Set ALLOW_DESTROY_EXISTING=true only if you intend to replace it."
else
  echo "VMID ${TEMPLATE_VMID} is available."
fi

echo "Checking image URL:"
echo "  ${IMAGE_URL}"
if wget --spider --quiet "${IMAGE_URL}"; then
  echo "Image URL is reachable."
else
  echo "Image URL check failed. You can still download manually and set IMAGE_FILE/IMAGE_DIR."
  exit 1
fi

echo "Host check complete."
