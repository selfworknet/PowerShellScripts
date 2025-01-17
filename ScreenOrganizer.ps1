# Funktionen für das Fenster-Management
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class WindowManager {
    [DllImport("user32.dll", SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);

    [DllImport("user32.dll", SetLastError = true)]
    public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool IsWindowVisible(IntPtr hWnd);

    public const uint SWP_NOZORDER = 0x0004;
    public const uint SWP_SHOWWINDOW = 0x0040;
    public const int SW_RESTORE = 9;
}
"@

# Programme starten
Start-Process "C:\Program Files\Mozilla Firefox\firefox.exe"
Start-Process "C:\Program Files\Google\Chrome\Application\chrome.exe"
Start-Process "C:\Program Files\VSCodium\VSCodium.exe"

# Warten, damit die Fenster Zeit haben, sich zu öffnen
Start-Sleep -Seconds 5

# Fenster-Handle abrufen
$firefoxHandle = [WindowManager]::FindWindow($null, "Mozilla Firefox")
$chromeHandle = [WindowManager]::FindWindow($null, "Google Chrome")
$vscodiumHandle = [WindowManager]::FindWindow($null, "VSCodium")

# Bildschirmgröße abrufen
$screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
$screenHeight = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height

# Größen und Positionen berechnen
$halfWidth = [math]::Floor($screenWidth / 2)
$halfHeight = [math]::Floor($screenHeight / 2)

# Firefox: links oben
[WindowManager]::SetWindowPos($firefoxHandle, [IntPtr]::Zero, 0, 0, $halfWidth, $halfHeight, [WindowManager]::SWP_NOZORDER -bor [WindowManager]::SWP_SHOWWINDOW)

# Chrome: links unten
[WindowManager]::SetWindowPos($chromeHandle, [IntPtr]::Zero, 0, $halfHeight, $halfWidth, $halfHeight, [WindowManager]::SWP_NOZORDER -bor [WindowManager]::SWP_SHOWWINDOW)

# VS Code: rechts (ganze Höhe)
[WindowManager]::SetWindowPos($vscodiumHandle, [IntPtr]::Zero, $halfWidth, 0, $halfWidth, $screenHeight, [WindowManager]::SWP_NOZORDER -bor [WindowManager]::SWP_SHOWWINDOW)

# Fenster in den Vordergrund holen
[WindowManager]::ShowWindow($firefoxHandle, [WindowManager]::SW_RESTORE)
[WindowManager]::ShowWindow($chromeHandle, [WindowManager]::SW_RESTORE)
[WindowManager]::ShowWindow($vscodiumHandle, [WindowManager]::SW_RESTORE)
