<#
    .SYNOPSIS
    Renames multiple files of the given format type with the given name and increasing number.

    .DESCRIPTION
    Renames multiple files of the given format type with the given name and increasing number.

    .PARAMETER suffix
    Any kind of media format like *.txt, *.pdf, *.jpg and so on.

    .PARAMETER baseName
    The new name of the file(s).

    .EXAMPLE
    Rename-Files.ps1 -extension ".jpg" -baseName "Vacation2023"
#>

param(
    [Parameter(Mandatory)]
    # Extension (like .txt or .pdf etc)
    [String]$extension,  

    [Parameter(Mandatory)]
    # Base name for the new files (like image or doc etc.)
    [String]$baseName 
)

$files = Get-ChildItem -Filter $suffix -File -Path .
# $extension = $extension.Replace("*", "")
$count = 0

foreach ($file in $files) {
    $count = $count + 1
    $newName = "{0}_{1}{2}" -f $baseName, $count, $extension
    Rename-Item -NewName $newName -Path $file.FullName
}

Write-Host ("`n{0} files have been renamed.`n" -f $count)
