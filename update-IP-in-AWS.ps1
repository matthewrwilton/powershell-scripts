# Script to grant current machine (IP) address access to AWS resources by adding rules into security groups.
# Also removes any rules added for the previous IP the machine had (if different).

function SecurityGroupRule($name, $id, $protocol, $port)
{
    $securityGroupRule = @{}
    $securityGroupRule.Name = $name
    $securityGroupRule.Id = $id
    $securityGroupRule.Protocol = $protocol
    $securityGroupRule.Port = $port

    return $securityGroupRule
}

function Delete-Old-Entry($securityGroupRule)
{
    Write-Output ("Removing ingress permission " + $securityGroupRule.Protocol + " " + $securityGroupRule.Port + " from " + $securityGroupRule.Name + " ...")
    aws ec2 revoke-security-group-ingress --group-id $securityGroupRule.Id --protocol $securityGroupRule.Protocol --port $securityGroupRule.Port --cidr ($lastIP + "/32")
    Write-Output "Done."
    Write-Output ""
}

function Add-Entry($securityGroupRule)
{
    Write-Output ("Adding ingress permission " + $securityGroupRule.Protocol + " " + $securityGroupRule.Port + " to " + $securityGroupRule.Name + " ...")
    aws ec2 authorize-security-group-ingress --group-id $securityGroupRule.Id --protocol $securityGroupRule.Protocol --port $securityGroupRule.Port --cidr ($myIP + "/32")
    aws ec2 update-security-group-rule-descriptions-ingress --group-id $securityGroupRule.Id --ip-permissions ('FromPort=' + $securityGroupRule.Port + ',ToPort=' + $securityGroupRule.Port + ',IpProtocol="' + $securityGroupRule.Protocol + '",IpRanges=[{CidrIp="' + $myIP + '/32",Description="Matt"}]')
    Write-Output "Done."
    Write-Output ""
}

$rules = @(
    (SecurityGroupRule "Example1" "sg-12345" "tcp" 22),
    (SecurityGroupRule "Example2" "sg-12346" "tcp" 443)
)

$lastIPFileName = $PSScriptRoot + "\lastIP.txt"

if (Test-Path -Path $lastIPFileName)
{
    $lastIP = Get-Content $lastIPFileName
}

$myIP = Invoke-RestMethod http://ipinfo.io/json | Select -exp ip

if ($lastIP -eq $myIP)
{
    Write-Output "IP address is the same. Nothing to update."
    Write-Output ""
}
else
{
    if ($lastIP)
    {
        ForEach ($securityGroupRule in $rules)
        {
            Delete-Old-Entry $securityGroupRule
        }
    }

    try
    {
        ForEach ($securityGroupRule in $rules)
        {
            Add-Entry $securityGroupRule
        }
    }
    finally
    {
        Write-Output $myIP > $lastIPFileName
    }
}

Write-Output "Finished. Press any key to continue ..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
