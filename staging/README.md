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
- If all boxes are setup correctly, on each box/switch the ZTP service will pull the ztp_oob script from the oob-server. This script will install the needed ssh keys, and set a mgmt interface on mgmt VRF. Also a nice MOTD is set (and if enabled a provisioning callback is done to Ansible AWX).

If all setup correctly you can watch the access.log on the oob-server, to see incoming requests.:
```bash
sudo tail -f /var/log/apache2/access.log
```
(If enabled) the ZTP script will do a provision callback to Ansible AWX and the 1st provisioning playbook will be started, to set PTM+.dot file, users, and interfaces.

If all vx switches pulled the ztp_oob.sh file (and ran the provision.yaml playbook if the provision callback is enabled) you can test the connections with [ansible](ansible/):
```bash
ansible network -m ping -i environments/staging
```
Now is the time to start the provision playbook if the provision callback is not enabled, to finish the deployment:
```bash
ansible-playbook provision.yaml -i environments/staging
```

There is also an interfaces playbook, which only checks the interfaces for changes.
```bash
ansible-playbook interfaces.yaml -i environments/staging
```
