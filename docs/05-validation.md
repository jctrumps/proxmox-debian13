# Validation

After the VM shuts down:

```bash
./scripts/convert-to-template.sh
qm config 9013
```

Expected:

- `template: 1`
- `scsi0` on `local-lvm`
- `scsihw: virtio-scsi-single`
- `scsi0` includes `iothread=1`
- `ide2` cloud-init drive
- `ciuser: debian`
- `agent: enabled=1`
- `bios: ovmf`
- `machine: q35`
