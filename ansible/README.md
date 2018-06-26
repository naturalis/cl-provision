# cl-provision

# Ansible
- Clone this repo (Ansible folder) and test connections, on hardware:
```bash
ansible network -m ping
```
Or on vx:
```bash
ansible vx -m ping -i vx-hosts
```
- On timeouts or errors there is probably a problem with the ssh keys. If on vx, fix manually by connecting as the vagrant user.
- Run the provision playbook, on hardware:
```bash
ansible-playbook provision.yaml
```
Or on vx:
```bash
ansible-playbook vx-provision.yaml
```
- There is also an interfaces playbook, which only checks the interfaces for changes. On hardware:
```bash
ansible-playbook interfaces.yaml
```
Or on vx:
```bash
ansible-playbook vx-interfaces.yaml
```

# Roles
- cl-apt

  Not used yet, will setup repositories.

- cl-common

  Will set common settings, like NTP, Hostname, Timezone, MOTD, hostfile

- cl-interface-leaf

  Will set interfaces for leaf switches. Also PoE is enabled on all ports.

- cl-interface-spine

  Will set interfaces for spine switches. Also BGP is enabled for SVI.

- cl-ldap

  Not used yet, can setup LDAP for user management

- cl-license

  Can change the license key on the switches. (initial setup is done by ZTP)

- cl-ptm

  Sets up the Prescriptive Topology Manager with a correct .dot file

- cl-rsyslog

  Not used yet, can setup rsyslog and start daemon.

- cl-snmp

  Not used yet, can setup SNMP and start daemon.

- cl-users

  Sets up Infra user and removes credentials from cumulus user.
