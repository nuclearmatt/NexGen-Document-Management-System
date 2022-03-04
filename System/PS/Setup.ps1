# Declaring file path to send BAT files to
$BAT_Path = (Get-Item $PSScriptRoot).Parent.FullName + "\BAT\"

# Creating BAT file strings/content
$AutoTransfer_Bat = @"
@ECHO OFF
Start PowerShell.exe -ExecutionPolicy Bypass -Command "& '%CD%\..\PS\AutoTransfer.ps1'" 
EXIT 
"@

$DatabaseScanner_Bat = @"
@ECHO OFF
Start PowerShell.exe -ExecutionPolicy Bypass -Command "& '%CD%\..\PS\DatabaseScanner.ps1'" 
EXIT 
"@

$HelpContent_Bat = @"
@ECHO OFF
Start PowerShell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -Command "& '%CD%\..\PS\HelpContent.ps1'" 
EXIT 
"@

$McIntyreNexGen_Bat = @" 
@ECHO OFF
Start PowerShell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -Command "& '%CD%\..\McIntyreNexGen.ps1'" 
EXIT
"@

$QuickSearch_Bat = @"
@ECHO OFF
Start PowerShell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -Command "& '%CD%\..\PS\QuickSearch.ps1'" 
EXIT
"@

$RecordsSearch_Bat = @"
@ECHO OFF
Start PowerShell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -Command "& '%CD%\..\PS\RecordsSearch.ps1'" 
EXIT
"@

$Transfer_Bat = @"
@ECHO OFF
Start PowerShell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -Command "& '%CD%\..\PS\Transfer.ps1'" 
EXIT 
"@

# Creating BAT file path names
$AutoTransfer_Bat_Path = $BAT_Path + "AutoTransfer.bat"
$DatabaseScanner_Bat_Path = $BAT_Path + "DatabaseScanner.bat"
$HelpContent_Bat_Path = $BAT_Path + "HelpContent.bat"
$McIntyreNexGen_Bat_Path = $BAT_Path + "McIntyreNexGen.bat"
$QuickSearch_Bat_Path = $BAT_Path + "QuickSearch.bat"
$RecordsSearch_Bat_Path = $BAT_Path + "RecordsSearch.bat"
$Transfer_Bat_Path = $BAT_Path + "Transfer.bat"

# Creating an Array containing the BAT Paths and BAT Script strings
$BAT_Paths = @(
    [pscustomobject]@{Path=$AutoTransfer_Bat_Path;Script=$AutoTransfer_Bat}
    [pscustomobject]@{Path=$DatabaseScanner_Bat_Path;Script=$DatabaseScanner_Bat}
    [pscustomobject]@{Path=$HelpContent_Bat_Path;Script=$HelpContent_Bat}
    [pscustomobject]@{Path=$McIntyreNexGen_Bat_Path;Script=$McIntyreNexGen_Bat}
    [pscustomobject]@{Path=$QuickSearch_Bat_Path;Script=$QuickSearch_Bat}
    [pscustomobject]@{Path=$RecordsSearch_Bat_Path;Script=$RecordsSearch_Bat}
    [pscustomobject]@{Path=$Transfer_Bat_Path;Script=$Transfer_Bat}
)

# Generating the BAT Scripts
$BAT_Paths | ForEach-Object {
    Out-File -FilePath $_.Path -InputObject $_.Script -Encoding ascii
}

# Creating Desktop link to main BAT file
$ShortcutPath = Join-Path ([Environment]::GetFolderPath("Desktop")) "McIntyre RPDMS.lnk"
$Shell = New-Object -ComObject WScript.Shell
$DesktopShortcut = $Shell.CreateShortcut($ShortcutPath)
$DesktopShortcut.TargetPath = $McIntyreNexGen_Bat_Path
$DesktopShortcut.WorkingDirectory = $BAT_Path

# Setting up custom icon (Has to be in .ICO format)
$DesktopShortcut.IconLocation = (Get-Item $PSScriptRoot).Parent.FullName + "\IMG\bohrAtom.ico"

$DesktopShortcut.Save()