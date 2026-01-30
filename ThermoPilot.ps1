# ThermoPilot Universal Edition v1.0
# Pure Universal EPP Governor for Windows
# No plan creation • No plan switching • OEM-agnostic

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Set-Location -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)

#----------------------------------
# CONFIG
#----------------------------------

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$lhmPath   = Join-Path $scriptDir 'LibreHardwareMonitorLib.dll'

if (-not (Test-Path $lhmPath)) {
    [System.Windows.Forms.MessageBox]::Show(
        "LibreHardwareMonitorLib.dll not found in:`n$scriptDir",
        "ThermoPilot",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    ) | Out-Null
    return
}

$Stages = [ordered]@{
    Cool = @{ Min=0;  Max=55; Epp=10; Label="Cool" }
    Warm = @{ Min=56; Max=70; Epp=35; Label="Warm" }
    Hot  = @{ Min=71; Max=75; Epp=55; Label="Hot"  }
}

$CpuWarnTemp    = 90
$CpuMaxTemp     = 95
$PollIntervalMs = 2000

#----------------------------------
# POWER PLAN HELPERS
#----------------------------------

$SubProcessorGuid   = '54533251-82be-4824-96c1-47b60b740d00'
$PerfEnergyPrefGuid = '36687f9e-e3a5-4dbf-b1dc-15eb381c6863'

function Get-ActiveSchemeGuid {
    $out = powercfg /GETACTIVESCHEME 2>$null
    if ($out -match 'GUID:\s+([0-9a-fA-F-]+)') {
        return $matches[1]
    }
    return $null
}

function Get-SchemeName {
    param([string]$Guid)
    $out = powercfg /L 2>$null
    foreach ($line in $out) {
        if ($line -match "($Guid)\s+\((.+?)\)") {
            return $matches[2]
        }
    }
    return $Guid
}

#----------------------------------
# LIBRE HARDWARE MONITOR
#----------------------------------

[System.Reflection.Assembly]::LoadFile($lhmPath) | Out-Null

$computer = New-Object LibreHardwareMonitor.Hardware.Computer
$computer.IsCpuEnabled         = $true
$computer.IsGpuEnabled         = $true
$computer.IsMotherboardEnabled = $false
$computer.IsMemoryEnabled      = $false
$computer.IsControllerEnabled  = $false
$computer.IsNetworkEnabled     = $false
$computer.IsBatteryEnabled     = $false
$computer.IsPsuEnabled         = $false
$computer.Open()

function Find-CpuTempSensor {
    foreach ($hw in $computer.Hardware) {
        if ($hw.HardwareType -eq 'Cpu') {
            $hw.Update()
            foreach ($s in $hw.Sensors) {
                if ($s.SensorType -eq 'Temperature' -and
                    ($s.Name -match 'Package|Core|CPU|Tctl|Tdie')) {
                    return $s
                }
            }
        }
    }
    return $null
}

function Find-GpuTempSensor {
    foreach ($hw in $computer.Hardware) {
        if ($hw.HardwareType -eq 'GpuAmd' -or $hw.HardwareType -eq 'GpuNvidia') {
            $hw.Update()
            foreach ($s in $hw.Sensors) {
                if ($s.SensorType -eq 'Temperature' -and
                    ($s.Name -match 'Core|GPU|Hot Spot|Temperature')) {
                    return $s
                }
            }
        }
    }
    return $null
}

$cpuSensor = Find-CpuTempSensor
$gpuSensor = Find-GpuTempSensor

if (-not $gpuSensor) {
    [System.Windows.Forms.MessageBox]::Show(
        "No GPU temperature sensor found.",
        "ThermoPilot",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    ) | Out-Null
    $computer.Close()
    return
}

#----------------------------------
# GUI
#----------------------------------

$form = New-Object System.Windows.Forms.Form
$form.Text = "ThermoPilot – Universal Edition"
$form.Size = New-Object System.Drawing.Size(500,500)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::FromArgb(245,245,245)
$form.Font = New-Object System.Drawing.Font("Segoe UI", 10)

$header = New-Object System.Windows.Forms.Label
$header.Text = "ThermoPilot – Universal"
$header.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$headerWidth = 480
$header.Location = New-Object System.Drawing.Point(
    [math]::Floor(($form.ClientSize.Width - $headerWidth) / 2), 20)
$header.Size = New-Object System.Drawing.Size($headerWidth, 35)
$header.TextAlign = "MiddleCenter"
$form.Controls.Add($header)

$logoPath = Join-Path $scriptDir "thermopilot_logo.png"
if (Test-Path $logoPath) {
    $logo = New-Object System.Windows.Forms.PictureBox
    $logo.Image = [System.Drawing.Image]::FromFile($logoPath)
    $logo.SizeMode = "Zoom"
    $logoWidth  = 120
    $logoHeight = 120
    $logoX = [math]::Floor(($form.ClientSize.Width - $logoWidth) / 2)
    $logoY = 70
    $logo.Location = New-Object System.Drawing.Point($logoX, $logoY)
    $logo.Size     = New-Object System.Drawing.Size($logoWidth, $logoHeight)
    $form.Controls.Add($logo)
}

$panel = New-Object System.Windows.Forms.Panel
$panel.Location = New-Object System.Drawing.Point(20,210)
$panel.Size = New-Object System.Drawing.Size(460,240)
$panel.BorderStyle = 'FixedSingle'
$panel.BackColor = [System.Drawing.Color]::White
$form.Controls.Add($panel)

$labelGpu = New-Object System.Windows.Forms.Label
$labelGpu.Location = New-Object System.Drawing.Point(10,10)
$labelGpu.Size = New-Object System.Drawing.Size(430,25)
$labelGpu.Text = "GPU Temp: ? °C"
$panel.Controls.Add($labelGpu)

$labelCpu = New-Object System.Windows.Forms.Label
$labelCpu.Location = New-Object System.Drawing.Point(10,40)
$labelCpu.Size = New-Object System.Drawing.Size(430,25)
$labelCpu.Text = "CPU Temp: ? °C"
$panel.Controls.Add($labelCpu)

$labelPlan = New-Object System.Windows.Forms.Label
$labelPlan.Location = New-Object System.Drawing.Point(10,70)
$labelPlan.Size = New-Object System.Drawing.Size(430,25)
$labelPlan.Text = "Active Plan: ?"
$panel.Controls.Add($labelPlan)

$labelStage = New-Object System.Windows.Forms.Label
$labelStage.Location = New-Object System.Drawing.Point(10,100)
$labelStage.Size = New-Object System.Drawing.Size(430,25)
$labelStage.Text = "Stage: ?"
$panel.Controls.Add($labelStage)

$labelEpp = New-Object System.Windows.Forms.Label
$labelEpp.Location = New-Object System.Drawing.Point(10,130)
$labelEpp.Size = New-Object System.Drawing.Size(430,25)
$labelEpp.Text = "Last EPP Write: ?"
$panel.Controls.Add($labelEpp)

$labelLock = New-Object System.Windows.Forms.Label
$labelLock.Location = New-Object System.Drawing.Point(10,170)

$labelLock.AutoSize = $false
$labelLock.MaximumSize = New-Object System.Drawing.Size(430,0)
$labelLock.Size = New-Object System.Drawing.Size(430,60)

$labelLock.TextAlign = 'TopLeft'
$labelLock.AutoEllipsis = $false

$labelLock.Text = "EPP Status: Normal"
$panel.Controls.Add($labelLock)

$footer = New-Object System.Windows.Forms.Label
$footer.Text = "ThermoPilot v1.0 – Universal"
$footer.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$footer.ForeColor = [System.Drawing.Color]::Gray
$footer.Location = New-Object System.Drawing.Point(20,430)
$footer.Size = New-Object System.Drawing.Size(300,20)
$form.Controls.Add($footer)

$buttonClose = New-Object System.Windows.Forms.Button
$buttonClose.Location = New-Object System.Drawing.Point(360,425)
$buttonClose.Size = New-Object System.Drawing.Size(100,30)
$buttonClose.Text = "Close"
$buttonClose.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$form.Controls.Add($buttonClose)

#----------------------------------
# EPP WRITEBACK
#----------------------------------

$lastEppValue = $null
$lastEppTime  = $null
$wroteThisTick = $false

function Set-PlanEpp {
    param([string]$PlanGuid, [int]$EppValue)

    if ($EppValue -lt 0)   { $EppValue = 0 }
    if ($EppValue -gt 100) { $EppValue = 100 }

    powercfg /SETACVALUEINDEX $PlanGuid $SubProcessorGuid $PerfEnergyPrefGuid $EppValue | Out-Null

    $script:lastEppValue = $EppValue
    $script:lastEppTime  = (Get-Date).ToString("HH:mm:ss")
    $script:wroteThisTick = $true
}

#----------------------------------
# MAIN LOGIC
#----------------------------------

$currentStageName = $null

function Get-StageForTemp {
    param([double]$Temp)
    foreach ($name in $Stages.Keys) {
        $stage = $Stages[$name]
        if ($Temp -ge $stage.Min -and $Temp -le $stage.Max) {
            return $name
        }
    }
    return $null
}

$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = $PollIntervalMs

$timer.Add_Tick({
    $script:wroteThisTick = $false
    $cpuOverrideActive = $false
    $stageName = $null

    try {
        if ($cpuSensor) { $cpuSensor.Hardware.Update() }
        $gpuSensor.Hardware.Update()

        $gpuTemp = [math]::Round($gpuSensor.Value,1)
        $labelGpu.Text = "GPU Temp: $gpuTemp °C"

        if ($cpuSensor) {
            $cpuTemp = [math]::Round($cpuSensor.Value,1)
            $labelCpu.Text = "CPU Temp: $cpuTemp °C"
        } else {
            $cpuTemp = $null
            $labelCpu.Text = "CPU Temp: N/A"
        }

        $activeGuid = Get-ActiveSchemeGuid
        $labelPlan.Text = "Active Plan: $(Get-SchemeName $activeGuid)"

        if ($cpuTemp -ne $null) {
            if ($cpuTemp -ge $CpuMaxTemp) {
                Set-PlanEpp -PlanGuid $activeGuid -EppValue 90
                $labelStage.Text = "Stage: CPU MAX (EPP 90)"
                $cpuOverrideActive = $true
            }
            elseif ($cpuTemp -ge $CpuWarnTemp) {
                Set-PlanEpp -PlanGuid $activeGuid -EppValue 60
                $labelStage.Text = "Stage: CPU HOT (EPP 60)"
                $cpuOverrideActive = $true
            }
        }

        if (-not $cpuOverrideActive) {
            $stageName = Get-StageForTemp -Temp $gpuTemp
            if ($stageName -and $stageName -ne $currentStageName) {
                $stage = $Stages[$stageName]
                Set-PlanEpp -PlanGuid $activeGuid -EppValue $stage.Epp
                $labelStage.Text = "Stage: $($stage.Label) (EPP $($stage.Epp))"
                $currentStageName = $stageName
            }
        }

        if ($lastEppValue -ne $null) {
            $labelEpp.Text = "Last EPP Write: $lastEppValue at $lastEppTime"
        }

        if ($wroteThisTick -and -not $cpuOverrideActive -and $stageName -eq $currentStageName) {
            $labelLock.Text = "EPP Status: System Overriding Value"
        } else {
            $labelLock.Text = "Epp Status: Normal"
        }
    }
    catch {
        $labelStage.Text = "Stage: Error - $($_.Exception.Message)"
    }
})

$buttonClose.Add_Click({
    $timer.Stop()
    $computer.Close()
    $form.Close()
})

$form.Add_FormClosing({
    $timer.Stop()
    $computer.Close()
})

$timer.Start()
[void]$form.ShowDialog()
