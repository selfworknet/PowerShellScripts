<#
    .SYNOPSIS
    Organizes multiple programs on screen in grid layout.

    .DESCRIPTION
    Opens programs or gets already opened instances and distributes them
    on a single screen in specific grid layout.
#>

# Import of needed namespaces
Add-Type -AssemblyName System.Windows.Forms

# Definition der WindowManager-Klasse
if (-not ([System.Management.Automation.PSTypeName]'WindowManager').Type) {
    Add-Type @"
    using System;
    using System.Runtime.InteropServices;

    public class WindowManager {
        [DllImport("user32.dll", SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);

        [DllImport("user32.dll", SetLastError = true)]
        public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

        public const uint SWP_NOZORDER = 0x0004;
        public const uint SWP_SHOWWINDOW = 0x0040;
        public const int SW_RESTORE = 9;
    }
"@
}

# Function: Starts a program or finds window handle
function StartOrFocusProgram {
    param (
        [string]$processName,
        [string]$exePath
    )

    # Check process
    $runningProcess = Get-Process -Name $processName -ErrorAction SilentlyContinue

    if ($null -eq $runningProcess) {
        # Start program
        Start-Process $exePath
        Write-Host "$processName started."
        Start-Sleep -Seconds 5 # Delay for starting
    } else {
        Write-Host "$processName runs already."
    }

    # Search main window handle
    foreach ($proc in Get-Process -Name $processName -ErrorAction SilentlyContinue) {
        if ($proc.MainWindowHandle -ne 0) {
            return [IntPtr]$proc.MainWindowHandle
        }
    }

    return [IntPtr]::Zero # Found no window
}

# Start programs or focus
$firefoxHandle = StartOrFocusProgram -processName "firefox" -exePath "C:\Program Files\Mozilla Firefox\firefox.exe"
$chromeHandle = StartOrFocusProgram -processName "chrome" -exePath "C:\Program Files\Google\Chrome\Application\chrome.exe"
$vscodiumHandle = StartOrFocusProgram -processName "VSCodium" -exePath "C:\Program Files\VSCodium\VSCodium.exe"

# Get screen size
$screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
$screenHeight = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height

# Calculate sizes and positions
$halfWidth = [math]::Floor($screenWidth / 2)
$halfHeight = [math]::Floor($screenHeight / 2)

# Sets windows in normal mode if they're maximized
if ($firefoxHandle -ne [IntPtr]::Zero) {
    [WindowManager]::ShowWindow($firefoxHandle, [WindowManager]::SW_RESTORE)
    [WindowManager]::SetWindowPos($firefoxHandle, [IntPtr]::Zero, 0, 0, $halfWidth, $halfHeight, [WindowManager]::SWP_NOZORDER -bor [WindowManager]::SWP_SHOWWINDOW)
}

if ($chromeHandle -ne [IntPtr]::Zero) {
    [WindowManager]::ShowWindow($chromeHandle, [WindowManager]::SW_RESTORE)
    [WindowManager]::SetWindowPos($chromeHandle, [IntPtr]::Zero, 0, $halfHeight, $halfWidth, $halfHeight, [WindowManager]::SWP_NOZORDER -bor [WindowManager]::SWP_SHOWWINDOW)
}

if ($vscodiumHandle -ne [IntPtr]::Zero) {
    [WindowManager]::ShowWindow($vscodiumHandle, [WindowManager]::SW_RESTORE)
    [WindowManager]::SetWindowPos($vscodiumHandle, [IntPtr]::Zero, $halfWidth, 0, $halfWidth, $screenHeight, [WindowManager]::SWP_NOZORDER -bor [WindowManager]::SWP_SHOWWINDOW)
}

# Completion message
Write-Host "All windows successfully positioned."
