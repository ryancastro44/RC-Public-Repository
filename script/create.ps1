#--init
$global:RootPath = split-path -parent $MyInvocation.MyCommand.Definition
$json = Get-Content "$RootPath\config.json" -Raw | ConvertFrom-Json 
$CreateCSV = Import-Csv -Path "$RootPath\create.csv"
$counter = 0
Start-Transcript -Path "$RootPath\Create_localtime_$(Get-Date -Format "MMddyyyyHHmm").txt" | Out-Null
Write-Output "`n`n------------------BEGIN-------------------------"
Write-Output "$(Get-Date -Format "HH:mm")[Log]: Starting init"

foreach($c in $CreateCSV){
    #--transform
    Write-Output "$(Get-Date -Format "HH:mm")[Log]: Transforming data"
    $NoCharsItem = $(($($c.Name).TrimEnd()).TrimStart())  -replace '[\W]', '' #remove whitespace and special chars

    #--assembly
    Write-Output "$(Get-Date -Format "HH:mm")[Log]: Assembling output"
    $AssembledObj = [PSCustomObject]@{
        Name = $NoCharsItem
        DisplayName  = $json.DisplayNamePrefix + $NoCharsItem
        PrimarySmtpAddress  = $($json.AliasPrefix + $($NoCharsItem.ToLower())) + "@" + $json.DomainName #join and convert to lowercases
        Description = "`n Created at: " + $env:COMPUTERNAME + "`n Created by: " + $env:USERNAME + "`n Created on: "  + ($(Get-Date)) + "`n`n=========`n" + $c.Purpose
        Members = ($c.Members) -split (',') #turm members to array
    }

    #--output
    $counter++
    Write-Output "`n------------------OUTPUT($counter)-------------------------"
    foreach ($currentItemName in $(@("Name","DisplayName","PrimarySmtpAddress","Description","Members")) ) {
        Write-Host "`n`n $($currentItemName):" -foregroundcolor Cyan
        $AssembledObj.$($currentItemName)
    }
}

Write-Output "`n`n------------------END-------------------------"
Stop-Transcript | Out-Null


