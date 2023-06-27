#Definicion de Variables
$name = "Olmanarias"
$location1 = "eastus"
$location2 = "westus"
$namestorage1 = "storageoleast"
$namestorage2 = "storageolwest"
$container1 = "almacenamiento1"
$container2 = "almacenamiento2"
$namefile = "pug"
$file = ".\pugy.jpg"
$LRS = "Standard_LRS"
$GRS = "Standard_GRS"

#Crear resource group
az group create --location $location1 --name $name 

#crear storage en location eastus como cuenta principal
az storage account create --name $namestorage1 --resource-group $name --access-tier cool --location $location1 --sku $LRS --enable-alw false

#crear el container principal
az storage container create --name $container1 --account-name $namestorage1 

#crar un nuevo storage en location westus como respaldo
az storage account create --name $namestorage2 --resource-group $name --access-tier cool --location $location2 --sku $GRS --enable-alw false

#crear un container secundario
az storage container create --name $container2 --account-name $namestorage2 
    
#subir un archivo en el container principal
az storage blob upload --account-name $namestorage1 --container-name $container1 --name $namefile --file $file

