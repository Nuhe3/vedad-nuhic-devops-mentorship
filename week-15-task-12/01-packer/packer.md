# Packer 

### Instalacija na Ubuntu WSL 
- **Add the HashiCorp GPG key**
`curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -`
>**Note**
>Warning: apt-key is deprecated. Manage keyring files in trusted.gpg.d instead (see apt-key(8)).
OK
- **Add the official HashiCorp Linux repository**
`sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"`
- **Update and install**
`sudo apt-get update && sudo apt-get install packer`

```bash
$ packer

output
Usage: packer [--version] [--help] <command> [<args>]

Available commands are:
    build           build image(s) from template
    console         creates a console for testing variable interpolation
    fix             fixes templates from old versions of packer
    fmt             Rewrites HCL2 config files to canonical format
    hcl2_upgrade    transform a JSON template into an HCL2 configuration
    init            Install missing plugins or upgrade plugins
    inspect         see components of a template
    plugins         Interact with Packer plugins and catalog
    validate        check that a template is valid
    version         Prints the Packer version
```

>**Source**
>https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli

## Instalacija AWS CLI kako bi se podesio profile i koristili credencijali 

* The latest AWS CLI version is 2. So download the AWS CLI.
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
```
* Unzip the file using the following command.
```bash
$ sudo apt install unzip # da instaliramo unzip

$ unzip awscliv2.zip
``` 
* Install the AWS CLI using the following command.
`$ sudo ./aws/install`

That’s all. AWS CLI is installed successfully on Ubuntu.

* We can get the AWS CLI version using the below command.
`$ aws --version`
* Output
`aws-cli/2.11.26 Python/3.11.3 Linux/4.4.0-19041-Microsoft exe/x86_64.ubuntu.22 prompt/off`

>**Source**
> https://medium.com/codex/install-aws-command-line-interface-cli-on-ubuntu-491383f93813

#### Podesimo profil 
```bash
$ aws configure --profile <ime-profila> # npr. vedadIaC
Unesemo Access key, Secret Access key, Region i Json format
```
#### Izmjene u template files 
* Kako svoje resurse kreiram u `eu-central-1` potrebno je promijeniti `ami-id`, `region` i dodati `profile`
```bash
  "builders": [{
      "type": "amazon-ebs",
      "profile": "<ime-profila>",
      "region": "eu-central-1",
      "source_ami": "ami-0122fd36a4f50873a",
     ....
```

## Rjesenje za TASK - 12
#### U zadatku, Packer alat koristen je za kreiranje  Custom AMI image od Amazon Linux 3 AMI, gdje je potrebno instalirati i enable-ovati potrebne `yum` repozitorije za instalaciju `nginx` i `mysql` baze podataka. 

* Potreban kod nalazi se u folderu `packer`


* U folderu `shell-scripts` nalaze se dvije odvojene skripte. 
1. `install-nginx.sh` sa komandama potrebnim za enable `yum` repozitorija.
```bash
#/bin/bash

echo "This is script to enable nginx  yum repositories"
sleep 30
echo Updating yum 
sudo yum update -y
sudo yum install -y yum-utils
```
2. `install-mysql.sh` sa komandama potrebnim za dalju pred-instalaciju mysql baze podataka
```bash
echo "This is script to enable  mysql  repositories"
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022

wget http://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm
```
* Kod za kreiranje Custom AMI image je dostupan u fajlu `01_packer_provisioners.json`

#### Pokretanje Packer skripte
* Komanda za pokretanje je
`$  packer build xx_packer_provisioners.json` 
>*Note*
> Voditi racuna da pri pokretanju `packer build` budemo pozicionirani u direktorij gdje se nalazi **xx_packer_provisioners.json** file.
* Output komande u terminalu

![packer-folder](../Screenshots/ubuntu-ami-executed.png)


* Output komande u konzoli, gdje vidimo kreiran AMI image sa 
potrebnim tagovima

![packer-folder](../Screenshots/ami-created.png)
