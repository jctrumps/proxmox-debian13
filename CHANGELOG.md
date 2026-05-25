# Changelog

## 0.1.0 - 2026-05-24

- Initial template project scaffold.
- Uses direct local image download and `qm set ... import-from=...`.
- Adds guest-side `qemu-guest-agent` install and `cloud-init clean` step before template conversion.
- Documents Proxmox automation users, roles, ACLs, and future API-token use.
- Aligns guest prep, examples, and docs on machine-id and SSH host-key cleanup before conversion.
- Adds a storage safety guard so non-`local-lvm` builds require explicit opt-in.
- Switches the template disk to `virtio-scsi-single` with `iothread=1`.
- Fixes Debian-specific doc drift and makes the example custom network config safer for `en*` interface names.
- Records successful creation and conversion of the Debian 13 template at VMID `9013`.
