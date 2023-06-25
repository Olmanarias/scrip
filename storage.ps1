#Crear resource group
az group create --location eastus --name Olmanarias 

#crear storage en location eastus como cuenta principal
az storage account create --name storageoleast --resource-group Olmanarias --access-tier cool --location eastus --sku Standard_LRS --enable-alw false

#crear el container principal
az storage container create --name almacenamiento1 --account-name storageoleast 

#crar un nuevo storage en location westus como respaldo
az storage account create --name storageolwest --resource-group Olmanarias --access-tier cool --location westus --sku Standard_GRS --enable-alw false

#crear un container secundario
az storage container create --name almacenamiento2 --account-name storageolwest 
    
#subir un archivo en el container principal
az storage blob upload --account-name storageoleast --container-name almacenamiento1 --name pug --file .\pugy.jpg

#Crear la redundancia de los storage
az storage account or-policy create --resource-group Olmanarias --account-name storageoleast --destination-account storageolwest --source-account storageoleast --destination-container almacenamiento2 --source-container almacenamiento1
    