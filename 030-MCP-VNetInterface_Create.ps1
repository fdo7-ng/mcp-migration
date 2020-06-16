$location = 'eastus'
$networkdomainID = 'd6f0740b-9026-4222-a0a5-f21e37c2a767'
$resourcegroup = 'fdpsrg01'
$vnet_name = 'HQ-Network' 
$subnet_name = 'SAPDRSPOC_VLAN'

$server_file = './output/servers.json'
$server_data = Get-Content $server_file | ConvertFrom-JSON 

$server_count = $server_data.data.count
$server_list = $server_data.data.server

$vnet = Get-AzureRmVirtualNetwork -Name $vnet_name

foreach ($vm in $server_list){
    $vmname = $vm.name
    $vmNicName = $vmname + "-nic0"
    $primaryNIC = $vm.networkInfo.primaryNIC
    $vlanName = $primaryNIC.vlanName
    $privateIpv4 = $primaryNIC.privateIpv4

    Write-Host "Server Name: " $vmname
    Write-Host " --- vlanName: " $vlanName
    Write-Host " --- Primary Nic IP: " $privateIpv4

    $network_interface = Get-AzNetworkInterface -ResourceGroupName $resourcegroup -Name $vmNicName -ErrorAction SilentlyContinue

    if($network_interface) {


    }else{
        Write-Host "Creating network interface - " $vmNicName


    }

}