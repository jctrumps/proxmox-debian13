# Troubleshooting

## Download Failed

Manually run:

```bash
mkdir -p /root/proxmox-cloud-images
cd /root/proxmox-cloud-images
wget https://cloud.debian.org/images/cloud/trixie/latest/debian-13-genericcloud-amd64.qcow2
```

Then rerun `./scripts/create-template.sh`.

## Storage Backend Risk

Use `local-lvm` for the initial template build unless you have already validated another backend for Proxmox template conversion.

If you intentionally want to try a different backend, set `ALLOW_UNSAFE_STORAGE=true` in `config/template.env` first.

## UEFI Shell / PXE / No Boot Device

Confirm:

- `bios: ovmf`
- `machine: q35`
- `scsihw: virtio-scsi-single`
- `efidisk0` exists
- `scsi0` exists
- `scsi0` has `iothread=1`
- boot order is `scsi0`

## Custom Network Config Does Not Apply

If you use a custom cloud-init network config, do not assume the interface is named `eth0`.

On Proxmox with a VirtIO NIC, Debian cloud images commonly expose the first interface with a predictable `en*` name such as `ens18`.

Check the live interface name inside the guest with:

```bash
ip link
```

Then adjust your custom network config if needed.
