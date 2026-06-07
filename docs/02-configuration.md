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
DISK_SIZE="8G"
CIUSER="debian"
```

Keep `STORAGE="local-lvm"` unless you have already validated another backend for template conversion. Non-default storage now requires `ALLOW_UNSAFE_STORAGE=true`.

Keep `DISK_SIZE="8G"` unless you have a concrete reason to make the template larger. Debian is leaner than Ubuntu, so `8G` keeps practical update headroom without carrying an oversized base disk. A smaller value such as `6G` may work, but it is intentionally not the default because package upgrades and cache growth can make it tight.
