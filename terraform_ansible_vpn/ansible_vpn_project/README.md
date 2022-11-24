# Ansible vpn project
Configure a vpn server based on ubuntu Linux

### 1) create a ssh key using the console on AWS

### 2)create a security group
```
aws ec2 create-security-group --region us-east-1 --profile devSecOps --group-name MyVPNsg --description "My security group for VPN"
```


### 3) Assign the SG to the ec2 "(UDP port 500 and 4500)"
```
aws ec2 authorize-security-group-ingress --region us-east-1 --profile devSecOps --group-name MyVPNsg --protocol tcp --port 22 --cidr `curl -s ifconfig.co`/32 # this will take myIp
aws ec2 authorize-security-group-ingress --region us-east-1 --profile devSecOps --group-name MyVPNsg --protocol udp --port 500 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --region us-east-1 --profile devSecOps --group-name MyVPNsg --protocol udp --port 4500 --cidr 0.0.0.0/0
```


### 4)create a ec2 instance OS ubuntu
```
aws ec2 run-instances --region us-east-1 --profile devSecOps --image-id ami-04b9e92b5572fa0d1 --count 1 --instance-type t2.micro --associate-public-ip-address --key-name SSH-KEY-HERE --security-group-ids SG-ID-HERE  --subnet-id SUBNET-ID-HERE
```

### 5) SSH into the instance and run the scrip 'create_vpn.sh'
```
ssh -i "SSH-KEY-HERE" ubuntu@3.255.119.255
```
