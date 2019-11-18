function Get-LiveNeighborCount ($matrix, $x, $y)
{
    $count = 0
    if ($matrix[$y-1]) {
        $count += $matrix[$y-1][$x-1]
        $count += $matrix[$y-1][$x]
        $count += $matrix[$y-1][$x+1]
    } 
    if ($matrix[$y]) {
        $count += $matrix[$y][$x-1]
        $count += $matrix[$y][$x+1]
    } 
    if ($matrix[$y+1]) {
        $count += $matrix[$y+1][$x-1]
        $count += $matrix[$y+1][$x]
        $count += $matrix[$y+1][$x+1]
    } 
    return $count
}

function Get-CurrentState ($matrix, $x, $y)
{
    if($matrix[$y] -and $matrix[$y][$x])
    {
        return 1
    }
    return 0
}

function Get-NextState ($matrix, $x, $y)
{
    $liveNeighborsCount = Get-LiveNeighborCount -matrix $matrix -x $x -y $y
    if($liveNeighborsCount -eq 3 -or ($matrix[$y][$x] -and $liveNeighborsCount -eq 2))
    {
        return 1
    }
    return 0 
}

function Add-Alive ($matrix, $x, $y)
{
    if($matrix[$y])
    {
        if(!$matrix[$y][$x])
        {
            $matrix[$y].Add($x, 1)
        }
    }
    else
    {
        $matrix.Add($y, @{ $x=1 })
    }
}

function Update-Candidate ($matrix, $x, $y)
{
    if($matrix[$y])
    {
        if($matrix[$y][$x])
        {
            $matrix[$y][$x]++
        }
        else
        {
            $matrix[$y].Add($x, 1)
        }
    }
    else
    {
        $matrix.Add($y, @{ $x=1 })
    }
}

function Update-Candidates ($matrix, $x, $y, $candidates)
{
    for($i=-1; $i -le 1; $i++)
    {
        for($j=-1; $j -le 1; $j++)
        {
            $currentState = Get-CurrentState -y ($y+$i) -x ($x+$j) -matrix $matrix
            if($currentState -eq 0)
            {
                Update-Candidate -y ($y+$i) -x ($x+$j) -matrix $candidates
            }
        }
    }
}

function Select-Candidates ($matrix, $candidates)
{
    foreach ($row in $candidates.GetEnumerator())
    {
        foreach($cell in $row.Value.GetEnumerator())
        {
            if($cell.Value -eq 3)
            {
                Add-Alive -matrix $matrix -x $cell.Name -y $row.Name
            }
        }
    }
}

function Get-NextMatrix ($matrix)
{
    $nextMatrix = @{}
    $candidates = @{}

    foreach ($row in $matrix.GetEnumerator())
    {
        foreach($cell in $row.Value.GetEnumerator())
        {
            Update-Candidates -x $cell.Name -y $row.Name -candidates $candidates -matrix $matrix
            $nextState = Get-NextState -x $cell.Name -y $row.Name -matrix $matrix
            if($nextState)
            {
                Add-Alive -x $cell.Name -y $row.Name -matrix $nextMatrix
            }
        }
    }

    Select-Candidates -matrix $nextMatrix -candidates $candidates

    return $nextMatrix
}