# Given the full path to an already mounted VHD and the name of a volume on it,
# returns the drive letter that VHD was mounted to
# Model= 'Msft Virtual Disk SCSI Disk Device'
# or in french cultur environment, Model= 'Disque virtuel Microsoft'
#
function GetDriveLetterOfMountedVHD($FullPathToVHD,$VolumeName){

   [String]$ExprQuery="SELECT * FROM MSVM_MountedStorageImage WHERE Name='$($FullPathToVHD.Replace("\", "\\"))'"
   $ExprQuery
   $MountedDiskImage = Get-WmiObject -Namespace root\virtualization\v2 -query $ExprQuery
   $MountedDiskImage
   [String]$ExprQuery="SELECT * FROM Win32_DiskDrive WHERE Model='Disque virtuel Microsoft' AND ScsiTargetID='$($MountedDiskImage.TargetId)' AND ScsiLogicalUnit='$($MountedDiskImage.Lun)' AND ScsiPort='$($MountedDiskImage.PortNumber)'"
   $Disk = Get-WmiObject -Query $ExprQuery
   $Disk
   $Partitions = $Disk.getRelated("Win32_DiskPartition")
   $LogicalDisks = $Partitions | foreach-object{$_.getRelated("win32_logicalDisk")}
   $DriveLetter = ($LogicalDisks | where {$_.VolumeName -eq $VolumeName}).DeviceID
   return $DriveLetter
}

 GetDriveLetterOfMountedVHD "D:\test.vhd" "Nouveau nom"

pause

