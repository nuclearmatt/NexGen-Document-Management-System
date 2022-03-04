# Module Path
$pathHelpContentLoader = (Get-Item $PSScriptRoot).Parent.FullName + "\PSM\HelpContentLoader.psm1"

# XAML Path
$pathXAML_HelpContent = (Get-Item $PSScriptRoot).Parent.FullName + "\XAML\HelpContent.xaml"

Import-Module $pathHelpContentLoader

HelpContentLoader($pathXAML_HelpContent)

$xamGUI03.ShowDialog() | out-null | out-null