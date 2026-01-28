# ThermoPilot - Acer-Locked Edition (Final Build)
# GPU-only thermal governor with 3-stage EPP, Acer fallback, and Live EPP Write-Back
# Save as: ThermoPilot-Acer.ps1
# Run from: PowerShell ISE script pane (top) with F5

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Set-Location -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)
#-----------------------------
# CONFIGURATION
#-----------------------------

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$lhmPath   = Join-Path $scriptDir 'LibreHardwareMonitorLib.dll'

if (-not (Test-Path $lhmPath)) {
    [System.Windows.Forms.MessageBox]::Show(
        "LibreHardwareMonitorLib.dll not found in:`n$scriptDir",
        "ThermoPilot Acer",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    ) | Out-Null
    return
}

# Temperature stages (GPU °C)
$Stages = [ordered]@{
    Cool = @{
        Min = 0
        Max = 55
        Epp = 10
        Label = "Cool"
    }
    Warm = @{
        Min = 56
        Max = 70
        Epp = 35
        Label = "Warm"
    }
    Hot = @{
        Min = 71
        Max = 75
        Epp = 55
        Label = "Hot"
    }
}

# Above this → switch to Acer OEM plan
$CriticalGpuTemp = 75

# Polling interval (ms)
$PollIntervalMs = 2000

#-----------------------------
# POWER PLAN HELPERS
#-----------------------------

$SubProcessorGuid      = '54533251-82be-4824-96c1-47b60b740d00'
$PerfEnergyPrefGuid    = '36687f9e-e3a5-4dbf-b1dc-15eb381c6863'

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

function Ensure-AcerAndThermoPilotPlans {
    $acerGuid = $null
    $list = powercfg /L 2>$null
    foreach ($line in $list) {
        if ($line -match 'Power Scheme GUID:\s+([0-9a-fA-F-]+)\s+\((.+?)\)') {
            $g = $matches[1]
            $n = $matches[2]
            if ($n -match 'Acer') {
                $acerGuid = $g
                break
            }
        }
    }

    if (-not $acerGuid) {
        [System.Windows.Forms.MessageBox]::Show(
            "Could not find an Acer power plan.",
            "ThermoPilot Acer",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        ) | Out-Null
        return $null
    }

    $tpGuid = $null
    foreach ($line in $list) {
        if ($line -match 'Power Scheme GUID:\s+([0-9a-fA-F-]+)\s+\((.+?)\)') {
            $g = $matches[1]
            $n = $matches[2]
            if ($n -match 'ThermoPilot Performance') {
                $tpGuid = $g
                break
            }
        }
    }

    if (-not $tpGuid) {
        $dup = powercfg -DUPLICATESCHEME $acerGuid 2>$null
        if ($dup -match 'Power Scheme GUID:\s+([0-9a-fA-F-]+)') {
            $tpGuid = $matches[1]
            powercfg -CHANGENAME $tpGuid "ThermoPilot Performance" "ThermoPilot Acer-Optimized Performance Plan" | Out-Null
        }
    }

    if (-not $tpGuid) {
        [System.Windows.Forms.MessageBox]::Show(
            "Failed to create ThermoPilot Performance plan.",
            "ThermoPilot Acer",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        ) | Out-Null
        return $null
    }

    return [pscustomobject]@{
        AcerGuid = $acerGuid
        ThermoGuid = $tpGuid
    }
}

#-----------------------------
# LIBRE HARDWARE MONITOR
#-----------------------------

[System.Reflection.Assembly]::LoadFile($lhmPath) | Out-Null

$computer = New-Object LibreHardwareMonitor.Hardware.Computer
$computer.IsCpuEnabled = $false
$computer.IsGpuEnabled = $true
$computer.IsMotherboardEnabled = $false
$computer.IsMemoryEnabled = $false
$computer.IsControllerEnabled = $false
$computer.IsNetworkEnabled = $false
$computer.IsBatteryEnabled = $false
$computer.IsPsuEnabled = $false
$computer.Open()

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

$gpuSensor = Find-GpuTempSensor
if (-not $gpuSensor) {
    [System.Windows.Forms.MessageBox]::Show(
        "No GPU temperature sensor found.",
        "ThermoPilot Acer",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    ) | Out-Null
    $computer.Close()
    return
}

#-----------------------------
# POWER PLAN SETUP
#-----------------------------

$plans = Ensure-AcerAndThermoPilotPlans
if (-not $plans) {
    $computer.Close()
    return
}

$acerGuid = $plans.AcerGuid
$tpGuid   = $plans.ThermoGuid

#-----------------------------
# GUI (Corrected Layout + Logo Visible)
#-----------------------------

$form = New-Object System.Windows.Forms.Form
$form.Text = "ThermoPilot – Acer Edition"
$form.Size = New-Object System.Drawing.Size(500,500)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::FromArgb(245,245,245)
$form.Font = New-Object System.Drawing.Font("Segoe UI", 10)

# Header
$header = New-Object System.Windows.Forms.Label
$header.Text = "ThermoPilot – Acer Edition"
$header.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$header.Location = New-Object System.Drawing.Point(20,20)
$header.Size = New-Object System.Drawing.Size(460,35)
$header.TextAlign = "MiddleCenter"
$form.Controls.Add($header)

# Logo (centered, clean, professional)
$logoPath = Join-Path $scriptDir "thermopilot_logo.png"

if (Test-Path $logoPath) {
    $logo = New-Object System.Windows.Forms.PictureBox
    $logo.Image = [System.Drawing.Image]::FromFile($logoPath)
    $logo.SizeMode = "Zoom"

    # Center horizontally: (FormWidth - LogoWidth) / 2
    $logoWidth  = 120
    $logoHeight = 120
    $logoX = [math]::Floor(($form.ClientSize.Width - $logoWidth) / 2)
    $logoY = 70   # Below header, above panel

    $logo.Location = New-Object System.Drawing.Point($logoX, $logoY)
    $logo.Size     = New-Object System.Drawing.Size($logoWidth, $logoHeight)

    $form.Controls.Add($logo)
}

# Panel container
$panel = New-Object System.Windows.Forms.Panel
$panel.Location = New-Object System.Drawing.Point(20,210)
$panel.Size = New-Object System.Drawing.Size(460,170)
$panel.BorderStyle = 'FixedSingle'
$panel.BackColor = [System.Drawing.Color]::White
$form.Controls.Add($panel)

# GPU Temp
$labelGpu = New-Object System.Windows.Forms.Label
$labelGpu.Location = New-Object System.Drawing.Point(10,10)
$labelGpu.Size = New-Object System.Drawing.Size(430,25)
$labelGpu.Text = "GPU Temp: ? °C"
$panel.Controls.Add($labelGpu)

# Active Plan
$labelPlan = New-Object System.Windows.Forms.Label
$labelPlan.Location = New-Object System.Drawing.Point(10,45)
$labelPlan.Size = New-Object System.Drawing.Size(430,25)
$labelPlan.Text = "Active Plan: ?"
$panel.Controls.Add($labelPlan)

# Stage
$labelStage = New-Object System.Windows.Forms.Label
$labelStage.Location = New-Object System.Drawing.Point(10,80)
$labelStage.Size = New-Object System.Drawing.Size(430,25)
$labelStage.Text = "Stage: ?"
$panel.Controls.Add($labelStage)

# Live EPP Write-Back
$labelEpp = New-Object System.Windows.Forms.Label
$labelEpp.Location = New-Object System.Drawing.Point(10,115)
$labelEpp.Size = New-Object System.Drawing.Size(430,25)
$labelEpp.Text = "Last EPP Write: ?"
$panel.Controls.Add($labelEpp)

# Footer
$footer = New-Object System.Windows.Forms.Label
$footer.Text = "ThermoPilot v1.0 – Acer Optimized"
$footer.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$footer.ForeColor = [System.Drawing.Color]::Gray
$footer.Location = New-Object System.Drawing.Point(20,400)
$footer.Size = New-Object System.Drawing.Size(300,20)
$form.Controls.Add($footer)

# Close button
$buttonClose = New-Object System.Windows.Forms.Button
$buttonClose.Location = New-Object System.Drawing.Point(360,395)
$buttonClose.Size = New-Object System.Drawing.Size(100,30)
$buttonClose.Text = "Close"
$buttonClose.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$form.Controls.Add($buttonClose)

#-----------------------------
# EPP WRITE-BACK TRACKING
#-----------------------------

$lastEppValue = $null
$lastEppTime = $null

function Set-PlanEpp {
    param([string]$PlanGuid, [int]$EppValue)

    if ($EppValue -lt 0) { $EppValue = 0 }
    if ($EppValue -gt 100) { $EppValue = 100 }

    powercfg /SETACVALUEINDEX $PlanGuid $SubProcessorGuid $PerfEnergyPrefGuid $EppValue | Out-Null

    $script:lastEppValue = $EppValue
    $script:lastEppTime = (Get-Date).ToString("HH:mm:ss")
}

#-----------------------------
# MAIN LOGIC
#-----------------------------

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
    try {
        $gpuSensor.Hardware.Update()
        $gpuTemp = [math]::Round($gpuSensor.Value,1)

        $labelGpu.Text = "GPU Temp: $gpuTemp °C"

        $activeGuid = Get-ActiveSchemeGuid
        $activeName = if ($activeGuid) { Get-SchemeName $activeGuid } else { "Unknown" }
        $labelPlan.Text = "Active Plan: $activeName"

        if ($gpuTemp -ge $CriticalGpuTemp) {
            if ($activeGuid -ne $acerGuid) {
                powercfg /SETACTIVE $acerGuid | Out-Null
            }
            $labelStage.Text = "Stage: Cooling (Acer OEM)"
            return
        }

        if ($activeGuid -ne $tpGuid) {
            powercfg /SETACTIVE $tpGuid | Out-Null
        }

        $stageName = Get-StageForTemp -Temp $gpuTemp
        if ($stageName -and $stageName -ne $currentStageName) {
            $stage = $Stages[$stageName]
            Set-PlanEpp -PlanGuid $tpGuid -EppValue $stage.Epp
            $labelStage.Text = "Stage: $($stage.Label) (EPP $($stage.Epp))"
            $currentStageName = $stageName
        }

        if ($lastEppValue -ne $null) {
            $labelEpp.Text = "Last EPP Write: $lastEppValue at $lastEppTime"
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