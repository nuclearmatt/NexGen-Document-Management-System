# Resizing progress bar
$pathProgressBarResize = (Get-Item $PSScriptRoot).Parent.FullName + "\PSM\ProgressBarResize.psm1"
Import-Module $pathProgressBarResize
ProgressBarResize($Host)

# Declaring all necessary module, output, and target paths relative to script location
$ScanResultsCSV = (Get-Item $PSScriptRoot).Parent.FullName + "\DAT\ScanResults.csv"
$TargetPath = (Get-Item $PSScriptRoot).Parent.Parent.FullName + "\Digital Facility Records"

# Initially determining the total number of files to be scanned, for the progress bar
$PreScanCount = 0
Get-ChildItem -Path $TargetPath -Recurse -File | ForEach-Object{$PreScanCount++}

# Scanning through and parsing out the file names to produce the output tables
$ScanCount = 0

$ScanResults = Get-ChildItem -Path $TargetPath -Recurse -File | 
    ForEach-Object{
        $SC,$FN,$DT,$AI,$MULT = $_.BaseName -split '_'
        [PSCustomObject][Ordered]@{
            SiteCode = $SC
            FacilityNumber = $FN
            DocumentType = $DT
            AdditionalInformation = $AI
            MultiplicityModifier = $MULT
            FileName = $_.BaseName
            HyperlinkPath = $_.FullName       
        }
        # Evaluating scanning progress
        $ScanCount++
        Write-Progress -Activity "Scanning Files" -Status "Files Found $ScanCount" -PercentComplete ($ScanCount/$PreScanCount*100)
         
    } | Export-Csv -NoTypeInformation -Path $ScanResultsCSV
