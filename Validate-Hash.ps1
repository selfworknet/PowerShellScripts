# Execution: 
# powershell.exe Validate_Hash.ps1 -path "Path to file" -algo "Algorithm" -origin "Given hash"

# TODO:
# Add help page --> option -help     --> alias -h
# Add version   --> option -version  --> alias -v

param(
    [String]$path,  # Path
    [String]$algo,  # Algorithm
    [String]$origin # Given hash 
)


# Font threepoint --> http://www.network-science.de/ascii/
function Title() {
"
\  / _ |. _| _ _|_ _   |_| _  _|_ 
 \/ (_|||(_|(_| | (/_  | |(_|_\| |
                              v0.2

"
}

$filehash = Get-FileHash $path -Algorithm $algo

function Print() {
    
    Clear-Host
    Title
    Write-Host "Calculated hash: " 
    Write-Host $filehash.Hash.ToLower()
    Write-Host ("  ------------  ")
    Write-Host "Source hash: " 
    Write-Host $origin.ToLower()
}

if ($filehash.Hash -eq $origin) {
    Print
    Write-Host ("+------------+") -ForegroundColor DarkGreen
    Write-Host ("| File valid |") -ForegroundColor DarkGreen
    Write-Host ("+------------+") -ForegroundColor DarkGreen
} else {
    Print
    Write-Host ("+---------------+") -ForegroundColor Red
    Write-Host ("| File corrupt! |") -ForegroundColor Red
    Write-Host ("+---------------+") -ForegroundColor Red
}