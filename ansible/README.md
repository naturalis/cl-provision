# cl-provision

# Ansible
- Clone this repo (Ansible folder) and test connections, on hardware:
```bash
ansible network -m ping -i environments/prod
```
Or on vx:
```bash
ansible network -m ping -i environments/staging
```
- On timeouts or errors there is probably a problem with the ssh keys. If on vx, fix manually by connecting as the vagrant user.
- Run the provision playbook, on hardware:
```bash
ansible-playbook provision.yml -i environments/prod
```
Or on vx:
```bash
ansible-playbook provision.yml -i environments/staging
```
- There is also an interfaces playbook, which only checks the interfaces for changes. On hardware:
```bash
ansible-playbook interfaces.yml -i environments/prod
```
Or on vx:
```bash
ansible-playbook interfaces.yml -i environments/staging
```

# Files
```bash
├── ansible.cfg
├── environments/           # Parent directory for environment-specific directories.
│   │
│   ├── staging/            # Contains all files specific to the staging (cumulus vx) environment.
│   │   ├── group_vars/     # staging specific group_vars files.
│   │   │   └── all
│   │   └── hosts           # Contains only the hosts in the staging environment.
│   │
│   └── prod/               # Contains all files specific to the prod environment.
│       ├── group_vars/     # prod specific group_vars files.
│       │   └── all
│       └── hosts           # Contains only the hosts in the prod environment.
│   
├── roles/
│   ├── cl-common           # Will set common settings, like NTP, Hostname, Timezone, MOTD, hostfile
│   ├── cl-interface-leaf   # Will set interfaces for leaf switches. Also PoE is enabled needed ports.
│   ├── cl-interface-spine  # Will set interfaces and ospf for spine switches.
│   ├── cl-interface-uplink # Will set interfaces and ospf for uplink switches (staging).
│   ├── cl-license          # Can change the license key on the switches (initial setup is done by ZTP).
│   ├── cl-monitoring       # Installs prometheus node_exporter, configures remote syslog and snmp daemon.
│   ├── cl-ptm              # Sets up the Prescriptive Topology Manager with a correct .dot file
│   └── cl-users            # Sets up Infra user and removes credentials from cumulus user.
│
├── vars/
│   ├── prod.yml           # prod specific vars files.
│   └── staging.yml        # staging specific vars files.
│
├── check.yml              # Playbook to check and ouput ptm and lldp information.
├── license.yml            # Playbook to setup or change license key (initial setup is done by ZTP).
├── interfaces.yml         # Playbook to setup interfaces.
├── linter.sh              # Passes all .yml files through yamllint ($pip install yamllint).
├── provision.yml          # Playbook to do the first provisioning.
├── support_make.yml       # Playbook to make and retrieve support files for troubleshooting.
├── support_remove.yml     # Playbook to remove support files from switches.
├── uplink.yml             # Playbook to setup interfaces and ospf on uplink switches (staging).
└── users.yml              # Playbook to setup users and ssh keys.
```
