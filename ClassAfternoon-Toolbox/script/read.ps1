$csv = Import-csv "C:\Users\RyanVincentC\Desktop\RC PowerShell BootCamp\ClassAfternoon-Toolbox\script\create.csv"

Foreach($Mem in $csv){Write-Host "Members: $Mem.Members"}
