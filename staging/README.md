# cl-provision

# Staging
- Setup Vagrant + libvirt on KVM. A [guide is found here](https://docs.cumulusnetworks.com/display/VX/Vagrant+and+Libvirt+with+KVM+or+QEMU).
- Clone this repo
- Edit the .dot file and run the topology converter:
```bash
./topology_converter.py -s 25000 -p libvirt naturalis.dot -c
```
- Start all the vagrant boxes: (min. of 14G RAM needed)
```bash
vagrant up --provider=libvirt --no-parallel
```
- ssh into the oob-server
```bash
vagrant ssh oob-server
```
- Clone this repo into the oob-server and run the provision playbook for the [ansible](../ansible/) folder.
