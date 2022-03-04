Function ProgressBarResize($HostWindow){

    [int]$Height = 10
    [int]$Width = 120
    $WindowSize = $Host.UI.RawUI.WindowSize
    $WindowSize.Width  = [Math]::Min($Width, $Host.UI.RawUI.BufferSize.Width)
    $WindowSize.Height = $Height

    Try{
        $Host.UI.RawUI.WindowSize = $WindowSize
    }
    Catch [System.Management.Automation.SetValueInvocationException] {
        $Maxvalue = ($_.Exception.Message |Select-String "\d+").Matches[0].Value
        $WindowSize.Height = $Maxvalue
        $Host.UI.RawUI.WindowSize = $WindowSize
    }

}