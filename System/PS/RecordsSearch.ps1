# Module Path
$pathRecordsSearchLoader = (Get-Item $PSScriptRoot).Parent.FullName + "\PSM\RecordsSearchLoader.psm1"

# XAML Path
$pathXAML_RecordsSearch = (Get-Item $PSScriptRoot).Parent.FullName + "\XAML\RecordsSearch.xaml"

# CSV Path
$ScanResultsCSV = (Get-Item $PSScriptRoot).Parent.FullName + "\DAT\ScanResults.csv"
 
$DigitalRecordsCSV = Import-Csv $ScanResultsCSV

Import-Module $pathRecordsSearchLoader

RecordsSearchLoader($pathXAML_RecordsSearch)

# Creating clickable buttons
$OpenSelectFile_Button = $xamGUI02.FindName('OpenSelectedFile')
$SearchFiles_Button = $xamGUI02.FindName('SearchFiles')

# Connecting to the XAML combo boxes and fill boxes
$ListBox_Selector = $xamGUI02.FindName('HyperListView')
$SiteCodeSearchCombo_Selector = $xamGUI02.FindName('SiteCodeSearchCombo')
$FacNumberFillBox_Selector = $xamGUI02.FindName('FacNumberFillBox')
$DocTypeSearchCombo_Selector = $xamGUI02.FindName('DocTypeSearchCombo')
$AddInfoSearch_Selector = $xamGUI02.FindName('AdditionalInfoFillBox')


$OpenSelectFile_Button.add_click({
    Invoke-Item $ListBox_Selector.SelectedItem.Hyperlink
})

$SearchFiles_Button.add_click({
    $HyperListView.Items.Clear()
    UpdateListedDigitalFiles
})

# This function strictly adds records to the List View
Function AppendListedDigitalFiles([string]$sitecd, [string]$facnm, [string]$doctyp, [string]$addinfo, [string]$hyplnk, $hyplist){
    $hyplist.Items.add(
        [pscustomobject]@{
            'SiteCode' = $sitecd; 
            'FacilityNumber'= $facnm; 
            'DocumentType'= $doctyp;
            'AdditionalInformation' = $addinfo;
            'Hyperlink'= $hyplnk;
        }
    )          
}

# All click events converge to this function to update the list
Function UpdateListedDigitalFiles(){

# Constructing the Toggles
$strFN = $FacNumberFillBox_Selector.Text

$strFormatFN = 
    if (([int]$strFN -lt 10) -and ([int]$strFN -gt 0)) {
        "0000" + $strFN
        }
    elseif (([int]$strFN -ge 10) -and ([int]$strFN -lt 100)) {
        "000" + $strFN
        }
    elseif (([int]$strFN -ge 100) -and ([int]$strFN -lt 1000)) {
        "00" + $strFN
        }
    elseif (([int]$strFN -ge 1000) -and ([int]$strFN -lt 10000)) {
        "0" + $strFN
        }
    elseif ([int]$strFN -ge 10000) {
        $strFN
        }

$SC_Toggle = $SiteCodeSearchCombo_Selector.SelectedItem.Content.ToString()
$FN_Toggle = $strFormatFN
$DT_Toggle = $DocTypeSearchCombo_Selector.SelectedItem.Content.ToString()
$AM_Toggle = $AddInfoSearch_Selector.Text


# The only problem with this is that it prints out MAP and FLRPLN and anything else containing P for the Pictures toggle
$DigitalRecordsCSV | ForEach-Object{
    if($_.FileName -like "*" + $SC_Toggle + "*" + $FN_Toggle + "*" + $DT_Toggle + "*" + $AM_Toggle + "*"){
        AppendListedDigitalFiles $_.SiteCode $_.FacilityNumber $_.DocumentType $_.AdditionalInformation $_.HyperlinkPath $HyperListView
    }
}


}

# Method for displaying windows

# Add Exit
$xamGUI02.Add_Closing({[System.Windows.Forms.Application]::Exit(); Stop-Process $pid})
 
# Allow input to window for TextBoxes, etc
[System.Windows.Forms.Integration.ElementHost]::EnableModelessKeyboardInterop($xamGUI02)
 
# Running this without $appContext and ::Run would actually cause a really poor response.
$xamGUI02.Show()
 
# This makes it pop up
$xamGUI02.Activate()
 
# Create an application context for it to all run within. 
# This helps with responsiveness and threading.
$appContext = New-Object System.Windows.Forms.ApplicationContext 
[void][System.Windows.Forms.Application]::Run($appContext)