Ansible vault default


Usiong a file as ansible password (`vault_pass.yml`)
Creating New Encrypted Files (manual steps, type password twice)
```
echo 'unencrypted stuff' > encrypt_me.txt
ansible-vault encrypt --vault-password-file vault_pass.yml  encrypt_me.txt 
```

View the content of a Encrypted file with the `--vault-password-file` parameter and the password file`vault_pass.yml` 
```
ansible-vault view --vault-password-file vault_pass.yml encrypt_me.txt # no need to type the 'ansible-vault' password
```

Decrypting file with password from a file containg the ansible password already saved on the machine
```
ansible-vault decrypt --vault-password-file vault_pass.yml encrypt_me.txt
```


<hr>

Ansible vault with id for multiples env
Encrypting:
```
echo 'dev unencrypted stuff' > dev_encrypt_me.txt
ansible-vault encrypt --vault-id dev@prompt dev_encrypt_me.txt

echo 'prod unencrypted stuff' > prod_encrypt_me.txt
ansible-vault encrypt --vault-id prod@prompt prod_encrypt_me.txt
```

View `dev_encrypt_me.txt` file with the prompt ansible vault password
```
ansible-vault view --vault-id dev@prompt dev_encrypt_me.txt 
```

decrypting: (can be used with `--vault-password-file` like above)
```
ansible-vault decrypt --vault-id dev@prompt dev_encrypt_me.txt
ansible-vault decrypt --vault-password-file vault_pass.yml --vault-id dev@prompt dev_encrypt_me.txt
```
