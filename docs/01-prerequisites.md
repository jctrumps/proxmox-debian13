# Prerequisites

Required:

- available VMID `9013`
- storage `local-lvm`
- bridge `vmbr0`
- working internet access from the Proxmox node
- commands: `qm`, `pvesm`, `wget`, `ip`

Check:

```bash
qm status 9013
pvesm status
ip link show vmbr0
```
