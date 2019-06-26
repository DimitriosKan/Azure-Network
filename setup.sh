#!/bin/sh
source ~/.bashrc

az group create \
    -n AzureNetworkGroup \
    --location uksouth
az configure \
    --defaults group=AzureNetworkGroup

az network vnet create \
    -n AzureVirtualNetwork \
    --address-prefixes 10.0.0.0/16 \
    --subnet-name MainSubnet \
    --subnet-prefix 10.0.10.0/24

az network nsg create \
    -n AzureNSG
az network nsg rule create \
    -n SSH \
    --access Allow \
    --direction Inbound \
    --priority 100 \
    --nsg-name AzureNSG \
    --destination-port-ranges 22

az network public-ip create \
    -n PublicIP

az network nic create \
    -n AzureNetworkInterface \
    --vnet-name AzureVirtualNetwork \
    --subnet MainSubnet \
    --public-ip-address PublicIP \
    --network-security-group AzureNSG

# echo Press anything to continue ...
# read
#
# az network nsg create \
#     -n AzureNSG
# az network nsg rule create \
#     -n SSH \
#     --access Allow \
#     --protocol Tcp \
#     --direction Inbound \
#     --destination-port-range 22 \
#     --priority 100 \
#     --nsg-name AzureNSG
#
# az network vnet create \
#     -n AzureVirtualNetwork \
#     --address-prefixes 10.0.0.0/16 \
#
# az network vnet subnet create \
#     -n MainSubnet \
#     --vnet-name AzureVirtualNetwork \
#     --address-prefix 10.0.0.0/24 \
#     --network-security-group AzureNSG

# for python

# az network public-ip create \
#     -n IPJenkins
#
# az network public-ip create \
#     -n IPSlave

# az network nic create \
#     -n NetworkInterfaceJenkins \
#     --vnet-name AzureVirtualNetwork \
#     --subnet SubnetJenkins \
#     --public-ip-address IPJenkins \
#     --network-security-group AzureNSG
#
# az network nic create \
#     -n NetworkInterfaceSlave \
#     --vnet-name AzureVirtualNetwork \
#     --subnet SubnetJenkinsSlave \
#     --public-ip-address IPSlave \
#     --network-security-group AzureNSG

# seems like generate-ssh-keys does not work
# (no keys generated in profile)
az vm create \
    -n Jenkins \
    --image UbuntuLTS \
    --size Standard_F1 \
    --admin-username jenkinsboss \
    --generate-ssh-keys

az vm create \
    -n Jenkins-Slave \
    --image UbuntuLTS \
    --size Standard_F1 \
    --admin-username jenkinsslave \
    --nics AzureNetworkInterface \
    --generate-ssh-keys

az vm show -g AzureNetworkGroup -n Jenkins --show-details --query '[privateIps,publicIps,powerState,name,hardwareProfile.vmSize,osProfile.adminUsername,osProfile.computerName]'

az vm show -g AzureNetworkGroup -n Jenkins-Slave --show-details --query '[privateIps,publicIps,powerState,name,hardwareProfile.vmSize,osProfile.adminUsername,osProfile.computerName]'



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
