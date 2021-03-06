# -------------- Attributes for ServerProfile "bl460 esx server01"
$name                               = "bl460 esx server01"
$server                             = Get-HPOVServer -Name "Encl1, bay 3"
$affinity                           = "Bay"
# -------------- Connections section
# -------------- Attributes for connection "1"
$connID                             = 1
$connName                           = "Prod-A"
$connType                           = "Ethernet"
$netName                            = "Prod"
$ThisNetwork                        = Get-HPOVNetworkSet -Name $netName
$portID                             = "Flb 1:1-a"
$requestedMbps                      = 2500
$Conn1                              = New-HPOVServerProfileConnection -ConnectionID $connID -Name $connName -ConnectionType $connType -Network $ThisNetwork -PortId $portID -RequestedBW $requestedMbps
# -------------- Attributes for connection "2"
$connID                             = 2
$connName                           = "Prod-B"
$connType                           = "Ethernet"
$netName                            = "Prod"
$ThisNetwork                        = Get-HPOVNetworkSet -Name $netName
$portID                             = "Flb 1:2-a"
$requestedMbps                      = 2500
$Conn2                              = New-HPOVServerProfileConnection -ConnectionID $connID -Name $connName -ConnectionType $connType -Network $ThisNetwork -PortId $portID -RequestedBW $requestedMbps
# -------------- Attributes for connection "3"
$connID                             = 3
$connName                           = "FCoE-A"
$connType                           = "FibreChannel"
$netName                            = "SAN A FCoE"
$ThisNetwork                        =  -Name $netName
$portID                             = "Flb 1:1-b"
$requestedMbps                      = 2500
$Conn3                              = New-HPOVServerProfileConnection -ConnectionID $connID -Name $connName -ConnectionType $connType -Network $ThisNetwork -PortId $portID -RequestedBW $requestedMbps
# -------------- Attributes for connection "4"
$connID                             = 4
$connName                           = "FCoE-B"
$connType                           = "FibreChannel"
$netName                            = "SAN B FCoE"
$ThisNetwork                        =  -Name $netName
$portID                             = "Flb 1:2-b"
$requestedMbps                      = 2500
$Conn4                              = New-HPOVServerProfileConnection -ConnectionID $connID -Name $connName -ConnectionType $connType -Network $ThisNetwork -PortId $portID -RequestedBW $requestedMbps
$connections                        = $Conn1, $Conn2, $Conn3, $Conn4
# -------------- Attributes for Boot Mode settings
$manageboot                         = $True
$biosBootMode                       = "UEFI"
$secureBoot                         = "Disabled"
# -------------- Attributes for boot order settings
$bootOrder                          = "HardDisk"
# -------------- Attributes for advanced settings
New-HPOVServerProfile -Name $name -AssignmentType Server -Server $server -Affinity $affinity -Connections $connections -ManageBoot:$manageboot -BootMode $biosBootMode -SecureBoot $secureBoot -BootOrder $bootOrder -Bios -HideUnusedFlexNics $true

