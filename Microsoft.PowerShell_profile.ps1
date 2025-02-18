## Instancia para elejir el tema del oh-my-posh
oh-my-posh init pwsh --config 'C:\Users\Paul Jourdan\AppData\Local\Programs\oh-my-posh\themes\clean-detailed.omp.json' | Invoke-Expression
## Import de los iconos
Import-Module Terminal-Icons
## Lista de comando
Set-PSReadLineOption -PredictionViewStyle ListView