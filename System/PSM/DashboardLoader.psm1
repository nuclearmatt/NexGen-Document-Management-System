Function DashboardLoader($XamlPath){

$Global:xmlWPF01 = [XML](Get-Content -Path $XamlPath)
 
#Add WPF and Windows Forms assemblies
try{
     Add-Type -AssemblyName PresentationCore, PresentationFramework, WindowsBase, System.Windows.Forms, System.Drawing, WindowsFormsIntegration
} catch {
 Throw "Failed to load Windows Presentation Framework assemblies."
}
 
#Create the XAML reader using a new XML node reader
$Global:xamGUI01 = [Windows.Markup.XamlReader]::Load((new-object System.Xml.XmlNodeReader $xmlWPF01))
 
#Create hooks to each named object in the XAML
$xmlWPF01.SelectNodes("//*[@Name]") | ForEach-Object {Set-Variable -Name ($_.Name) -Value $xamGUI01.FindName($_.Name) -Scope Global}

}

Export-ModuleMember -Function DashboardLoader