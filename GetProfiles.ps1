

param (
    [int]$ErrorProfile = 0,
    [string]$ApplianceData =".\ApplianceData.csv"
)

function GetAllProfiles {
    $Profiles = Get-HPOVServerProfile
    foreach ($Profile in $Profiles) {
        write-host "Fix profile:", $Profile.Name
        # We have a cmdlet that creates a powershell
        # script from an existing profile.  Save that to a temp profile script
        Get-HPOVServerProfile -name $Profile.Name | convertto-HPOVPowerShellscript > TempSP.ps1
        # Change virtual SN setting to physical SN setting
        # TODO: Code goes here th change TempSP.ps1 setting for Physical SN
        # need to shutdown server, unassign the existing profile and run the TempSP.ps1 script

        # TODO: Check, this has not been tested or debuged
        # The Profile contains the current power state.  Check that state and power off
        # for GOOD code we should have some check before power off.  This is kinda
        # brutal.
        if ($Profile.Status -ne "Off") {
            Write-Host "Server $($_.Name) is $($_.PowerState).  Powering off..."
            Stop-HPOVServer -Server $_ -Force -Confirm:$false | Wait-HPOVTaskComplete
        }
    
        # TODO: Check, this has not been tested or debuged
        # This just deletes the existing profile.  We could also just unassign and save but this creates a lot of
        # unused profiles that may be difficult to understand over time
        $tasks = Get-HPOVServerProfileTemplate | Remove-HPOVServerProfileTemplate -Confirm:$false | Wait-HPOVTaskComplete
        if ($tasks | ? taskState -ne 'Completed') { 
            $Tasks | ? taskState -ne 'Completed' | Format-List
            Write-Error '1 or more Remove Server Profile Template tasks failed to complete successfully.' -ErrorAction Stop
        }

        # TODO: Run TempSP.PS1 against the appliance with the unassigned server
        # forget how to exec TempSP.ps1 ... look this up

        # TODO: Check that the profile applied properly
        # and if it did remove tempsp.ps1 after 
    }
}

#############################################################################
## Main Program
#############################################################################

# Assume there are multiple OneView/Composer appliances
# Createa text file $ApplianceData

if ( -not (Test-path -Path $ApplianceData)) {
    write-host "No file specified or file $ApplianceData does not exist.  Unable to install system"
    exit
}
# Read the CSV Users file
$tempFile = [IO.Path]::GetTempFileName()
Get-Content $ApplianceData | Where-Object { ($_ -notlike ",,,,,,,,*") -and  ( $_ -notlike "#*") -and ($_ -notlike ",,,#*") } > $tempFile   # Skip blank line
# Get-Content $ProfData > $tempFile   # Skip blank line ($_ -notlike '"*') -and

$Appliances = import-csv $tempFile
[string]$OVName       = $Appliances.OVName
[string]$OVUser       = $Appliances.OVUser
[string]$OVPass       = $Appliances.OVPass
[string]$OVDomain     = $Appliances.OVDomain


write-host -ForegroundColor Magenta "Connect to OneView appliance:$OVName"
if ( !$ConnectedSessions ) {
    $secpasswd = ConvertTo-SecureString $OVPass -AsPlainText -Force
    $OVCreds = New-Object System.Management.Automation.PSCredential ("$OVUser", $secpasswd)
    $MyConnection = Connect-HPOVMgmt -hostname $OVName -Credential $OVCreds -AuthLoginDomain $OVDomain
} else {
    Write-Host -ForegroundColor Magenta "Already connected to $OVName"
}

GetAllProfiles
# Write-Host "ErrorProfile: ",$ErrorProfile
Disconnect-HPOVMgmt 
