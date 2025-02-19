## Instancia para elejir el tema del oh-my-posh
oh-my-posh init pwsh --config 'C:\Users\Paul Jourdan\AppData\Local\Programs\oh-my-posh\themes\clean-detailed.omp.json' | Invoke-Expression
## Import de los iconos
Import-Module Terminal-Icons
## Lista de comando
Set-PSReadLineOption -PredictionViewStyle ListView
## Alias ls-l para mostrar los archivos de una carpeta
function ls-l {
    param([string]$path = ".")
    Get-ChildItem -Path $path | Format-Table
}
<#
.SYNOPSIS
Funcion que muestra los archivos de una carpeta con la información detallada

.DESCRIPTION
Funcion que muestra los archivos de una carpeta con la información detallada

.PARAMETER path
La ruta de la carpeta a listar

.EXAMPLE
ls-la

.NOTES
General notes
#>
function ls-la {
    param([string]$path = ".")
    Get-ChildItem -Path $path -Force | Format-Table
}
<#
.SYNOPSIS
Comando para localizar archivos en una carpeta

.DESCRIPTION
comando para localizar archivos en una carpeta

.PARAMETER name
Nombre del archivo a buscar

.PARAMETER path
Ruta de la carpeta donde buscar

.EXAMPLE
Locate -name "file" -path "C:\Users\Paul Jourdan"

.NOTES
General notes
#>
function Locate {
    param (
        [string]$name,
        [string]$path = "C:\"
    )
    Get-ChildItem -Path $path -Recurse -Force -Filter "*$name*" -ErrorAction SilentlyContinue
}
<#
.SYNOPSIS
Ver tamaño de la carpeta

.DESCRIPTION
Comando para ver el tamaño de una carpeta

.PARAMETER path
Ruta de la carpeta a analizar

.PARAMETER unit
Unidad de medida: "MB" o "GB"

.EXAMPLE
Get-FolderSizes -path "C:\Users\Paul Jourdan" -unit "GB"

.NOTES
General notes
#>
function Get-FolderSizes {
    param (
        [string]$path = (Get-Location),  # Si no se proporciona, usa la carpeta actual
        [string]$unit = "MB"             # Unidad de medida: "MB" o "GB"
    )

    # Factor de conversión según la unidad seleccionada
    $conversionFactor = if ($unit -eq "GB") { 1GB } else { 1MB }

    # Inicializamos la variable de tamaño total
    $totalSize = 0

    # Procesamos cada carpeta
    $folders = Get-ChildItem -Directory -Path $path | ForEach-Object {
        $folderPath = $_.FullName

        # Intentamos calcular el tamaño de la carpeta
        try {
            $folderSize = (Get-ChildItem -Path $folderPath -Recurse -Force | Measure-Object -Property Length -Sum).Sum / $conversionFactor
            $totalSize += $folderSize

            # Contamos los archivos en la carpeta
            $fileCount = (Get-ChildItem -Path $folderPath -Recurse -Force | Measure-Object).Count

            # Creamos el objeto con la información
            [PSCustomObject]@{
                NombreDeCarpeta = $_.Name
                Tamaño = ("{0:N2} " -f $folderSize) + $unit
                Archivos = $fileCount
            }
        } catch {
            # Si ocurre un error, muestra un mensaje y continúa con la siguiente carpeta
            Write-Host "No se puede acceder a la carpeta: $folderPath" -ForegroundColor Yellow
        }
    }

    # Mostramos la tabla de resultados
    $folders | Format-Table -AutoSize

    # Formateamos el tamaño total en una cadena
    $totalSizeFormatted = "{0:N2} {1}" -f $totalSize, $unit
    Write-Host "Tamaño total en $unit $totalSizeFormatted"
}