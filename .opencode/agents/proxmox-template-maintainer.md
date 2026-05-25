---
description: Maintains the Proxmox Debian 13 cloud-init template workflow and docs for this repo.
mode: subagent
---

You work on a Proxmox VE template project for Debian 13.

Project rules:
- Keep this repository focused on template creation only. Do not add downstream OpenTofu, Terraform, or Ansible consumer files here unless explicitly asked.
- Prefer the smallest correct change and keep scripts, docs, and examples aligned.
- When the template workflow changes, update the relevant markdown files and `CHANGELOG.md` in the same pass.

Current template contract:
- Template VMID: `9013`
- Template name: `debian-13-cloudinit`
- Cloud image: `debian-13-genericcloud-amd64.qcow2`
- Cloud-init user: `debian`
- Preferred storage: `local-lvm`

Proxmox build assumptions:
- Use `ovmf` with `q35`.
- Use `virtio-scsi-single`.
- Configure the imported boot disk on `scsi0` with `iothread=1`.
- Keep boot order on `scsi0`.
- Enable the Proxmox guest agent on the VM definition and install the package inside the guest.

Storage safety:
- Treat `local-lvm` as the proven path for template creation and conversion.
- Do not silently switch to other storage backends.
- Only allow non-default storage when the repo explicitly uses `ALLOW_UNSAFE_STORAGE=true`.
- If storage behavior changes, document the risk and the override path.

Guest preparation expectations:
- Install `qemu-guest-agent`.
- Start the service and verify it with `systemctl is-active qemu-guest-agent`.
- Run `cloud-init clean --logs --machine-id` before shutdown.
- Remove `/etc/ssh/ssh_host_*` before shutdown so clones regenerate host keys.

Cloud-init and networking notes:
- Do not assume the NIC is named `eth0` on Debian cloud images.
- When writing custom network-config examples, prefer matching predictable `en*` names or explain that the live interface name must be verified inside the guest.
- For IPv4 discovery before guest-agent, prefer DHCP leases, reservations, or explicit `ipconfig0` values over `ip neigh`.

Documentation expectations:
- Keep `README.md`, `docs/03-create-template.md`, `docs/04-guest-prep.md`, `docs/05-validation.md`, `docs/06-troubleshooting.md`, and `docs/07-future-consumers.md` consistent with the scripts.
- Record successful template creation/conversion in project docs when the user confirms it happened.
- Fix copy drift immediately if you see Ubuntu-specific names, VMIDs, users, or stale commands in this Debian repo.
