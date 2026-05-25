# Configuration

Copy and edit:

```bash
cp config/template.env.example config/template.env
nano config/template.env
```

Key values:

```bash
TEMPLATE_VMID=9013
TEMPLATE_NAME="debian-13-cloudinit"
STORAGE="local-lvm"
BRIDGE="vmbr0"
CIUSER="debian"
```

Keep `STORAGE="local-lvm"` unless you have already validated another backend for template conversion. Non-default storage now requires `ALLOW_UNSAFE_STORAGE=true`.
