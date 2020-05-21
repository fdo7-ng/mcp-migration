
$vnet_file = './output/vlans_SAPDRS_POC.json'

$vnet_data = get-content $vnet_file | ConvertFrom-Json

$vnet_data.data.vlan