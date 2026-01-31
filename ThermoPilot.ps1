# ThermoPilot Universal Edition v1.0.3
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

# GPU temp stages are still used as a secondary input
$Stages = [ordered]@{
    Cool = @{ Min=0;  Max=55; Epp=10; Label="Cool" }
    Warm = @{ Min=56; Max=70; Epp=35; Label="Warm" }
    Hot  = @{ Min=71; Max=75; Epp=55; Label="Hot"  }
}

$CpuWarnTemp    = 90
$CpuMaxTemp     = 95
$PollIntervalMs = 2000

# Smoothing for utilization
$SmoothingFactor   = 0.25
$CPU_Util_Smoothed = 0
$GPU_Util_Smoothed = 0

# Default EPP for SAFE MODE / idle
$DefaultEpp = 20

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

function Find-CpuLoadSensor {
    foreach ($hw in $computer.Hardware) {
        if ($hw.HardwareType -eq 'Cpu') {
            $hw.Update()
            foreach ($s in $hw.Sensors) {
                if ($s.SensorType -eq 'Load' -and $s.Name -eq 'CPU Total') {
                    return $s
                }
            }
        }
    }
    return $null
}

function Find-GpuLoadSensor {
    foreach ($hw in $computer.Hardware) {
        if ($hw.HardwareType -eq 'GpuAmd' -or $hw.HardwareType -eq 'GpuNvidia') {
            $hw.Update()
            foreach ($s in $hw.Sensors) {
                if ($s.SensorType -eq 'Load' -and $s.Name -match 'GPU Core') {
                    return $s
                }
            }
        }
    }
    return $null
}

$cpuSensor     = Find-CpuTempSensor
$gpuSensor     = Find-GpuTempSensor
$cpuLoadSensor = Find-CpuLoadSensor
$gpuLoadSensor = Find-GpuLoadSensor

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

if (-not $cpuLoadSensor -or -not $gpuLoadSensor) {
    [System.Windows.Forms.MessageBox]::Show(
        "Missing CPU or GPU utilization sensors.",
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
$labelStage.AutoSize = $false
$labelStage.Size = New-Object System.Drawing.Size(430, 25)
$labelStage.Location = New-Object System.Drawing.Point(10, 100)
$labelStage.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$labelStage.TextAlign = "MiddleLeft"
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
$labelLock.TextAlign = 'MiddleLeft'
$labelLock.AutoEllipsis = $false
$labelLock.Text = "EPP Status: Normal"
$panel.Controls.Add($labelLock)

$footer = New-Object System.Windows.Forms.Label
$footer.Text = "ThermoPilot v1.0.3 – Universal"
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

$lastEppValue  = $null
$lastEppTime   = $null
$wroteThisTick = $false

function Set-PlanEpp {
    param([string]$PlanGuid, [int]$EppValue)

    if ($EppValue -lt 0)   { $EppValue = 0 }
    if ($EppValue -gt 100) { $EppValue = 100 }

    powercfg /SETACVALUEINDEX $PlanGuid $SubProcessorGuid $PerfEnergyPrefGuid $EppValue | Out-Null

    $script:lastEppValue  = $EppValue
    $script:lastEppTime   = (Get-Date).ToString("HH:mm:ss")
    $script:wroteThisTick = $true
}

#----------------------------------
# BOTTLENECK + TELEMETRY HELPERS
#----------------------------------

function Smooth {
    param($Prev, $New)
    return ($Prev * (1 - $SmoothingFactor)) + ($New * $SmoothingFactor)
}

function Get-LibreData {
    try {
        if ($cpuSensor)     { $cpuSensor.Hardware.Update() }
        $gpuSensor.Hardware.Update()
        $cpuLoadSensor.Hardware.Update()
        $gpuLoadSensor.Hardware.Update()
    }
    catch {
        return [PSCustomObject]@{
            Valid    = $false
            Reason   = "Hardware update failed"
            CPU_Util = $null
            GPU_Util = $null
            GPU_Temp = $null
            CPU_Temp = $null
        }
    }

    $cpuTemp = $null
    if ($cpuSensor) {
        $cpuTemp = [math]::Round($cpuSensor.Value,1)
    }

    $gpuTemp = [math]::Round($gpuSensor.Value,1)
    $cpuLoad = [math]::Round($cpuLoadSensor.Value,0)
    $gpuLoad = [math]::Round($gpuLoadSensor.Value,0)

    if ($gpuTemp -lt 0 -or $cpuLoad -lt 0 -or $gpuLoad -lt 0) {
        return [PSCustomObject]@{
            Valid    = $false
            Reason   = "Invalid negative values"
            CPU_Util = $cpuLoad
            GPU_Util = $gpuLoad
            GPU_Temp = $gpuTemp
            CPU_Temp = $cpuTemp
        }
    }

    return [PSCustomObject]@{
        Valid    = $true
        Reason   = "OK"
        CPU_Util = $cpuLoad
        GPU_Util = $gpuLoad
        GPU_Temp = $gpuTemp
        CPU_Temp = $cpuTemp
    }
}

function Get-BottleneckState {
    param($CPU, $GPU)

    if ($GPU -ge 85 -and $CPU -le 70) { return "GPU_BOUND" }
    if ($CPU -ge 85 -and $GPU -le 70) { return "CPU_BOUND" }
    if ($CPU -ge 70 -and $GPU -ge 70) { return "MIXED" }
    if ($CPU -lt 40 -and $GPU -lt 40) { return "IDLE" }

    return "MIXED"
}

function Select-EPP {
    param(
        [string]$State,
        [double]$GPUTemp,
        [double]$CPUTemp
    )

    # CPU thermal overrides first
    if ($CPUTemp -ne $null) {
        if ($CPUTemp -ge $CpuMaxTemp) {
            return 90
        }
        elseif ($CPUTemp -ge $CpuWarnTemp) {
            return 60
        }
    }

    switch ($State) {
        "GPU_BOUND" {
            if ($GPUTemp -ge 75) { return 55 }  # Hot
            else                 { return 35 }  # Warm
        }
        "CPU_BOUND" {
            return 10  # Cool
        }
        "MIXED" {
            if ($GPUTemp -ge 80) { return 35 }  # Warm
            else                 { return 10 }  # Cool
        }
        "IDLE" {
            return $DefaultEpp
        }
    }
}

#----------------------------------
# MAIN LOGIC (TIMER LOOP)
#----------------------------------

$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = $PollIntervalMs

$timer.Add_Tick({
    $script:wroteThisTick = $false

    try {
        $data = Get-LibreData

        if (-not $data.Valid) {
            $labelStage.Text = "Stage: SAFE MODE – $($data.Reason)"
            $labelLock.Text  = "EPP Status: SAFE MODE"
            $labelLock.ForeColor = [System.Drawing.Color]::Red

            $activeGuid = Get-ActiveSchemeGuid
            if ($activeGuid) {
                Set-PlanEpp -PlanGuid $activeGuid -EppValue $DefaultEpp
            }

            if ($data.GPU_Temp -ne $null) {
                $labelGpu.Text = "GPU Temp: $($data.GPU_Temp) °C"
            }
            if ($data.CPU_Temp -ne $null) {
                $labelCpu.Text = "CPU Temp: $($data.CPU_Temp) °C"
            }

            return
        }

        # Update temps
        $labelGpu.Text = "GPU Temp: $($data.GPU_Temp) °C"
        if ($data.CPU_Temp -ne $null) {
            $labelCpu.Text = "CPU Temp: $($data.CPU_Temp) °C"
        } else {
            $labelCpu.Text = "CPU Temp: N/A"
        }

        # Active plan
        $activeGuid = Get-ActiveSchemeGuid
        $labelPlan.Text = "Active Plan: $(Get-SchemeName $activeGuid)"

        # Smooth utilization
        $CPU_Util_Smoothed = Smooth $CPU_Util_Smoothed $data.CPU_Util
        $GPU_Util_Smoothed = Smooth $GPU_Util_Smoothed $data.GPU_Util

        # Bottleneck + EPP
        $state     = Get-BottleneckState -CPU $CPU_Util_Smoothed -GPU $GPU_Util_Smoothed
        $targetEpp = Select-EPP -State $state -GPUTemp $data.GPU_Temp -CPUTemp $data.CPU_Temp

        if ($activeGuid) {
            Set-PlanEpp -PlanGuid $activeGuid -EppValue $targetEpp
        }

        $labelStage.Text = "Stage: $state (EPP $targetEpp)"

        if ($lastEppValue -ne $null) {
            $labelEpp.Text = "Last EPP Write: $lastEppValue at $lastEppTime"
        }

        $labelLock.Text = "EPP Status: Normal"
        $labelLock.ForeColor = [System.Drawing.Color]::Black
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
