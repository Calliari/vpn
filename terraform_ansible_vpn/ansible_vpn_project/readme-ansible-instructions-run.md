# Ansible vpn project

Test the ansible connection in case need

### 1) Ansible Running Ad Hoc Commands to test teh connection with the host (local_jenkins)
```
ansible -i inventory/internal_infra/internal_infra.yml  -m ping local_jenkins
```

### 2) If the test is pong then, ansible can connect with theh host and ready to provision, '-C' flag is on check_mode 'ON' safe to run and not changes will be applied "dry-run".
```
ansible-playbook -i inventory/servers_hosts.yml playbook-file.yml --vault-password-file=~/vault-dir/ansible-vault-file --tags=dependecies_installation_tag -CD
```
