# cl-provision

# Staging
- Setup Vagrant + libvirt on KVM. A [guide is found here](https://docs.cumulusnetworks.com/display/VX/Vagrant+and+Libvirt+with+KVM+or+QEMU).
- Clone this repo
- Edit the .dot file and run the toplogy_converter:
```bash
./topology_converter.py -s 25000 -p libvirt naturalis.dot -c
```
- Start vagrant boxes:
```bash
vagrant up --provider=libvirt --no-parallel
```
- ssh into the oob-server
```bash
vagrant ssh oob-server
```
- Clone this repo (ansible folder) into the oob-server and run the provision playbook.
