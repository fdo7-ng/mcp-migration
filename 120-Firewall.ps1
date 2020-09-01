$VerbosePreference = "Continue"

Write-Verbose "Start Script"

# $fw_file = './output/firewall_Advanced_POC.json'
# $fw_data = Get-Content $fw_file -ErrorAction SilentlyContinue | ConvertFrom-JSON 
# $fw_data.data.acl


# $ip_file = './output/ip_list.json'
# $ip_data = Get-Content $ip_file -ErrorAction SilentlyContinue | ConvertFrom-JSON 
# $ip_list = $ip_data.data.ip_list


$json_file = "./output/custard.json"
$json_data = Get-Content $json_file -ErrorAction SilentlyContinue | ConvertFrom-JSON 

$firewallRules = $json_data.networkDomain.firewallRule
$ipAddressList = $json_data.networkDomain.ipAddressList
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
foreach ($fw in ( $firewallRules[0..50] | ? { $_.name -notlike "CCDEFAULT.*" }) ){

    Write-Verbose "$index --  $($fw.name)" 
    $tmp_obj = New-Object psobject -Property $nsg_props
    $tmp_obj.properties = New-Object psobject -Property $nsg_props.properties
    $tmp_obj.name = $fw.name
    $tmp_obj.properties.priority = $index
    $tmp_obj.properties.description = $fw.name
    $tmp_obj.properties.protocol = $fw.protocol
    $tmp_obj.properties.access = Get-FwAction -Action $fw.action 
    

    #Processing Source/Destination

    if(isIPAddressList( $fw.source)){
        Write-Verbose "[Source] -- Found IP Address List -- [ $($fw.source.ipAddressList.Name) ]" 
        # $ip_obj = Get-IPAddressListObj -ip_list $ipAddressList  -name $fw.source.ipAddressList.Name
        $ip_obj = Get-IPAddressListObj -ip_list $ipAddressList  -id $fw.source.ipAddressList.id
        $tmp_obj.properties.sourceAddressPrefix = Get-IPAddressList -ipAddressObj $ip_obj
        
    }elseif( $fw.source.ip.address -eq "ANY" )  {
        Write-Verbose "[Source] -- IP is ANY "
        $tmp_obj.properties.sourceAddressPrefix = "*"
    }else{
        $tmp_obj.properties.sourceAddressPrefix = $fw.source.ip.address
    
    }

    if(isIPAddressList( $fw.destination)){
        Write-Verbose "[Destination] -- Found IP Address List -- [ $($fw.destination.ipAddressList.Name) ]"
        # $ip_obj = Get-IPAddressListObj -ip_list $ipAddressList  -name $fw.destination.ipAddressList.Name
        $ip_obj = Get-IPAddressListObj -ip_list $ipAddressList  -id $fw.destination.ipAddressList.id

        $tmp_obj.properties.destinationAddressPrefix = Get-IPAddressList -ipAddressObj $ip_obj 
    }elseif( $fw.destination.ip.address -eq "ANY" )  {
        Write-Verbose "[Destination] -- IP is ANY "
        $tmp_obj.properties.destinationAddressPrefix = "*"
    }else{
        Write-Verbose "[Destination] -- IP is $($fw.destination.ip.address) " 
        $tmp_obj.properties.destinationAddressPrefix = $fw.destination.ip.address
    }



    $index +=10
    $obj_list += $tmp_obj
} # end of for Loop

$obj_list.properties





# Testing IP LIST 
## Excluding CCDefault Rules
<#
foreach ($fw in ($fw_data.data.acl | ? { $_.name -notlike "CCDEFAULT.*" }) ) {

    Write-Host $fw.Name -ForegroundColor Yellow
    
    if(isIPAddressList( $fw.source)){
        Write-Host "[Source] -- Found IP Address List -- [ $($fw.source.ipAddressList.Name) ]" -ForegroundColor Yellow
        $ip_obj = Get-IPAddressListObj -ip_list $ip_list -name $fw.source.ipAddressList.Name
        Get-IPAddressList -ipAddressObj $ip_obj
    }elseif( $fw.source.ip.address -eq "ANY" )  {
        Write-Host "[Source] -- Any" -ForegroundColor Yellow
    }

    if(isIPAddressList( $fw.destination)){
        Write-Host "[Destination] -- Found IP Address List -- [ $($fw.destination.ipAddressList.Name) ]" -ForegroundColor Yellow
        $ip_obj = Get-IPAddressListObj -ip_list $ip_list -name $fw.destination.ipAddressList.Name
        Get-IPAddressList -ipAddressObj $ip_obj 
    }elseif( $fw.destination.ip.address -eq "ANY" )  {
        Write-Host "[destination] -- Any" -ForegroundColor Yellow
    }


}
#>


# Testing IP List
#$iplist1= Get-IPAddressListObj -ip_list $ip_list -name "google_list"
#Get-IPAddressList  $iplist1