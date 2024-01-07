# Auführung: powershell.exe GetFreeMemoryCopy -lw [Laufwerksbuchstabe] - u [Einheit]
# Damit das funktioniert, muss der Pfad des Verzeichnisses, in dem das Script liegt, in der Path-Variable angelegt sein

param(
    [String]$lw, # lw = Laufwerk
    [String]$u   # u = Einheit
)

try {
    $Unit = $u.ToUpper()
    $lw = $lw.ToUpper()
    $Drive = Get-Volume -DriveLetter $lw
    $Prozent = ($Drive.SizeRemaining / $Drive.Size) * 100
    $Exponent = 1
    $BasisBin = 1024
    $BasisDez = 1000
    $RoundFaktor = 0

    switch ($Unit) {
        "T" {
            $Exponent = 4 
            $RoundFaktor = 3; Break
        }
        "G" { $Exponent = 3; Break }
        "M" { $Exponent = 2; Break }
        "K" { $Exponent = 1; Break }
        Default {
            Write-Host "Keine Übereinstimmung für Einheit."
            return
        }
    }

    Write-Host 
    Write-Host "Verfügbarer Speicher auf" $lw": " -NoNewline
    Write-Host ([Math]::Round($Drive.SizeRemaining / [Math]::Pow($BasisBin, $Exponent), $RoundFaktor)) $Unit"iB" -NoNewline
    Write-Host " ="([Math]::Round($Drive.SizeRemaining / [Math]::Pow($BasisDez, $Exponent), $RoundFaktor)) $Unit"B =>"([Math]::Round($Prozent, 1)) "%"
    Write-Host
}

catch {
    Write-Host "Fehlende(s) Argument(e) oder ungültiges Laufwerk."
    return
}
