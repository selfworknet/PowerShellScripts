function StartOrFocusApp {
    param (
        [string]$processName,
        [string]$exePath
    )
    # Prüfen, ob der Prozess läuft
    $runningProcess = Get-Process -Name $processName -ErrorAction SilentlyContinue

    if ($null -eq $runningProcess) {
        # Programm starten, wenn nicht geöffnet
        Start-Process $exePath
        Write-Host "$processName gestartet."
    } else {
        Write-Host "$processName läuft bereits."
    }
}

# Programme starten oder fokussieren
StartOrFocusApp -processName "firefox" -exePath "C:\Program Files\Mozilla Firefox\firefox.exe"
StartOrFocusApp -processName "chrome" -exePath "C:\Program Files\Google\Chrome\Application\chrome.exe"
StartOrFocusApp -processName "Code" -exePath "C:\Program Files\VSCodium\VSCodium.exe"

# Warten, damit Fenster sicher geladen sind
Start-Sleep -Seconds 5

# Fenster-Handles wie zuvor abrufen und verschieben
$firefoxHandle = [WindowManager]::FindWindow($null, "Mozilla Firefox")
$chromeHandle = [WindowManager]::FindWindow($null, "Google Chrome")
$vsCodiumHandle = [WindowManager]::FindWindow($null, "Visual Studio Code")

# Bildschirmgröße abrufen
$screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
$screenHeight = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height

# Größen und Positionen berechnen
$halfWidth = [math]::Floor($screenWidth / 2)
$halfHeight = [math]::Floor($screenHeight / 2)

# Fenster positionieren
[WindowManager]::SetWindowPos($firefoxHandle, [IntPtr]::Zero, 0, 0, $halfWidth, $halfHeight, [WindowManager]::SWP_NOZORDER -bor [WindowManager]::SWP_SHOWWINDOW)
[WindowManager]::SetWindowPos($chromeHandle, [IntPtr]::Zero, 0, $halfHeight, $halfWidth, $halfHeight, [WindowManager]::SWP_NOZORDER -bor [WindowManager]::SWP_SHOWWINDOW)
[WindowManager]::SetWindowPos($vsCodiumHandle, [IntPtr]::Zero, $halfWidth, 0, $halfWidth, $screenHeight, [WindowManager]::SWP_NOZORDER -bor [WindowManager]::SWP_SHOWWINDOW)

# Fenster in den Vordergrund holen
[WindowManager]::ShowWindow($firefoxHandle, [WindowManager]::SW_RESTORE)
[WindowManager]::ShowWindow($chromeHandle, [WindowManager]::SW_RESTORE)
[WindowManager]::ShowWindow($vsCodiumHandle, [WindowManager]::SW_RESTORE)
