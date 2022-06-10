if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) { Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs; exit }

$sch = New-Object -ComObject("Schedule.Service")
$sch.Connect("localhost")

$folders = @($sch.GetFolder("\MyTasks"))

$i = 0
while ($i -lt $folders.Length) {
    $folders[$i].GetFolders(0) | %{
        $folders += $_
    }
    $folders[$i].GetTasks(0) | %{
        $folders[$i].DeleteTask($_.Name,$null)
    }
    $i += 1
}
for ($i=$folders.length-1; $i -ge 0; $i--){
    $folders[$i].GetFolders(0) | % {
        $folders[$i].DeleteFolder($(Split-Path $_.Path -Leaf),$null)
    }
}

$base_dir = "C:\Users\PRO\Documents\TaskScheduler\MyTasks\"
$rel_paths = Get-ChildItem $base_dir -Recurse -Filter *.xml -Name 

foreach ($rel_path in $rel_paths){
    $task_name = "MyTasks\$($rel_path.Replace('.xml',''))"
    schtasks /create /XML $base_dir$rel_path /TN $task_name /S localhost /RU "tetu3188@yahoo.co.jp" /RP "saka5656"
}