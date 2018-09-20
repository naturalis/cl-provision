# Naturalis campus network 2.0

# oob-server

- Set a  nice MOTD for the OOB-server
```bash
echo " ### Overwriting MOTD ###"
cat <<EOT > /etc/motd.base64
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF8NChtbMDs0
MDszN20bWzZDG1szMW1fX19fX19fG1szN20gICAbWzE7MzJteBtbMG0gG1szMm14G1szN20gG1sz
Mm14G1szN20bWzI3Q3wgfA0KIBtbMzJtLl8bWzM3bSAgG1szMW08X19fX19fXxtbMTszM21+G1sw
bSAbWzMybXgbWzM3bSAbWzE7MzJtWBtbMG0gG1szMm14G1szN20gICBfX18gXyAgIF8gXyBfXyBf
X18gIF8gICBffCB8XyAgIF8gX19fDQobWzMybSgbWzM3bScgG1szMm1cG1szN20gIBtbMzJtLCcg
G1sxOzMzbXx8G1swOzMybSBgLBtbMzdtICAgIBtbMzJtIBtbMzdtICAgLyBfX3wgfCB8IHwgJ18g
YCBfIFx8IHwgfCB8IHwgfCB8IC8gX198DQogG1szMm1gLl86XhtbMzdtICAgG1sxOzMzbXx8G1sw
bSAgIBtbMzJtOj4bWzM3bRtbNUN8IChfX3wgfF98IHwgfCB8IHwgfCB8IHxffCB8IHwgfF98IFxf
XyBcDQobWzVDG1szMm1eVH5+fn5+flQbWzM3bScbWzdDXF9fX3xcX18sX3xffCB8X3wgfF98XF9f
LF98X3xcX18sX3xfX18vDQobWzVDG1szMm1+IhtbMzdtG1s1QxtbMzJtfiINChtbMzdtG1swMG0N
Cg0KIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIw0KIw0KIyAgICAgICAgIE91dCBPZiBCYW5kIE1hbmFnZW1l
bnQgU2VydmVyIChvb2ItbWdtdC1zZXJ2ZXIpDQojDQojIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjDQo=
EOT
base64 -d /etc/motd.base64 > /etc/motd
rm /etc/motd.base64
chmod 755 /etc/motd
```
- Install needed packages
```bash
apt-get install -y htop tree apache2 vlan git python-pip

modprobe 8021q
echo "8021q" >> /etc/modules

#extra if needed
#apt-get install -y isc-dhcp-server dnsmasq lldpd ifenslave ntp

#caching proxy server for repositories
#apt-get install -y apt-cacher-ng
```
- Install Ansible
```bash
apt-get install -qy ansible sshpass libssh-dev python-dev libssl-dev libffi-dev
pip install pip --upgrade
pip install setuptools --upgrade
```
- Add cumulus user for ansible
```bash
useradd -m cumulus
passwd cumulus
echo "cumulus ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/10_cumulus
```
- Add parameters to DHCP server or dhcpd.conf and restart the DHCP server
```bash
vim /etc/dhcp/dhcpd.conf

*** Add to the global range:
option cumulus-provision-url code 239 = text;
option www-server code 72 = ip-address;

*** Add to the mgmt subnet:  
option default-url = "http://172.16.200.2/onie-installer-[ARCH].bin";
option cumulus-provision-url "http://172.16.200.2/ztp_oob.sh";
option www-server 172.16.200.2;


systemctl restart isc-dhcp-server
```
Set a nice index file:
```bash
echo "<html><h1>You've come to the OOB-MGMT-Server.</h1></html>" > /var/www/html/index.html
```
- Setup ztp.
Clone this repo (OOB-server folder) and copy the ztp_oob.sh file to "/var/www/html/ztp_oob.sh"

- Setup the license
Copy the license key to "/var/www/html/license"

- Setup ansible files
  Clone this repo (ansible folder)

- Setup ssh keys
```bash
mkdir /home/cumulus/.ssh
/usr/bin/ssh-keygen -b 2048 -t rsa -f /home/cumulus/.ssh/id_rsa -q -N ""
cp /home/cumulus/.ssh/id_rsa.pub /home/cumulus/.ssh/authorized_keys

chown -R cumulus:cumulus /home/cumulus/
chown -R cumulus:cumulus /home/cumulus/.ssh
chmod 700 /home/cumulus/.ssh/
chmod 600 /home/cumulus/.ssh/*
chown cumulus:cumulus /home/cumulus/.ssh/*

cp /home/cumulus/.ssh/id_rsa.pub /var/www/html/authorized_keys
chmod 777 -R /var/www/html/*
```
- Setup cumulus installer Files
  Download .bin files and put them in the /var/www/html folder using the right naming. (eg. cumulus-linux-3.6.1-bcm-amd64.bin / cumulus-linux-3.6.1-bcm-armel.bin)
  Theres also the possibility to use symlinks.
