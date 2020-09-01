$fw_file = './output/firewall_Advanced_POC.json'
$fw_data = Get-Content $fw_file -ErrorAction SilentlyContinue | ConvertFrom-JSON 
$fw_data.data.acl

# Create NSG OBJECT
$nsg_props = [ordered]@{
    "name" = ""
    "properties" = @{
        "description" = ""
        "protocol" = ""
        "sourcePortRange" = ""
        "sourceAddressPrefix" = ""
        "destinationAddressPrefix" = ""
        "access" = ""
        "priority" = 0
        "direction" = ""
        "sourcePortRanges" = ""
        "destinationPortRanges"= ""
        "sourceAddressPrefixes"= ""
        "destinationAddressPrefixes"= ""
        "sourceApplicationSecurityGroupIds"= ""
        "destinationApplicationSecurityGroupIds"= ""
    }
}


# action          : DROP| Accept Decisively
# datacenterId    : GEN_SAP1_GEO1_3
# destination     : @{ip = ; port = }
# enabled         : True | False
# id              : dd23b182-7c0d-4547-b4fa-7ad909c2ab74
# ipVersion       : IPV4 | IPV6
# name            : CCDEFAULT.BlockOutboundMailIPv4
# networkDomainId : bfb35883-94c5-46ac-9c51-17260c01b99f
# protocol        : TCP | UDP | ICMP | IP
# ruleType        : DEFAULT_RULE
# source          : @{ip = }
# state           : NORMAL

$obj_list = @()
$index = 100
## Skip all CCDEFAULT rules
foreach ($fw in ($fw_data.data.acl| ?{$_.name -notlike "CCDEFAULT.*"}) ){

    Write-Host $index "-- " $fw.name 
    $tmp_obj = New-Object psobject -Property $nsg_props
    $tmp_obj.properties = New-Object psobject -Property $nsg_props.properties
    $tmp_obj.name = $fw.name
    $tmp_obj.properties.priority = $index
    $tmp_obj.properties.description = $fw.name
    $tmp_obj.properties.protocol = $fw.protocol
    $tmp_obj.properties.access = Get-FwAction -Action $fw.action 
    
    $index +=10

    $obj_list += $tmp_obj
}

$obj_list


$ip_file = './output/ip_list.json'
$ip_data = Get-Content $ip_file -ErrorAction SilentlyContinue | ConvertFrom-JSON 
$ip_list = $ip_data.data.ip_list



# Testing IP LIST
foreach ($fw in ($fw_data.data.acl | ? { $_.name -notlike "CCDEFAULT.*" }) ) {

    Write-Host $fw.Name 
    if(isIPAddressList( $fw.destination)){
        $fw.destination.name
    }
}


$iplist1= Get-IPAddressListObj -ip_list $ip_list -name "google_list"
Get-IPAddressList -ip_list $iplist1