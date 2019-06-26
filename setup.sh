#!/bin/sh
source ~/.bashrc

az group create \
    -n AzureNetworkGroup \
    --location uksouth
az configure \
    --defaults group=AzureNetworkGroup

# is my network and subnets setup correctly
az network vnet create \
    -n AzureVirtualNetwork \
    --resource-group AzureNetworkGroup \
    --address-prefix 10.0.10.0/24 \
    --subnet-name MainSubnet \
    --subnet-prefix 10.0.10.0/24

# echo Press anything to continue ...
# read

# nsg setup, I'm not sure if initially
#  i have set it up correctly just for ssh-ing
az network nsg create \
    -n AzureNSG
az network nsg rule create \
    -n SSH \
    --access Allow \
    --direction Inbound \
    --priority 100 \
    --nsg-name AzureNSG \
    --destination-port-ranges 22
az network nsg rule create \
    -n Jenk \
    --access Allow \
    --priority 101 \
    --nsg-name AzureNSG \
    --destination-port-ranges 8080

az network public-ip create \
    -n IPpubJenkins \
    --allocation static
az network public-ip create \
    -n IPpubPython \
    --allocation static

# is a nic necessary and how is it helping me
# is it just like a container of all setup details
# for the VM creation
az network nic create \
    -n AzureNetworkJenkins \
    --vnet-name AzureVirtualNetwork \
    --subnet MainSubnet \
    --public-ip-address IPpubJenkins \
    --network-security-group AzureNSG
az network nic create \
    -n AzureNetworkPython \
    --vnet-name AzureVirtualNetwork \
    --subnet MainSubnet \
    --public-ip-address IPpubPython \
    --network-security-group AzureNSG

# echo NIC setup
# echo Press anything to continue ...
# read

az vm create \
    -n Jenkins \
    --image UbuntuLTS \
    --size Standard_F1 \
    --admin-username janky \
    --nics AzureNetworkJenkins \
    --generate-ssh-keys

az vm create \
    -n Jenkins-Slave \
    --image UbuntuLTS \
    --size Standard_F1 \
    --admin-username janky \
    --nics AzureNetworkJenkins

az vm create \
    -n Python-Server \
    --image UbuntuLTS \
    --size Standard_F1 \
    --admin-username janky \
    --nics AzureNetworkPython

echo Created VM Details :

az vm show -g AzureNetworkGroup -n Jenkins --show-details --query '[privateIps,publicIps,powerState,name,hardwareProfile.vmSize,osProfile.adminUsername,osProfile.computerName]'

az vm show -g AzureNetworkGroup -n Jenkins-Slave --show-details --query '[privateIps,publicIps,powerState,name,hardwareProfile.vmSize,osProfile.adminUsername,osProfile.computerName]'

az vm show -g AzureNetworkGroup -n Python-Server --show-details --query '[privateIps,publicIps,powerState,name,hardwareProfile.vmSize,osProfile.adminUsername,osProfile.computerName]'




# for vm in ${vmusers}; do
#   az vm create \
#   --name jenkins \
#   --image UbuntuLTS \
#   --size Standard_F4s \
#   --generate-ssh-keys
# done

# SSH intro jenkins VM
#   start jenkins setup
#
# SSH into Slave VM
#   create jenkins user
#   git python
#
# deploy Python through jenkins
