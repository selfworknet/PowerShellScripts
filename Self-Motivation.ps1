param($strength = 1, $progressItem = '#', $waitTime = 30)

 

$question = "`nWho's the best programmer?`n"

 

function ProgressBar {

    $bar = ,($progressItem) * 30

    foreach($item in $bar){

        Start-Sleep -Milliseconds $waitTime

        Write-Host $item -NoNewline

    }

    Write-Host `n

}

 

Clear-Host

Write-Host $question -ForegroundColor Yellow

Start-Sleep -Seconds 1

ProgressBar

 

$result = " very" * $strength

 

Write-Host "You're the$result best Programmer! :) "`n -ForegroundColor Green