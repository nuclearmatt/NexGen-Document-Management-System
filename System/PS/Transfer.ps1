# Module Path
$path_TransferLoader = (Get-Item $PSScriptRoot).Parent.FullName + "\PSM\TransferLoader.psm1"

# XAML Path
$pathXAML_TransferInterface = (Get-Item $PSScriptRoot).Parent.FullName + "\XAML\TransferInterface.xaml"

# Importing Modules
Import-Module $path_TransferLoader

# Loading XAML code
TransferLoader($pathXAML_TransferInterface)

# Connecting to Clickable Buttons
$RenameFile_Button = $xamGUI07.FindName('RenameFile')
$TransferFile_Button = $xamGUI07.FindName('TransferFile')
$DropBox_Button = $xamGUI07.FindName('DropBoxButton')
$Refresh_Button = $xamGUI07.FindName('RefreshButton')

# Connecting to Fill boxes
$SiteCode_FillBox = $xamGUI07.FindName('SiteCodeFillBox')
$FacilityNumber_FillBox = $xamGUI07.FindName('FacilityNumberFillBox')
$DocumentType_FillBox = $xamGUI07.FindName('DocumentTypeFillBox')
$AdditionalModifier_FillBox = $xamGUI07.FindName('AdditionalModifierFillBox')

# Connecting to Combo boxes
$FileStatusType_Combo = $xamGUI07.FindName('FileStatusCombo')
$SiteCode_Combo = $xamGUI07.FindName('SiteCodeCombo')
$DocumentType_Combo = $xamGUI07.FindName('DocumentTypeCombo')

# Connecting to Radio buttons
$SiteCode_Radio_Combo = $xamGUI07.FindName('SiteCodeRadioCombo')
$SiteCode_Radio_Fill = $xamGUI07.FindName('SiteCodeRadioFill')
$DocumentType_Radio_Combo = $xamGUI07.FindName('DocumentTypeRadioCombo')
$DocumentType_Radio_Fill = $xamGUI07.FindName('DocumentTypeRadioFill')

# Connecting to listview 
$HyperList = $xamGUI07.FindName('FileNameListView')

# Target directory containing files to rename and transfer
$Path_TargetDropbox = (Get-Item $PSScriptRoot).Parent.FullName + "\DAT\TargetDropbox"

# Loading Paths to Images
$pathIMG = (Get-Item $PSScriptRoot).Parent.FullName + "\IMG\"

$dropboxPNG = $xamGUI07.FindName('dropboxPNG')
$dropboxPNG.Source = $pathIMG + "dropbox.png"

$transferCompPNG = $xamGUI07.FindName('transferCompPNG')
$transferCompPNG.Source = $pathIMG + "transferComp.png"

$refreshPNG = $xamGUI07.FindName('refreshPNG')
$refreshPNG.Source = $pathIMG + "refresh.png"

$renamePNG = $xamGUI07.FindName('renamePNG')
$renamePNG.Source = $pathIMG + "rename.png"

# Created Generalized scanning function
Function ScanTargetDropbox([string]$target_path){
    $scan_results = Get-ChildItem -Path $target_path -Recurse -File
    return $scan_results
}

Function AppendList($scan_results, $hyper_list){
    $scan_results | ForEach-Object{
        $hyper_list.Items.add(
            [pscustomobject]@{
                'FileNames' = $_.BaseName; 
                'FilePath' = $_.FullName;
                'FileExtension' = $_.Extension;
                'ParentFilePath' = Split-Path $_.FullName -Parent;
            }
        )    
    }
}

Function FacilityNumberReformat($facility_number){
    $new_name =
        if (([int]$facility_number -lt 10) -and ([int]$facility_number -gt 0)) {
            "0000" + $facility_number
        }
        elseif (([int]$facility_number -ge 10) -and ([int]$facility_number -lt 100)) {
            "000" + $facility_number
        }
        elseif (([int]$facility_number -ge 100) -and ([int]$facility_number -lt 1000)) {
            "00" + $facility_number
        }
        elseif (([int]$facility_number -ge 1000) -and ([int]$facility_number -lt 10000)) {
            "0" + $facility_number
        }
        elseif ([int]$facility_number -ge 10000) {
            $facility_number
        }
    return $new_name    
}

Function MultiplicityModifier($file_name, $scan_results){

    $scan_results = ScanTargetDropbox $Path_TargetDropbox
    
    $i = 1

    $scan_results | ForEach-Object {

        $test_rename = $file_name + "_" + $i

        If($_.BaseName -Like $test_rename){
            $i++
        }

        else {
        }

    }

    return $i
}

Function UpdateList(){
    $ScanResults = ScanTargetDropbox $Path_TargetDropbox
    $FileNameListView.Items.Clear()
    AppendList $ScanResults $FileNameListView
}

# Loading initial scan results into list view
UpdateList

# Creating Click Action events
$RenameFile_Button.add_click({

    # Getting File extension
    $Original_Extension =$HyperList.SelectedItem.Extension

    # Getting the complete Original File Path from the highlighted selection
    $Original_FilePath = $HyperList.SelectedItem.FilePath
    Write-Host $Original_FilePath

    # Reformatting the facility number entered from the fill box
    $FacilityNumber_Reformatted = FacilityNumberReformat $FacilityNumber_FillBox.Text

    # Extracting the Parent Path from the originsal file path
    #$Parent_FilePath = $HyperList.SelectedItem.ParentFilePath

    #Write-Host "SITE CODE COMBO =    " $SiteCode_Radio_Combo.IsChecked.ToString()
    
    # Determining which box to take string from
    If($SiteCode_Radio_Combo.IsChecked){
        $SiteCode = $SiteCode_Combo.SelectedItem.Content.ToString()
    }
    elseif($SiteCode_Radio_Fill.IsChecked){
        $SiteCode = $SiteCode_FillBox.Text
    }

    If($DocumentType_Radio_Combo.IsChecked){
        $DocumentType = $DocumentType_Combo.SelectedItem.Content.ToString()
    }
    elseif($DocumentType_Radio_Fill.IsChecked){
        $DocumentType = $DocumentType_FillBox.Text
    }

    # Generating the New File Name and File Path
    $NewFileName = $SiteCode + "_" + $FacilityNumber_Reformatted + "_" + $DocumentType + "_" + $AdditionalModifier_FillBox.Text

    # Determining if there are any duplicates, and numbering them accordingly
    $mult_fact = MultiplicityModifier $NewFileName $ScanResults
    
    $New_Name = $NewFileName + "_" + [string]$mult_fact + $Original_Extension

    Write-Host $New_Name

    Rename-Item -Path $Original_FilePath -NewName $New_Name

    # Update list of current file names
    UpdateList

})

$TransferFile_Button.add_click({

    $path_Active = (Get-Item $PSScriptRoot).Parent.Parent.FullName + "\Digital Facility Records\Active Facilities\"
    $path_NotCreated = (Get-Item $PSScriptRoot).Parent.Parent.FullName + "\Digital Facility Records\Facilities Records Not Created\"
    $path_Retired = (Get-Item $PSScriptRoot).Parent.Parent.FullName + "\Digital Facility Records\Retired Facilities\"

    If($FileStatusType_Combo.SelectedItem.Content.ToString() -Like "Active Record"){$path_Selected = $path_Active}
    If($FileStatusType_Combo.SelectedItem.Content.ToString() -Like "Retired Record"){$path_Selected = $path_Retired}
    If($FileStatusType_Combo.SelectedItem.Content.ToString() -Like "Record Not Record"){$path_Selected = $path_NotCreated}

    # Getting highlighted selection from listview
    $TransferSelection = $HyperList.SelectedItem.FileNames

    # Getting the Current File Path from the highlighted selection from listview
    $Current_Path = $HyperList.SelectedItem.FilePath

    # Splitting off the Site Code and Facility Number to determine folder to transfer to
    $Transfer_SiteCode, $Transfer_FacilityNumber, $Junk = $TransferSelection -Split ('_',3)

    # Creating the path to transfer the selected file to
    $Transfer_Path = $path_Selected + $Transfer_SiteCode + "_" + $Transfer_FacilityNumber
    Write-Host $Transfer_Path

    if (Test-Path $Transfer_Path){
        Move-Item $Current_Path -Destination $Transfer_Path -Force
        Write-Host "PATH EXISTS:   " $Transfer_Path
    }
    else {
        New-Item -Path $Transfer_Path -ItemType Directory
        Move-Item $Current_Path -Destination $Transfer_Path -Force
        Write-Host "PATH DOES NOT EXIST:   " $Transfer_Path
    }

    # Update list of current file names
    UpdateList

})

$DropBox_Button.add_click({
    Invoke-Item $Path_TargetDropbox
})

$Refresh_Button.add_click({
    UpdateList
})

# Method for displaying windows

# Add Exit
$xamGUI07.Add_Closing({[System.Windows.Forms.Application]::Exit(); Stop-Process $pid})
 
# Allow input to window for TextBoxes, etc
[System.Windows.Forms.Integration.ElementHost]::EnableModelessKeyboardInterop($xamGUI07)
 
# Running this without $appContext and ::Run would actually cause a really poor response.
$xamGUI07.Show()
 
# This makes it pop up
$xamGUI07.Activate()
 
# Create an application context for it to all run within. This helps with responsiveness and threading.
$appContext = New-Object System.Windows.Forms.ApplicationContext 
[void][System.Windows.Forms.Application]::Run($appContext)

#$xamGUI07.ShowDialog() | out-null | out-null