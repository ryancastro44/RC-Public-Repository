try {
    #--init
    $global:ErrorActionPreference = "Stop"
    $global:RootPath = split-path -parent $MyInvocation.MyCommand.Definition
    $global:json = Get-Content "$RootPath\config.json" -Raw | ConvertFrom-Json 
    
    #---init>gui-util
        Add-Type -AssemblyName System.Windows.Forms,System.Drawing
        Add-Type -AssemblyName PresentationCore,PresentationFramework
        $global:YesNoButton = [System.Windows.MessageBoxButton]::YesNo
        $global:OKButton = [System.Windows.MessageBoxButton]::OK
        $global:InfoIcon = [System.Windows.MessageBoxImage]::Information
        $global:WarningIcon = [System.Windows.MessageBoxImage]::Warning
        $global:ErrorIcon = [System.Windows.MessageBoxImage]::Error
        $global:QButton = [System.Windows.MessageBoxImage]::Question
        $IconImage = New-Object System.Drawing.Icon("$RootPath\Tools_Icon.ico")
    
    function global:Get-Kill {
        param (
            $Mode
        )
        if ($Mode -eq "Hard") {
            $e = $_.Exception.GetType().FullName
            $line = $_.InvocationInfo.ScriptLineNumber
            $msg = $_.Exception.Message
            Write-Output "$(Get-Date -Format "HH:mm")[Error]: Initialization failed at line [$line] due [$e] `n`nwith details `n`n[$msg]`n"
            Write-Output "`n`n------------------END ROOT-------------------------"
            Stop-Transcript | Out-Null
            ClearCreateCSV
            exit
        }else{
            Write-Output "`n`n------------------END ROOT-------------------------"
            Stop-Transcript | Out-Null
            ClearCreateCSV
            exit
        }
        
    }
    
##FilePath
    $file = (get-item 'C:\Users\RyanVincentC\Desktop\RC PowerShell BootCamp\RC-Public-Repository\script\progress.gif')
    $img = [System.Drawing.Image]::Fromfile($file)
    

    function global:ClearCreateCSV {
        Remove-Item -Path "$RootPath\create.csv"
        New-Item $RootPath\create.csv -ItemType File | Out-Null
        Set-Content $RootPath\create.csv 'Name,Purpose,Members'    
    }

    Start-Transcript -Path "$RootPath\Toolbox_localtime_$(Get-Date -Format "MMddyyyyHHmm").txt" | Out-Null
    
    Write-Output "`n`n------------------BEGIN ROOT-------------------------"
    Write-Output "$(Get-Date -Format "HH:mm")[Log]: Form init success"
    
    #--form
    #---form-assembly
    $form = New-Object Windows.Forms.Form -Property @{
        Icon = $IconImage
        Size = New-Object System.Drawing.Size(485,460)
        Text = "$($json.ToolName) $($json.ToolVersion)"
        StartPosition = 'CenterScreen'
        BackColor = $json.ToolUIBackColor
        FormBorderStyle = 'Fixed3D'
        
    }
    $lblTOA = New-Object System.Windows.Forms.Label -Property @{
        Location = New-Object System.Drawing.Point(85,50)
        Size = New-Object System.Drawing.Size(290,150)
        ForeColor = $json.ToolUILabelColorDark
        BackColor = $json.ToolUIBackColorDark
        Text = "$($json.ToolTOAText)"

    }

    $CheckBox = New-Object System.Windows.Forms.Checkbox -Property @{
        Location = New-Object System.Drawing.Point(85,200)
        Size = New-Object System.Drawing.Size(400,30)
        ForeColor = $json.ToolUILabelColorDark
        Text = "Don't ask me again"
    }

    $btnStart = New-Object System.Windows.Forms.Button -Property @{
        Location = New-Object System.Drawing.Point(160,240)
        Size = New-Object System.Drawing.Size(125,50)
        ForeColor = $json.ToolUILabelColor
        BackColor = $json.ToolUIBtnColor
        Text = 'START'      
    }

    $btnStart.Add_Click({
        Write-Host "$(Get-Date -Format "HH:mm")[Log]: TOA confirm success"

        if($CheckBox.Checked -eq $True){
            $CheckBox.Hide()
        }else{}
    
        $btnStart.Hide()
        $lblTOA.Hide()
        $form.Controls.Add($shpDivider)
        $form.Controls.Add($lblMainMenu)
        $form.Controls.Add($btnCreate)
        $form.Controls.Add($btnRead)
        $form.Controls.Add($btnUpdate)
        $form.Controls.Add($btnDelete)
    })

    $shpDivider = New-Object System.Windows.Forms.Label -Property @{
        Location = New-Object System.Drawing.Point(30,50)
        Size = New-Object System.Drawing.Size(400,2)
        Text = ""
        BorderStyle = 'Fixed3D'
    }
    $lblMainMenu = New-Object System.Windows.Forms.Label -Property @{
        Location = New-Object System.Drawing.Point(30,30)
        Size = New-Object System.Drawing.Size(280,20)
        Font = New-Object System.Drawing.Font("Microsoft Sans Serif",9,[System.Drawing.FontStyle]::Bold)
        Text = "Group Management Tools"
    }
    $btnCreate = New-Object System.Windows.Forms.Button -Property @{
        Location = New-Object System.Drawing.Point(30,70)
        Size = New-Object System.Drawing.Size(125,50)
        ForeColor = $json.ToolUILabelColor
        BackColor = $json.ToolUIBtnColor
        Text = 'CREATE'      
    }

    $btnCreate.Add_Click({
        Write-Host "$(Get-Date -Format "HH:mm")[Log]: CREATE selected"
        Import-Module "$RootPath\create.ps1" -Force
        Write-Host "$(Get-Date -Format "HH:mm")[Log]: CREATE function imported"
        CreateDL
        Write-Host "`n`n$(Get-Date -Format "HH:mm")[Log]: CREATE function completed"
        [System.Windows.MessageBox]::Show("CREATE function completed","$($json.ToolName) $($json.ToolVersion)",$OKButton,$InfoIcon)
    })


    $btnRead = New-Object System.Windows.Forms.Button -Property @{
        Location = New-Object System.Drawing.Point(175,70)
        Size = New-Object System.Drawing.Size(125,50)
        ForeColor = $json.ToolUILabelColor
        BackColor = $json.ToolUIBtnColor
        Text = 'READ'      

    }

    $btnRead.Add_Click({
        Write-Host "$(Get-Date -Format "HH:mm")[Log]: READ selected"
        Import-Module "$RootPath\read.ps1" -Force
        Write-Host "$(Get-Date -Format "HH:mm")[Log]: READ function imported"
        Write-Host "`n`n$(Get-Date -Format "HH:mm")[Log]: READ function completed"
        [System.Windows.MessageBox]::Show("DETAILS:$mem","$($json.ToolName) $($json.ToolVersion)",$OKButton,$InfoIcon)
        
    })

    
    $btnUpdate = New-Object System.Windows.Forms.Button -Property @{
        Location = New-Object System.Drawing.Point(30,140)
        Size = New-Object System.Drawing.Size(125,50)
        ForeColor = $json.ToolUILabelColor
        BackColor = $json.ToolUIBtnColor
        Text = 'UPDATE'      
    }
    $btnDelete = New-Object System.Windows.Forms.Button -Property @{
        Location = New-Object System.Drawing.Point(175,140)
        Size = New-Object System.Drawing.Size(125,50)
        ForeColor = $json.ToolUILabelColor
        BackColor = $json.ToolUIBtnColor
        Text = 'DELETE'     
        
    }

   
    $GifBackGround = new-object Windows.Forms.PictureBox
    $GifBackGround.Location = New-Object System.Drawing.point(250,290)
    $GifBackGround.Size = New-Object System.Drawing.Size(400,500)
    $GifBackGround.AutoSize = $true
    $GifBackGround.Image = $img
    $form.controls.add($GifBackGround)

    
    #---form-render
    $form.Controls.Add($lblTOA)
    $form.Controls.Add($btnStart)
    $form.Controls.Add($CheckBox) 
    
    $form.ShowDialog() | Out-Null
    
    Get-Kill 
}
catch {
    Get-Kill -Mode "Hard"
}