#Static variables
#Datacenter location
$locName = Read-Host -Prompt "Input DataCenter Location: northeurope"
#Resource Group Name
$rgName = Read-Host -Prompt "Input Resource Group Name: Demo"
#Storage Account
$stName = Read-Host -Prompt "Input Storage Account Name: itiscloudydemo01"
#Virtual network
$vnetName = Read-Host -Prompt "Input Virtual Network Name: itiscloudydemo"

#Dynamic variables
#Public IP Name
$ipName = Read-Host -Prompt "Input Public IP Name: DEMO-SERVER01"
#Network Interface name
$nicName = Read-Host -Prompt "Input Network Interface Name: DEMO-SERVER01"
#Prompt for local administrative credentials
$cred = Get-Credential -Message "Type the name and password of the local administrator account."
#VM Name
$vmName = Read-Host -Prompt "Input Virtual Machine Name: DEMO-SERVER01"
#VM Size
$vmSize = Read-Host -Prompt "Input Vm Size Name: Standard_F1"
#Computer Name
$compName = Read-Host -Prompt "Input Computer Name: DEMO-SERVER01"
#Publisher Name
$pubName = Read-Host -Prompt "Input Publisher Name: MicrosoftWindowsServer"
#Offer Name
$offer = Read-Host -Prompt "Input Offer Name: WindowsServer"
#Sku Name
$sku = Read-Host -Prompt "Input Sku Name: Windows-Server-Technical-Preview"
#Version
$version = Read-Host -Prompt "Input Offer Version: Latest"
#Blob Storage Path
$blobPath = Read-Host -Prompt "Input Blob Storage Path: vhds/DEMO-DC02.vhd"
#OS Disk Name
$diskName = Read-Host -Prompt "Input OSdisk Name: DEMO-DC02-OSdisk01"

#Get-AzureRmStorageAccountNameAvailability $stName

$storageAcc = Get-AzureRmStorageAccount -ResourceGroupName $rgName -Name $stName
$vnet = Get-AzureRmVirtualNetwork -ResourceGroupName $rgName -Name $vnetName
$singleSbunet = Get-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $vnet
$pip = New-AzureRmPublicIpAddress -Name $ipName -ResourceGroupName $rgName -Location $locName -AllocationMethod Dynamic
$nic = New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $locName -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id
$vm = New-AzureRmVMConfig -VMName $vmName -VMSize $vmSize
$vm = Set-AzureRmVMOperatingSystem -VM $vm -Windows -ComputerName $compName -Credential $cred -ProvisionVMAgent -EnableAutoUpdate
$vm = Set-AzureRmVMSourceImage -VM $vm -PublisherName $pubName -Offer $offer -Skus $sku -Version $version
$vm = Add-AzureRmVMNetworkInterface -VM $vm -Id $nic.Id
$osDiskUri = $storageAcc.PrimaryEndpoints.Blob.ToString() + $blobPath
$vm = Set-AzureRmVMOSDisk -VM $vm -Name $diskName -VhdUri $osDiskUri -CreateOption fromImage

#Create the Virtual Machine
New-AzureRmVM -ResourceGroupName $rgName -Location $locName -VM $vm