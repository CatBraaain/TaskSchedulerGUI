if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) { Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs; exit }

Remove-Item "C:\Users\PRO\Documents\TaskScheduler\MyTasks" -Recurse

$sch = New-Object -ComObject("Schedule.Service")
$sch.Connect("localhost")

$folders = @($sch.GetFolder("\MyTasks"))
$root = "C:\Users\PRO\Documents\TaskScheduler"

$i = 0
while ($i -lt $folders.Length) {
    [System.IO.Directory]::CreateDirectory("$root$($folders[$i].Path)")

    $folders[$i].GetFolders(0) | %{
        $folders += $_
    }
    $folders[$i].GetTasks(0) | %{
        $Xml = $_.Xml
        $out_path = "$root$($folders[$i].Path)\$($_.Name).xml"
        $Xml | Out-File $out_path
    }
    $i += 1
}