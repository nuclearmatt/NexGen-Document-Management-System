# Module Paths
$pathDashboardLoader = (Get-Item $PSScriptRoot).FullName + "\PSM\DashboardLoader.psm1"

# Dropbox and Image Paths
$pathIMG = (Get-Item $PSScriptRoot).FullName + "\IMG\"

# XAML Path
$pathXAML_DashboardInterface = (Get-Item $PSScriptRoot).FullName + "\XAML\DashboardInterface.xaml"

# BAT Paths
$pathRecordSearchScript = (Get-Item $PSScriptRoot).FullName + "\BAT\RecordsSearch.bat"
$pathQuickSearchScript = (Get-Item $PSScriptRoot).FullName + "\BAT\QuickSearch.bat"
$pathDatabaseScannerScript = (Get-Item $PSScriptRoot).FullName + "\BAT\DatabaseScanner.bat"
$pathAutoTransferScript = (Get-Item $PSScriptRoot).FullName + "\BAT\AutoTransfer.bat"
$pathTransferScript = (Get-Item $PSScriptRoot).FullName + "\BAT\Transfer.bat"
$pathHelpContentScript = (Get-Item $PSScriptRoot).FullName + "\BAT\HelpContent.bat"

# Importing Modules
Import-Module $pathDashboardLoader

# Loading the XAML interfaces
DashboardLoader($pathXAML_DashboardInterface)

# Creating clickable buttons for the Dashboard
$AboutSoft_Menu_Button = $xamGUI01.FindName('AboutSoft')
$HelpContent_Menu_Button = $xamGUI01.FindName('HelpContent')
$ExitProgram_Menu_Button = $xamGUI01.FindName('ExitProgram')
$Search_Menu_Button = $xamGUI01.FindName('Search_Menu')
$QuickSearch_Menu_Button = $xamGUI01.FindName('QuickSearch_Menu')
$TransferNewRecords_Menu_Button = $xamGUI01.FindName('TransferNewRecords_Menu')
$BulkTransfer_Menu_Button = $xamGUI01.FindName('BulkTransfer_Menu')
$ScanDatabase_Menu_Button = $xamGUI01.FindName('ScanDatabase_Menu')

# Creating Click Action events
$ExitProgram_Menu_Button.add_click({
    Exit
})

$AboutSoft_Menu_Button.add_click({
    [System.Windows.Forms.MessageBox]::Show(" Version: 2.0.0`n Release Date: 03/02/2019`n `n Developed By: Matthew D. McIntyre `n E-Mail: MCINTYREMD.17@gmail.com `n Cell: 000-000-0000", 'MCINTYRE NexGen')
})

$HelpContent_Menu_Button.add_click({
    Start-Process $pathHelpContentScript
})

$Search_Menu_Button.add_click({
    Start-Process $pathRecordSearchScript
})

$QuickSearch_Menu_Button.add_click({
    Start-Process $pathQuickSearchScript
})

$TransferNewRecords_Menu_Button.add_click({
    Start-Process $pathTransferScript
})

$BulkTransfer_Menu_Button.add_click({

})

$ScanDatabase_Menu_Button.add_click({
    Start-Process $pathDatabaseScannerScript
})

# Loading images from relative path
$DatabasePlainPNG = $xamGUI01.FindName('DatabasePlainPNG')
$DatabasePlainPNG.Source = $pathIMG + "databasePlain.png"

# Method for displaying windows

# Add Exit
$xamGUI01.Add_Closing({[System.Windows.Forms.Application]::Exit(); Stop-Process $pid})
 
# Allow input to window for TextBoxes, etc
[System.Windows.Forms.Integration.ElementHost]::EnableModelessKeyboardInterop($xamGUI01)
 
# Running this without $appContext and ::Run would actually cause a really poor response.
$xamGUI01.Show()
 
# This makes it pop up
$xamGUI01.Activate()
 
# Create an application context for it to all run within. 
# This helps with responsiveness and threading.
$appContext = New-Object System.Windows.Forms.ApplicationContext 
[void][System.Windows.Forms.Application]::Run($appContext)