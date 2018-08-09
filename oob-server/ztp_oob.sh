#!/bin/bash

function error() {
  echo -e "\e[0;33mERROR: The Zero Touch Provisioning script failed while running the command $BASH_COMMAND at line $BASH_LINENO.\e[0m" >&2
}

# Log all output from this script
exec >> /var/log/autoprovision 2>&1
date "+%FT%T ztp starting script $0"

trap error ERR

SERVER="http://172.16.200.2"

#Add Debian Repositories
echo "deb http://http.us.debian.org/debian jessie main" >> /etc/apt/sources.list
echo "deb http://security.debian.org/ jessie/updates main" >> /etc/apt/sources.list

#Update Package Cache
apt-get update -y

#Install extra packages
apt-get install -y htop vim

#Setup SSH key authentication for Ansible
mkdir -p /home/cumulus/.ssh
wget -O /home/cumulus/.ssh/authorized_keys $SERVER/authorized_keys

#Set Management VRF
sed -i '/iface eth0/a \ vrf mgmt' /etc/network/interfaces
cat <<EOT >> /etc/network/interfaces
auto mgmt
iface mgmt
  address 127.0.0.1/8
  vrf-table auto
EOT

#Give sudo Powahr to cumulus user
echo "cumulus ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/10_cumulus

#Install the license and restart switchd
/usr/cumulus/bin/cl-license -i $SERVER/license && systemctl restart switchd.service

#Set a nice MOTD
## MOTD
echo " ### Overwriting MOTD ###"
cat <<EOT > /etc/motd.base64
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF8NChtbMDs0MDszN20bWzZDG1szMW1fX19fX19fG1szN20gICAbWzE7MzJteBtbMG0gG1szMm14G1szN20gG1szMm14G1szN20bWzI3Q3wgfA0KIBtbMzJtLl8bWzM3bSAgG1szMW08X19fX19fXxtbMTszM21+G1swbSAbWzMybXgbWzM3bSAbWzE7MzJtWBtbMG0gG1szMm14G1szN20gICBfX18gXyAgIF8gXyBfXyBfX18gIF8gICBffCB8XyAgIF8gX19fDQobWzMybSgbWzM3bScgG1szMm1cG1szN20gIBtbMzJtLCcgG1sxOzMzbXx8G1swOzMybSBgLBtbMzdtICAgIBtbMzJtIBtbMzdtICAgLyBfX3wgfCB8IHwgJ18gYCBfIFx8IHwgfCB8IHwgfCB8IC8gX198DQogG1szMm1gLl86XhtbMzdtICAgG1sxOzMzbXx8G1swbSAgIBtbMzJtOj4bWzM3bRtbNUN8IChfX3wgfF98IHwgfCB8IHwgfCB8IHxffCB8IHwgfF98IFxfXyBcDQobWzVDG1szMm1eVH5+fn5+flQbWzM3bScbWzdDXF9fX3xcX18sX3xffCB8X3wgfF98XF9fLF98X3xcX18sX3xfX18vDQobWzVDG1szMm1+IhtbMzdtG1s1QxtbMzJtfiINChtbMzdtG1swMG0NCg0KIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIw0KIw0KIyAgICBTeXN0ZW0gaW5mbzoNCiMNCiMgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFNlcmlhbDoNCiMNCiMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMNCg==
EOT
base64 -d /etc/motd.base64 > /etc/motd
rm /etc/motd.base64
chmod 755 /etc/motd

#Reload interfaces to apply loaded config
ifreload -a

#Provision callback to Ansible AWX
#/usr/bin/curl -H "Content-Type:application/json" -k -X POST --data '{"host_config_key":"'changeme'"}' -u username:password $SERVER/api/v2/job_templates/1111/callback/

reboot
exit 0
#CUMULUS-AUTOPROVISIONING
