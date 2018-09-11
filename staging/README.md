# Naturalis campus network 2.0

# Staging

## Setup the base

- You can setup Vagrant + libvirt on KVM, following the [guide](https://docs.cumulusnetworks.com/display/VX/Vagrant+and+Libvirt+with+KVM+or+QEMU) or running the ansible [playbook](https://github.com/CumulusNetworks/ansible_snippets/blob/master/setup_simulation_server/install_libvirt_kvm_simulation.yml).

- Clone the [topology_converter repo](https://github.com/CumulusNetworks/topology_converter) from cumulus. These files will help us to make a Vagrantfile with needed specials according to the links and hosts we define in a .dot file.
```bash
                                                                       +---------+
                                                                  +--> | LibVirt |
                    +----------------------+                      |    +---------+
+--------------+    |                      |    +--------------+  |
| Topology.dot +--> |  Topology-Converter  +--> | Vagrantfile  +--+
+--------------+    |                      |    +--------------+  |
                    +----------------------+                      |    +------------+
                                                                  +--> | VirtualBox |
                                                                       +------------+

```
- Unfortunately there is still a bug we need to fix. Go into the local topology_converter repo and edit the /templates/Vagrantfile.j2 file to fix it:
```bash
After the line:
echo "### Resetting ZTP to work next boot..."
ztp -R 2>&1

Add the following line:
ztp -i 2>&1
```
- Edit '/helper_scripts/auto_mgmt_network/OOB_Server_Config_auto_mgmt.sh', to set a default pass for the cumulus user.
```bash
After the line:
echo " ### Creating cumulus user ###"
useradd -m cumulus

Add the following line:
echo "cumulus:CumulusLinux!" | chpasswd
```
- Download the [naturalis.dot](naturalis.dot) file, from this repo and edit it as needed.
- Now run the topology converter with it:
```bash
./topology_converter.py -s 25000 -p libvirt /home/bla/naturalis.dot -c
```
- If needed update the boxes with:
```bash
vagrant box update
```

## Fire it up

- Start all the vagrant boxes: (around 14G RAM needed)
```bash
vagrant up --provider=libvirt --no-parallel
```
- On each box/switch the ZTP service will pull the ztp_oob script from the oob-server. This script will install the needed ssh keys, and set a mgmt interface on mgmt VRF. Also a nice MOTD is set.

While the boxes are being built, you can watch the access.log on the oob-server. Start a new tab (or use screen) to see incoming requests:
```bash
vagrant ssh oob-server
sudo tail -f /var/log/apache2/access.log
```
- You should see GET requests to the ztp script and the authorized_keys file:
```bash
192.168.200.11 - - [11/Sep/2018:11:26:38 +0300] "GET /ztp_oob.sh HTTP/1.1" 200 945 "-" "CumulusLinux-AutoProvision/1.0"
192.168.200.11 - - [11/Sep/2018:11:26:38 +0300] "GET /authorized_keys HTTP/1.1" 200 662 "-" "Wget/1.16 (linux-gnu)"
192.168.200.1 - - [11/Sep/2018:11:27:40 +0300] "GET /ztp_oob.sh HTTP/1.1" 200 945 "-" "CumulusLinux-AutoProvision/1.0"
192.168.200.1 - - [11/Sep/2018:11:27:40 +0300] "GET /authorized_keys HTTP/1.1" 200 662 "-" "Wget/1.16 (linux-gnu)"
192.168.200.2 - - [11/Sep/2018:11:28:42 +0300] "GET /ztp_oob.sh HTTP/1.1" 200 945 "-" "CumulusLinux-AutoProvision/1.0"
```
- Go back to the tab where you started the vagrant boxes and check that all boxes are running.
```bash
vagrant status
```

## Ansible

You can clone the [ansible](ansible/) code into the oob-mgmt-server and test connections:
```bash
vagrant ssh oob-server
su - cumulus
git clone https://github.com/naturalis/network
cd network/ansible
ansible switches -m ping
```
