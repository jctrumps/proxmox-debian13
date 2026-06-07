# proxmox-debian13

Create a reusable Debian 13 cloud-init template for Proxmox VE.

This repository stays focused on template creation only. Future OpenTofu and Ansible projects can consume the completed template.

## Defaults

| Setting | Value |
|---|---|
| VMID | `9013` |
| Template name | `debian-13-cloudinit` |
| Image | `debian-13-genericcloud-amd64.qcow2` |
| Storage | `local-lvm` |
| Bridge | `vmbr0` |
| Disk size | `8G` |
| Cloud-init user | `debian` |

## Quick Start

```bash
cp config/template.env.example config/template.env
nano config/template.env

./scripts/check-host.sh
./scripts/create-template.sh
```

Inside the VM:

```bash
sudo apt update
sudo apt install -y qemu-guest-agent
sudo systemctl start qemu-guest-agent
systemctl is-active qemu-guest-agent
sudo cloud-init clean --logs --machine-id
sudo rm -f /etc/ssh/ssh_host_*
sudo shutdown now
```

Then convert it:

```bash
./scripts/convert-to-template.sh
```

The template keeps a small `8G` disk by default. Debian is leaner than Ubuntu, so this keeps similar practical headroom to a `10G` Ubuntu template while still allowing clone disks to grow later in OpenTofu or other consumers.
