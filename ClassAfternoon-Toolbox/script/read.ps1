$ProxyOptions = New-PSSessionOption -ProxyAccessType IEConfig
Connect-ExchangeOnline -UserPrincipalName $ServiceAdmin -PSSessionOption $ProxyOptions

$csv = Import-csv "C:\Users\RyanVincentC\Desktop\RC PowerShell BootCamp\ClassAfternoon-Toolbox\script\create.csv"

Foreach($Mem in $csv){Get-DistributionGroup -Identity "$Mem.Name" | Format-List}
