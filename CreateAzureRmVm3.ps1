#Static variables
#Datacenter location
$locName = "northeurope"
#Resource Group Name
$rgName = "DEMO"
#Storage Account
$stName = "itiscloudydemo01"
#Virtual subnet
$subnetName = "itiscloudydemo"
#Virtual network
$vnetName = "itiscloudydemo"

#Dynamic variables
#Public IP Name
$ipName = "DEMO-DC03"
#Primary Network Interface name
$nicName = "DEMO-DC03-NIC01"
#Second Network Interface name
$nicName2 = "DEMO-DC03-NIC02"
#Prompt for local administrative credentials
$cred = Get-Credential -Message "Type the name and password of the local administrator account."
#VM Name
$vmName = "DEMO-DC03"
#VM Size
$vmSize = "Standard_F2"
#Computer Name
$compName = "DEMO-DC03"
#Publisher Name
$pubName = "MicrosoftWindowsServer"
#Offer Name
$offer = "WindowsServer"
#Sku Name
$sku = "Windows-Server-Technical-Preview"
#Version
$version = "latest"
#Blob Storage Path
$blobPath = "vhds/DEMO-DC03.vhd"
#OS Disk Name
$diskName = "DEMO-DC03-OSdisk01"

#Get-AzureRmStorageAccountNameAvailability $stName

$storageAcc = Get-AzureRmStorageAccount -ResourceGroupName $rgName -Name $stName
$vnet = Get-AzureRmVirtualNetwork -ResourceGroupName $rgName -Name $vnetName
$singleSbunet = Get-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $vnet
$pip = New-AzureRmPublicIpAddress -Name $ipName -ResourceGroupName $rgName -Location $locName -AllocationMethod Dynamic
$nic = New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $locName -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id
$nic2 = New-AzureRmNetworkInterface -Name $nicName2 -ResourceGroupName $rgName -Location $locName -SubnetId $vnet.Subnets[0].Id
$vm = New-AzureRmVMConfig -VMName $vmName -VMSize $vmSize
$vm = Set-AzureRmVMOperatingSystem -VM $vm -Windows -ComputerName $compName -Credential $cred -ProvisionVMAgent -EnableAutoUpdate
$vm = Set-AzureRmVMSourceImage -VM $vm -PublisherName $pubName -Offer $offer -Skus $sku -Version $version
$VM = Add-AzureRmVMNetworkInterface -VM $VM -Id $nic.Id -Primary
$VM = Add-AzureRmVMNetworkInterface -VM $VM -Id $nic2.Id
$osDiskUri = $storageAcc.PrimaryEndpoints.Blob.ToString() + $blobPath
$vm = Set-AzureRmVMOSDisk -VM $vm -Name $diskName -VhdUri $osDiskUri -CreateOption fromImage

#Create the Virtual Machine
New-AzureRmVM -ResourceGroupName $rgName -Location $locName -VM $vm