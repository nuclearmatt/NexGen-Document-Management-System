Function RecordsSearchLoader($XamlPath){
 
$Global:xmlWPF02 = [XML](Get-Content -Path $XamlPath)
 
#Add WPF and Windows Forms assemblies
try{
     Add-Type -AssemblyName PresentationCore, PresentationFramework, WindowsBase, System.Windows.Forms, System.Drawing, WindowsFormsIntegration
} catch {
 Throw "Failed to load Windows Presentation Framework assemblies."
}
 
#Create the XAML reader using a new XML node reader
$Global:xamGUI02 = [Windows.Markup.XamlReader]::Load((new-object System.Xml.XmlNodeReader $xmlWPF02))
 
#Create hooks to each named object in the XAML
$xmlWPF02.SelectNodes("//*[@Name]") | ForEach-Object {Set-Variable -Name ($_.Name) -Value $xamGUI02.FindName($_.Name) -Scope Global}

}

Export-ModuleMember -Function RecordsSearchLoader