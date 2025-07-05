function Get-BatteryInfo {
    $battery = Get-CimInstance -ClassName Win32_Battery
    return @{
        Percentage = $battery.EstimatedChargeRemaining
        PluggedIn = $battery.BatteryStatus -eq 2  # 2 indicates "Charging"
    }
}

#main-Logic 
$BatteryInfo = Get-BatteryInfo

if ($BatteryInfo.PluggedIn) {
    $BatteryPercentage = $BatteryInfo.Percentage
    if ($BatteryPercentage -ge 80 and Get-LenovoChargingMode -ne "Conservation") {
        Set-LenovoChargingMode -Mode "Conservation"
    } else if (($BatteryPercentage -ge 50 and $BatteryPercentage -le 60) -and Get-LenovoChargingMode -ne "Normal") {
        Set-LenovoChargingMode -Mode "Normal"
    }
}