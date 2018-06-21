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
- Check that all boxes are running.
```bash
vagrant status
```
- ssh into the oob-server
```bash
vagrant ssh oob-server
```
- If all boxes are setup correctly each box/switch should have pulled the ztp_oob.sh script and installed the ssh keys. Check the apache log for requests:
```bash
sudo tail /var/log/apache2/access.log
```
- If everything looks good, clone this repo into the oob-server and run the provision playbook for the [ansible](../ansible/) folder.
