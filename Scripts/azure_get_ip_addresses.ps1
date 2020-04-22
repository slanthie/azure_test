# This script will get all VM names and their pubic ip addresses

#MAIN

$RGs=@()
$VMs=@()

#Remove the Select-String if you want all resource groups, not just devtest ones
foreach ( $RG in ((Get-AzureRmResourceGroup).ResourceGroupName)|Select-String -Pattern 'devtest') {
	echo $RG
		$RGs = $RGs + $RG
}

 foreach ($RG in $RGs) {
 	echo " "
 	echo $RG
 	echo "-----------------------------"
   foreach ($VM in (Get-AzVM -ResourceGroupName $RG).Name){

   	$VMINFO=Get-AzureRmVM -ResourceGroupName $RG -Name $VM
   	$NICNAME=$VMINFO.NetworkProfile.NetworkInterfaces[0].Id.Split('/') | select -Last 1

   	$publicIpName =  (Get-AzureRmNetworkInterface -ResourceGroupName $RG -Name $NICNAME).IpConfigurations.PublicIpAddress.Id.Split('/') | select -Last 1

	$publicIpAddress = (Get-AzureRmPublicIpAddress -ResourceGroupName $RG -Name $publicIpName).IpAddress

	Write-Output $VM $publicIpAddress
   }
 }



#$sub_GUID="8b3b4b55-8760-464e-b1f6-841ffc802635"
#$RG_devlab_Name="CENXUI_DevTestLabs_EastUS_RG"
#$LabName="CENXUI_DevTestLabs_EastUS"


#$Resource = Get-AzureRmResource -ResourceId "/subscriptions/$sub_GUID/resourcegroups/$RG_devlab_Name/providers/microsoft.devtestlab/labs/$LabName/virtualmachines/$VMName"
#echo "Resource is $Resource"

#$Resource.Properties.computeId -match 'resourceGroups/(.+)/providers'
#$RGName = $Matches[1]
#$IP = (Get-AzureRmNetworkInterface -Name $VMName -ResourceGroupName $RGName).IpConfigurations.PrivateIpAddress
