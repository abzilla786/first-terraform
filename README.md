# Terraform

Terraform is an orchestration tool, that is part of infrastructure as code.

where chef and packer sit more on the **configuration** management side and create imutable AMIs.

Terraform sits on the orchestration side. This includes the  creation of networks and complex systems and deploys AMI

An AMI is a blue print (snap shot) of an instance:
- the operating system
- data storage
- all the packages and exact state of a machine when AMI was created

## Pre-requisites
- running AMI
- Terraform
- pem key

Before you begin to run the terraform files please go to https://github.com/abzilla786/packer_nodejs and follow the instructions in the readme to create our own working AMI that has the correct provisions to run this app.

## Running Terraform
once you have finished the above step, locate this folder on your terminal and run the command:

```
terraform plan
```

this will make sure everything is ready for use and will point out any errors there may be, you should get no errors unless terraform is not installed on your comp. if this is the case you will need to download and install terraform on your pc.

now once you have run the above command and no errors have shown, you can now run
```
terraform apply
```

this will create your ec2 instance and automatically start the app. 
