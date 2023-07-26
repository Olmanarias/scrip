#Diferentes variables
$namegroup = "recursosvm"
$location = "westus2"
$publicip = "mypublicip"
$balanceador = "balanceadorvm"
$namesondeo = "sde"
$addressbackpool = "adpool"
$namevnet = "Vnetol"
$prefix = "10.1.0.0/16"
$subnetname = "subnetvm"
$prefixsubnet = "10.1.0.0/24"
$backend = "backdoor"
$frontend = "frontline"
$config = "lbrule"
$nsg = "Security"
$nsgrule = "rulensg"
$namevm = "virtualmc"
$image = "UbuntuLTS"
$nameadmin = "olmannoe"
$adminpassword = "Ariascuevas24?"
$size = "Standard_B2s"


#crear un resource group
az group create --location $location --name $namegroup

#crear Vnet con subnet
az network vnet create --name $namevnet --resource-group $namegroup --location $location --address-prefix $prefix --subnet-name $subnetname --subnet-prefix $prefixsubnet

#Crear network security group
az network nsg create --resource-group $namegroup --name $nsg

#crear ip pulica
az network public-ip create --resource-group $namegroup --location $location --allocation-method Static --name $publicip --sku Standard --zone 1, 2, 3

#crear un balanceador de carga
az network lb create --resource-group $namegroup --name $balanceador --sku Standard --public-ip-address $publicip --location $location --frontend-ip-name $frontend --backend-pool-name $backend

#crear heatl probe port on 80
az network lb probe create --resource-group $namegroup --lb-name $balanceador --name $namesondeo --protocol Tcp  --port 80

#configurar regla para balancear la carga
az network lb rule create --resource-group $namegroup --lb-name $balanceador --name $config --protocol tcp --frontend-port 80 --backend-port 80 --frontend-ip-name $frontend --backend-pool-name $backend --probe-name $namesondeo --disable-outbound-snat true --idle-timeout 15

#Crear netweork security group rule
az network nsg rule create --resource-group $namegroup --nsg-name $nsg --name $nsgrule --protocol tcp --direction inbound --source-address-prefix '*' --source-port-range '*'  --destination-address-prefixes '*' --destination-port-range 80 --access allow --priority 200 

#Crear nic
$no_Of_NIC = 1,2,3
foreach($i in $no_Of_NIC ){
 
    az network nic create --resource-group $namegroup --name myNic$i --vnet-name $namevnet --subnet $subnetname --network-security-group $nsg --lb-name $balanceador --lb-address-pools $backend
}

#crear vm con zona
$no_Of_VM = 1,2,3
foreach($i in $no_Of_VM ){
 
  az vm create --resource-group $namegroup --name $namevm$i --nics myNic$i --image $image --admin-username $nameadmin --admin-password $adminpassword --zone $i --custom-data "D:\Repositories\script\mvzona-config"
}
