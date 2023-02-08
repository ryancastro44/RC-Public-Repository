$csv = Import-csv "C:\Users\RyanVincentC\Desktop\RC PowerShell BootCamp\RC-Public-Repository\script\create.csv"

Foreach($Mem in $csv){
    
    $Member = Write-Host "Members: $Mem.Members"}
