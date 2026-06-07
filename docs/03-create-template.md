# Create Template VM

Run:

```bash
./scripts/check-host.sh
./scripts/create-template.sh
```

The script follows this pattern:

```bash
mkdir -p /root/proxmox-cloud-images
cd /root/proxmox-cloud-images
wget https://cloud.debian.org/images/cloud/trixie/latest/debian-13-genericcloud-amd64.qcow2
qm create 9013 --name debian-13-cloudinit --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-single --bios ovmf --machine q35
qm set 9013 --scsi0 local-lvm:0,import-from=/root/proxmox-cloud-images/debian-13-genericcloud-amd64.qcow2,iothread=1
qm resize 9013 scsi0 8G
qm set 9013 --efidisk0 local-lvm:0,pre-enrolled-keys=0
qm set 9013 --ide2 local-lvm:cloudinit
qm set 9013 --boot order=scsi0
qm set 9013 --ciuser debian
qm set 9013 --ipconfig0 ip=dhcp
qm set 9013 --agent enabled=1
qm start 9013
```

Do not convert the VM to a template yet.

This project uses `virtio-scsi-single` with `iothread=1` on `scsi0` so the imported boot disk follows the preferred Proxmox performance path for VirtIO SCSI.

The template disk stays at `8G` by default so downstream consumers can grow it as needed without being stuck with an oversized base image they cannot easily shrink. Debian is leaner than Ubuntu, so `8G` keeps similar practical headroom to the `10G` Ubuntu template; `6G` may work but is more likely to become tight during updates.
