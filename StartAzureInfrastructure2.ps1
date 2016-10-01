#Variables

#Datacenter location
$locName = "northeurope"
#Resource Group Name
$rgName = "DEMO"
#Storage Account
$stName = "itiscloudydemo01"
#Virtual subnet
$subnetName = "itiscloudydemo"
#Virtual subnet 2
$subnetName2 = "itiscloudydemo2"
#Virtual network
$vnetName = "itiscloudydemo"

#Create a Resource Group
New-AzureRmResourceGroup -Name $rgName -Location $locName -Force
#Create a Storage Account
$storageAcc = New-AzureRmStorageAccount -ResourceGroupName $rgName -Name $stName -SkuName "Standard_GRS" -Kind "Storage" -Location $locName
#Create a Virtual Network Subnet
$singleSubnet = New-AzureRmVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix 10.0.0.0/24
$secondSubnet = New-AzureRmVirtualNetworkSubnetConfig -Name $subnetName2 -AddressPrefix 10.1.0.0/24
#Create a Virtual Network
$vnet = New-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName -Location $locName -AddressPrefix 10.0.0.0/16 -Subnet $singleSubnet, $secondSubnet