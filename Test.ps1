<#
    .SYNOPSIS
    Does actually nothing useful

    .DESCRIPTION
    Just greeting the user

    .PARAMETER Name
    User name

    .EXAMPLE
    Test -Name "Lutscher"
#>



    param(
    [string] $Name
    )
    
    Write-Host "Hello $Name"

