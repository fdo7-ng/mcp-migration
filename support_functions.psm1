##Support_Functions

<#
.SYNOPSIS
    .
.DESCRIPTION
    .
.PARAMETER Path
    The path to the .
.PARAMETER LiteralPath
    Specifies a path to one or more locations. Unlike Path, the value of 
    LiteralPath is used exactly as it is typed. No characters are interpreted 
    as wildcards. If the path includes escape characters, enclose it in single
    quotation marks. Single quotation marks tell Windows PowerShell not to 
    interpret any characters as escape sequences.
.EXAMPLE
    C:\PS> 
    <Description of example>
.NOTES
#>
function Get-IPAddressList {
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
        return $nullget-ip
    }
}

Export-ModduleMember -Function "Get-IPAddressList"