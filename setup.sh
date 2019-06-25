#!/bin/sh
source ~/.bashrc

az group create -n AzureNetworkGroup --location uksouth
az configure --defaults group=AzureNetworkGroup

az group list

echo Press anything to continue ...
read

az network vnet create -n AzureVirtualNetwork --address-prefixes 10.0.0.0/16 --subnet-name AzureSubnet --subnet-prefix 10.0.10.0/24

az network nsg create -n AzureNSG
az network nsg rule create -n SSH --destination-port-range 22 --priority 500 --nsg-name AzureNSG

az network public-ip create -n PublicIP  --dns-name dns123456

az network nic create -n AzureNetworkInterface --vnet-name AzureVirtualNetwork --subnet AzureSubnet --network-security-group AzureNSG

az vm create --name Jenkins --image UbuntuLTS --size Standard_F1 --admin-username jenkins --generate-ssh-keys
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
