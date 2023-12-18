# Get Full path of mounted VHD from physical drive (\\.\physicalDrivex)
# returns the path of media storage 
# Model= 'Msft Virtual Disk SCSI Disk Device'
# or in french cultur environment, Model= 'Disque virtuel Microsoft'
# It's possible to use InterfaceType property for resolv Model property cultur environment

function GetFullPathOfMountedVHDFromPhysicalDrive($PhysicalDrive){
   
   [String]$ExprQuery="SELECT * FROM Win32_DiskDrive WHERE DeviceID='$($PhysicalDrive.Replace("\", "\\"))'"
   $Disk = Get-WmiObject -Query $ExprQuery
   $Disk

   if ($Disk.InterfaceType -eq "SCSI"){
     write-host("Présence d'un disque SCSI (VHD/VHDX éventuellement)")
     [String]$ExprQuery="SELECT * FROM MSVM_MountedStorageImage WHERE Lun='$($Disk.SCSILogicalUnit)' AND PortNumber='$($Disk.SCSIPort)'"
     $MountedDiskImage = Get-WmiObject -Namespace root\virtualization\v2 -query $ExprQuery
     return $MountedDiskImage.Name
   }
   else 
   {
     write-host("Disque classique");
   }
}

GetFullPathOfMountedVHDFromPhysicalDrive("\\.\PHYSICALDRIVE2")

pause

