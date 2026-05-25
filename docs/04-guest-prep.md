# Guest Preparation

Inside the temporary Debian VM:

```bash
sudo apt update
sudo apt install -y qemu-guest-agent
sudo systemctl start qemu-guest-agent
systemctl is-active qemu-guest-agent
sudo cloud-init clean --logs --machine-id
sudo rm -f /etc/ssh/ssh_host_*
sudo shutdown now
```

Expected check:

- `systemctl is-active qemu-guest-agent` prints `active`

Why these steps matter:

- `qm set 9013 --agent enabled=1` only enables the Proxmox side of the guest agent; the package must still be installed inside the guest
- `cloud-init clean --logs --machine-id` clears instance state and forces clones to generate a fresh machine ID on first boot
- removing `/etc/ssh/ssh_host_*` forces each clone to generate unique SSH host keys on first boot
