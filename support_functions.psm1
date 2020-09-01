##Support_Functions



function Get-FwAction {
    <#
        .SYNOPSIS
            This script translante Cloud Control ACL Acess into Azure NSG Access
        .DESCRIPTIOM
            Cloud Control firewall rule actions are [DROP|ACCEPT_DECISIVELY] while Azure NSG
            refer to these action as access and are either [Allow|Deny]. Functionw will
            simply transate them from CC to AZ
        .EXAMPLE
         Get-FwAction -Action "ACCEPT_DECISIVELY" 
         returns Allow
        .Notes
         Author: FNG
         Last Updated: 9/1/2020
    #>
    param(
        [Parameter(Position = 0, mandatory = $true)]
        [PSObject]$Action
    ) #end param

    if ($Action -eq "ACCEPT_DECISIVELY"){
        return "Allow"
    }elseif ($Action -eq "DROP"){
        return "Deny"
    }else{
        return $null
    }

}

<#
.SYNOPSIS
    .
.DESCRIPTION
    .
.PARAMETER Path
    The path to the .
.PARAMETER LiteralPathWindows PowerShell not to 
    interpret any characters as escape sequences.
.EXAMPLE
    C:\PS> 
    <Description of example>
.NOTES
#>
function Get-IPAddressListObj {
    param(
        [Parameter(Position = 0, mandatory = $true , HelpMessage = "IP List Object")]
        [PSObject]$ip_list,
        [Parameter(HelpMessage = "Ip List ID")]
        [string]$id,
        [Parameter(HelpMessage = "Ip List Name")]
        [string]$name
    ) #end param

    if( $id ){
        $ip_list_obj = $ip_list | ? { $_.id -eq $id}
    }
    if( $name ){
        $ip_list_obj = $ip_list | ? { $_.name -eq $name }
    }
    if ($ip_list_obj){
        return $ip_list_obj
    }else{
        return $null
    }
}


function Get-IPAddressList {
    <#
        .SYNOPSIS
            This script takes Cloud Control IpAddressList object and return IP LIST
        .DESCRIPTIOM
            Takes Cloud Control Address List and return a flat ip List.
        SAMPLE A: Contains List of IP Address
            childIpAddressList : {}
            createTime         : 2020-09-01T15:26:27.000Z
            description        : google_ip_list
            id                 : e9ebc881-71c5-467d-b5dc-3d9382956c6f
            ipAddress          : {@{begin=8.8.4.4}, @{begin=8.8.8.8}}
            ipVersion          : IPV4
            name               : google_list
            state              : NORMAL
        .EXAMPLE
         returns Allow
        .Notes
         Author: FNG
         Last Updated: 9/1/2020
    #>
    param(
        [Parameter(Position = 0, mandatory = $true)]
        [PSObject]$ipAddressObj
    ) #end param

    # Verify List
    if ( ($ipAddressObj.ipAddress | Get-Member -MemberType NoteProperty | select name -ExpandProperty Name) -eq 'begin' ){
        return $ipAddressObj.ipAddress.begin
    }else{
        return $null
    }
}



# Check if Destination or Source is an ipAddressList returns true of false
Function isIPAddressList($obj){
    $members = $obj | Get-Member -MemberType NoteProperty | select Name -ExpandProperty Name

    if( $members.contains('ipAddressList') ){
        return $true
    }else{
        return $false
    }

}






Export-ModuleMember -Function "Get-IPAddressListObj"