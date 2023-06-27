#Definicion de variables
$resourcegroup = "Recursos"
$resourcegroup2 = "Recursos2"
$location = "eastus"
$location2 = "westus"
$namevnet = "vnetol1"
$namevnet2 = "vnetol2"
$prefix = "10.0.0.0/16"
$subnetprefix = "10.0.0.0/24"
$subnetname = "subnet1"
$subnetname2 = "subnet2"
$prefix2 = "10.1.0.0/16"
$subnetprefix2 = "10.1.0.0/24"
$peering = "emparejamiento"
$vm1 = "virtualmachineeast"
$vm02= "virtualmachinewestus"
$adminname1 = "olmannoe"
$adminname2 = "olmanarias"
$adminpass1 = "Ariascuevas24?"
$adminpass2 = "Noecuevas24?"
$image = "Ubuntu2204"

#Crear resource group
az group create --location $location --name $resourcegroup

#Crear un segundo resource group
az group create --location $location2 --name $resourcegroup2

#Crear vnet
az network vnet create --name $namevnet --resource-group $resourcegroup --location $location --address-prefix $prefix --subnet-name $subnetname --subnet-prefix $subnetprefix

#Crear segunda vnet
az network vnet create --name $namevnet2 --resource-group $resourcegroup2 --location $location2 --address-prefix $prefix2 --subnet-name $subnetname2 --subnet-prefix $subnetprefix2

#crear un peering
az network vnet peering create --resource-group $resourcegroup --name $peering --vnet-name $namevnet --remote-vnet $namevnet2 --allow-forwarded-traffic yes --allow-vnet-access yes

#Crear una vm unido en la primera net
az vm create --resource-group $resourcegroup --name $VM1 --image $image --vnet-name $namevnet --size Standard_B1s --admin-username $adminname1 --admin-password $adminpass1

#Crear una vm unido en la segunda net
az vm create --resource-group $resourcegroup2 --name $VM02 --image $image --vnet-name $namevnet2 --size Standard_B1s --admin-username $adminname2 --admin-password $adminpass2
