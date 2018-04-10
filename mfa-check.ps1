#
# Identifies AWS user accounts without an MFA token that have console access (passwords).
#

Param (
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]$awsProfile
)

if ($awsProfile -eq "")
{
    $awsProfile = "default"
}

function Array-To-String([object[]]$array) {
    return ($array | out-string)
}

function Get-Aws-UserNames() {
    $usersResponse = aws iam list-users --profile $awsProfile
    $usersResponseObj = ConvertFrom-Json (Array-To-String $usersResponse)
    
    $userNames = @()
    ForEach ($user in $usersResponseObj.Users)
    {
        $userNames += $user.UserName
    }
    
    return $userNames
}

function User-Has-Password([string]$userName) {
    #
    # The get-login-profile command can be used to verify that an IAM user has a password. The command returns a NoSuchEntity error if no password is defined for the user.
    # https://docs.aws.amazon.com/cli/latest/reference/iam/get-login-profile.html
    #
    # This error is output on the error stream. 
    #
    $getLoginProfileResponse = aws iam get-login-profile --user-name $userName --profile $awsProfile 2>&1
    $getLoginProfileResponseString = Array-To-String $getLoginProfileResponse
    return (($getLoginProfileResponseString.Contains("An error occurred (NoSuchEntity) when calling the GetLoginProfile operation: Cannot find Login Profile for User")) -eq $false)
}

function User-Does-Not-Have-Mfa([string]$userName) {
    $listMfaDevicesResponse = aws iam list-mfa-devices --user-name $userName --profile $awsProfile
    $listMfaDevicesResponseObj = ConvertFrom-Json (Array-To-String $listMfaDevicesResponse)
    return ($listMfaDevicesResponseObj.MFADevices.Length -lt 1)
}

$allUserNames = Get-Aws-UserNames

$usersWithPasswords = @()
ForEach ($userName in $allUserNames)
{
    if (User-Has-Password $userName)
    {
        $usersWithPasswords += $userName
    }
}

$usersWithoutMfa = @()
ForEach ($userName in $usersWithPasswords)
{
    if (User-Does-Not-Have-Mfa $userName)
    {
        $usersWithoutMfa += $userName
    }
}

Write-Output $usersWithoutMfa
