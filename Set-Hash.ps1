# Execution:
# powershell.exe Set-Hash.ps1 -path "Path to file" -algo "Algorithm"

param(
[String]$path, # $path = Path
[String]$algo  # $algo = Algorithm  
)

# Font threepoint --> http://www.network-science.de/ascii/
function Title() {
"
(~ _ _|_  |_| _  _|_ 
_)(/_ |   | |(_|_\| |
                 v0.2
"
}

Clear-Host
Title
$filehash = Get-FileHash $path -Algorithm $algo
$filehash | Format-List