function Initialize-Matrix ($aliveCount=4, $yMin=0, $yMax=3, $xMin=0, $xMax=3)
{
    if([math]::Abs(($yMax-$yMin)*($xMax-$xMin)) -lt $aliveCount)
    {
        throw "AliveCount cannot exceed matrix capacity"
    }

    $matrix = @{}
    while($aliveCount)
    {
        $y = Get-Random -Minimum $yMin -Maximum ($yMax + 1)
        $x = Get-Random -Minimum $xMin -Maximum ($xMax + 1)
        if($matrix[$y])
        {
            if(!$matrix[$y][$x])
            {
                $matrix[$y].Add($x, 1)
                $aliveCount--
            }
        }
        else {
            $matrix.Add($y, @{ $x=1 })
            $aliveCount--
        }
    }
    return $matrix
}

function Show-MatrixInColors($matrix)
{
    Clear-Host

    [int]$yMin = $matrix.Keys | Sort-object | Select-Object -First 1
    [int]$yMax = $matrix.Keys | Sort-object | Select-Object -Last 1
    [int]$xMin = $matrix.Values.Keys | Sort-object | Select-Object -First 1
    [int]$xMax = $matrix.Values.Keys | Sort-object | Select-Object -Last 1

    $maxAbs = $yMin, $yMax, $xMin, $xMax | ForEach-Object { [math]::abs($_) } | Sort-Object | Select-Object -Last 1
    $digit = if([int]$maxAbs -eq 0) { 1 } else { [math]::floor([math]::log10($maxAbs)) +1 }

    for($y = $yMin; $y -le $yMax; $y++)
    {
        for($x = $xMin; $x -le $xMax; $x++)
        {
            if($matrix[$y] -and $matrix[$y][$x])
            {
                Write-Host ("[{0:d$digit}.{1:d$digit}]" -f $y, $x) -BackgroundColor Green -NoNewline
            }
            else
            {
                Write-Host ("[{0:d$digit}.{1:d$digit}]" -f $y, $x) -BackgroundColor Black -NoNewline
            }
        }
        Write-Host ""
    }
}

function Show-Matrix($matrix)
{
    [int]$yMin = $matrix.Keys | Sort-object | Select-Object -First 1
    [int]$yMax = $matrix.Keys | Sort-object | Select-Object -Last 1
    [int]$xMin = $matrix.Values.Keys | Sort-object | Select-Object -First 1
    [int]$xMax = $matrix.Values.Keys | Sort-object | Select-Object -Last 1

    $MatrixAsString = "`t$xMin`n"
    for($y = $yMin; $y -le $yMax; $y++)
    {
        $MatrixAsString += "$y`t"
        for($x = $xMin; $x -le $xMax; $x++)
        {
            if($matrix[$y] -and $matrix[$y][$x])
            {
                $MatrixAsString += "+"
            }
            else
            {
                $MatrixAsString += "-"
            }
        }
        $MatrixAsString += "`n"
    }

    Clear-Host
    Write-Host $MatrixAsString
}

function Start-Simulation($aliveCount=8, $size=4, $generationCount=10)
{
    $initMatrix = Initialize-Matrix -aliveCount $aliveCount -yMax $size -xMax $size
    $currentMatrix = $initMatrix

    for($i=0; $i -lt $generationCount; $i++)
    {
        Show-Matrix $currentMatrix
        $nextMatrix = Get-NextMatrix $currentMatrix
        $currentMatrix = $nextMatrix
        Start-Sleep 1
    }
}