# Overview

This project creates a reusable Debian 13 cloud-init template in Proxmox VE.

It follows the same local-image import approach as the Ubuntu 24 project:

1. Download the original cloud image directly on the Proxmox node.
2. Create a VM shell with OVMF/UEFI, q35, and `virtio-scsi-single`.
3. Import the image into `local-lvm` with `qm set --scsi0 ... import-from=...,iothread=1`.
4. Boot-test the VM.
5. Install and verify `qemu-guest-agent`.
6. Clean cloud-init, reset `machine-id`, and remove guest SSH host keys.
7. Shut down and convert to template.
