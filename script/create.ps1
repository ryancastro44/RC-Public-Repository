#--init
$global:RootPath = split-path -parent $MyInvocation.MyCommand.Definition
$CreateCSV = Import-Csv -Path "$RootPath\create.csv"
Start-Transcript -Path "$RootPath\Create_localtime_$(Get-Date -Format "MMddyyyyHHmm").txt" | Out-Null

$json = Get-Content "$RootPath\config.json" -Raw | ConvertFrom-Json 

Write-Output "`n`n------------------BEGIN-------------------------"
Write-Output "$(Get-Date -Format "HH:mm")[Log]: Starting init"

#--transform
Write-Output "$(Get-Date -Format "HH:mm")[Log]: Transforming data"
$PurposeItem = $CreateCSV | Select-Object -ExpandProperty Purpose
$ArrayMembersItem = ($CreateCSV | select -ExpandProperty Members) -split (',')

$item = $CreateCSV | select -ExpandProperty Name
$TrimedItem = ($item.TrimEnd()).TrimStart() #removed whitespaces
$NoCharsItem = $TrimedItem  -replace '[\W]', '' #removed special char
$LowerCasedItem = $NoCharsItem.ToLower() #convert to lowercasing
$AppendedItem = $json.AliasPrefix + $LowerCasedItem #append prefix

#--assembly
Write-Output "$(Get-Date -Format "HH:mm")[Log]: Assembling output"
$AssembledObj = [PSCustomObject]@{
    Name = $NoCharsItem
    DisplayName  = $json.DisplayNamePrefix + $NoCharsItem
    PrimarySmtpAddress  = $AppendedItem + "@" +$json.DomainName
    Description = "`n Created at: $env:COMPUTERNAME" + `
    "`n Created by: $env:UserName" + `
    "`n Created on: ($(Get-Date))" + `
    "`n`n=========`n" + $PurposeItem

}

#--output
Write-Output "`n------------------OUTPUT-------------------------"
Write-Host "`n`n Name:" -foregroundcolor Cyan
$AssembledObj.Name
Write-Host "`n`n DisplayName:" -foregroundcolor Cyan
$AssembledObj.DisplayName
Write-Host "`n`n PrimarySmtpAddress:" -foregroundcolor Cyan
$AssembledObj.PrimarySmtpAddress
Write-Host "`n`n Description:" -foregroundcolor Cyan
$AssembledObj.Description

Write-Host "`n`n Members:" -foregroundcolor Cyan
$ArrayMembersItem

