#Variables
$namegroup = "resource"
$location = "eastus2"
$vnet = "vnet"
$prefix = "10.1.0.0/16"
$subnet = "subnet"
$prefixsub = "10.1.0.0/24"
$vmss = "vmsscale"
$image = "UbuntuLTS"
$name = "olmannoe"
$password = "Ariascuevas24?"
$autoscale = "autoscale"
$minInstances = 1
$maxInstances = 6
$baseInstances = 2
$scaleUpThreshold = 80
$scaleDownThreshold = 20

#crear resource group
az group create --name $namegroup --location $location

#crear vnet
az network vnet create --resource-group $namegroup --name $vnet --location $location --address-prefix $prefix --subnet-name $subnet --subnet-prefix $prefixsub

#crear el scale set
az vmss create --resource-group $namegroup --name $vmss --location $location --image $image --vnet-name $vnet --subnet $subnet --orchestration-mode Flexible --instance-count 2 --admin-username $name --admin-password $password 

#az monitor autoscale create
az monitor autoscale create --resource-group $namegroup --resource $vmss --resource-type 'Microsoft.Compute/virtualMachineScaleSets' --name $autoscale --min-count $minInstances --max-count $maxInstances --count $baseInstances

#reglas de subida
az monitor autoscale rule create --resource-group $namegroup --autoscale-name $autoscale --condition "Percentage CPU > 80 avg 1m" --scale out 1

#regla de bajada
az monitor autoscale rule create --resource-group $namegroup --autoscale-name $autoscale --condition "percentage CPU < 20 avg 1m" --scale in 1