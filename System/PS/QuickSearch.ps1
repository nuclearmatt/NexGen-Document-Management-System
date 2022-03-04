# CSV Path
$ScanResultsCSV = (Get-Item $PSScriptRoot).Parent.FullName + "\DAT\ScanResults.csv"
 
$DigitalRecordsCSV = Import-Csv $ScanResultsCSV

$DigitalRecordsCSV | Out-GridView -PassThru -Title 'Records Quick Search'

