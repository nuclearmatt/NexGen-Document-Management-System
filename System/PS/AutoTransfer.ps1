# Resizing progress bar
$pathProgressBarResize = (Get-Item $PSScriptRoot).Parent.FullName + "\PSM\ProgressBarResize.psm1"
Import-Module $pathProgressBarResize
ProgressBarResize($Host)

# Dropbox and Digital Database paths
$pathTransferQue = (Get-Item $PSScriptRoot).Parent.FullName + "\DAT\RecordsDropbox\"
$pathDigitalDatabase = (Get-Item $PSScriptRoot).Parent.Parent.FullName + "\Digital Facility Records\Active Facilities\"

$PreTransferCount = 0
Get-ChildItem -Path $pathTransferQue -Recurse -File | ForEach-Object{$PreTransferCount++}

$TransferCount = 0

Get-ChildItem -Path $pathTransferQue -Recurse -File | 

    ForEach-Object{

        $strSiteCode,$strFacilityNumber, $strNumber = $_.BaseName -split ' ' 
        $strPathName = $_.FullName
        $strPathNameParent = Split-Path (Split-Path $strPathName -Parent) -Leaf
        $strExtension = $_.Extension

        $strNewName = 
                    if (([int]$strFacilityNumber -lt 10) -and ([int]$strFacilityNumber -gt 0)) {
                        $strSiteCode.ToUpper() + "_0000" + $strFacilityNumber + "_" + $strPathNameParent.Split(" ")[0] + $strNumber + $strExtension
                        }
                    elseif (([int]$strFacilityNumber -ge 10) -and ([int]$strFacilityNumber -lt 100)) {
                        $strSiteCode.ToUpper() + "_000" + $strFacilityNumber + "_" + $strPathNameParent.Split(" ")[0] + $strNumber + $strExtension
                        }
                    elseif (([int]$strFacilityNumber -ge 100) -and ([int]$strFacilityNumber -lt 1000)) {
                        $strSiteCode.ToUpper() + "_00" + $strFacilityNumber + "_" + $strPathNameParent.Split(" ")[0] + $strNumber + $strExtension
                        }
                    elseif (([int]$strFacilityNumber -ge 1000) -and ([int]$strFacilityNumber -lt 10000)) {
                        $strSiteCode.ToUpper() + "_0" + $strFacilityNumber + "_" + $strPathNameParent.Split(" ")[0] + $strNumber + $strExtension
                        }
                    elseif ([int]$strFacilityNumber -ge 10000) {
                        $strSiteCode.ToUpper() + "_" + $strFacilityNumber + "_" + $strPathNameParent.Split(" ")[0] + $strNumber + $strExtension
                        }

        $strFolderName = 
                    if (([int]$strFacilityNumber -lt 10) -and ([int]$strFacilityNumber -gt 0)) {
                            $strSiteCode.ToUpper() + "_0000" + $strFacilityNumber
                            }
                    elseif (([int]$strFacilityNumber -ge 10) -and ([int]$strFacilityNumber -lt 100)) {
                            $strSiteCode.ToUpper() + "_000" + $strFacilityNumber 
                            }
                    elseif (([int]$strFacilityNumber -ge 100) -and ([int]$strFacilityNumber -lt 1000)) {
                            $strSiteCode.ToUpper() + "_00" + $strFacilityNumber
                            }
                    elseif (([int]$strFacilityNumber -ge 1000) -and ([int]$strFacilityNumber -lt 10000)) {
                            $strSiteCode.ToUpper() + "_0" + $strFacilityNumber
                            }
                    elseif ([int]$strFacilityNumber -ge 10000) {
                            $strSiteCode.ToUpper() + "_" + $strFacilityNumber
                            }     

        $pathDigitalFolder = $pathDigitalDatabase + $strFolderName
        $pathNewPath = $pathTransferQue + $strPathNameParent + "\" + $strNewName

        #Renaming the raw file
        Rename-Item -Path $_.FullName -NewName $strNewName

        #Moving the newly renamed file, creating a new directory if one does not exist
        if (Test-Path $pathDigitalFolder){ 
        Move-Item $pathNewPath -Destination $pathDigitalFolder -Force
        }
        else {
        New-Item -Path $pathDigitalFolder -ItemType Directory
        Move-Item $pathNewPath -Destination $pathDigitalFolder -Force
        }
        $TransferCount++
        Write-Progress -Activity "Transferring Files" -Status "Files Found $TransferCount" -PercentComplete ($TransferCount/$PreTransferCount*100)
    }

