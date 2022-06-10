$sch = New-Object -ComObject("Schedule.Service")
$sch.Connect("localhost")

$folders = @($sch.GetFolder("\MyTasks"))
$root = @("C:\Users\PRO\Documents\TaskScheduler")

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