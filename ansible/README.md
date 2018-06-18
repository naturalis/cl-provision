# cl-provision

# Ansible
- Clone this repo (Ansbible folder) and test connections
```bash
ansible all -m ping
```
- Run the provision playbook
```bash
ansible-playbook provision.yaml
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
