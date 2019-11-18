if(!(Get-Module Pester))
{
    Install-Module -Name Pester -Force
}

Describe "GameOfLife" {

    $CommandPath = (Get-Location).Path | Split-Path -Parent
    . "$CommandPath\CodeRetreat\GameOfLife.ps1"

    Context "Get-LiveNeighborCount" {

        $matrix = @{    0 = @{ 0=1; 1=1; 2=1 }
                        1 = @{ 1=1; 2=1 }
                    }

        It "Should get neighbours" {
            Get-LiveNeighborCount -matrix $matrix -x 0 -y 0 | Should Be 2
            Get-LiveNeighborCount -matrix $matrix -x 1 -y 0 | Should Be 4
            Get-LiveNeighborCount -matrix $matrix -x 2 -y 0 | Should Be 3
            Get-LiveNeighborCount -matrix $matrix -x 0 -y 1 | Should Be 3
            Get-LiveNeighborCount -matrix $matrix -x 1 -y 1 | Should Be 4
            Get-LiveNeighborCount -matrix $matrix -x 2 -y 1 | Should Be 3
            Get-LiveNeighborCount -matrix $matrix -x 0 -y 2 | Should Be 1
            Get-LiveNeighborCount -matrix $matrix -x 1 -y 2 | Should Be 2
            Get-LiveNeighborCount -matrix $matrix -x 2 -y 2 | Should Be 2
            Get-LiveNeighborCount -matrix $matrix -x 0 -y 3 | Should Be 0
        }
    }

    Context "Get-CurrentState" {

        $matrix = @{ 0 = @{ 10=1 } }

        It "Should be alive" {
            Get-CurrentState -matrix $matrix -x 10 -y 0 | Should Be 1
        }
        It "Should be dead" {
            Get-CurrentState -matrix $matrix -x 0 -y 0 | Should Be 0
        }
    }

    Context "Get-NextState" {

        $matrix = @{
            0 = @{ 10=1 }
            1 = @{ 8=1; 9=1 }
            2 = @{ 9=1 }
        }

        It "Should survive" {
            Get-NextState -matrix $matrix -x 8 -y 2 | Should Be 1
        }
        It "Should die" {
            Get-NextState -matrix $matrix -x 10 -y 0 | Should Be 0
        }
    }
    
    Context "Add-Alive" {

        $matrix = @{}
        $x = 0
        $y = 0

        It "Should add alive" {
            Add-Alive -x $x -y $y -matrix $matrix
            $matrix[$y][$x] | Should Be 1
        }

        It "Should not add duplicate" {
            { Add-Alive -x $x -y $y -matrix $matrix } | Should Not Throw
            $matrix[$y][$x] | Should Be 1
        }
    }

    Context "Update-Candidate" {

        $matrix = @{}
        $x = 0
        $y = 0

        It "Should increment candidate" {
            Update-Candidate -x $x -y $y -matrix $matrix
            $matrix[$y][$x] | Should Be 1
            Update-Candidate -x $x -y $y -matrix $matrix
            $matrix[$y][$x] | Should Be 2
        }
    }

    Context "Update-Candidates" {

        $matrix = @{    0 = @{ 0=1; 1=1; 2=1 }
                        1 = @{ 1=1; 2=1 }
                    }
        $candidates = @{}

        It "Should Update-Candidates from [0,0]" {
            Update-Candidates -x 0 -y 0 -candidates $candidates -matrix $matrix
            $candidates[-1][-1] | Should Be 1
            $candidates[-1][0] | Should Be 1
            $candidates[-1][1] | Should Be 1
            $candidates[0][-1] | Should Be 1
            $candidates[1][-1] | Should Be 1
            $candidates[1][0] | Should Be 1
        }

        It "Should Update-Candidates from [0,1]" {
            Update-Candidates -x 1 -y 0 -candidates $candidates -matrix $matrix
            $candidates[-1][2] | Should Be 1
            $candidates[-1][-1] | Should Be 1
            $candidates[-1][0] | Should Be 2
            $candidates[-1][1] | Should Be 2
            $candidates[0][-1] | Should Be 1
            $candidates[1][-1] | Should Be 1
            $candidates[1][0] | Should Be 2
        }

        It "Should Update-Candidates from [0,2]" {
            Update-Candidates -x 2 -y 0 -candidates $candidates -matrix $matrix
            $candidates[1][3] | Should Be 1
            $candidates[0][3] | Should Be 1
            $candidates[-1][3] | Should Be 1
            $candidates[-1][2] | Should Be 2
            $candidates[-1][-1] | Should Be 1
            $candidates[-1][0] | Should Be 2
            $candidates[-1][1] | Should Be 3
            $candidates[0][-1] | Should Be 1
            $candidates[1][-1] | Should Be 1
            $candidates[1][0] | Should Be 2
        }
    }

    Context "Get-NextMatrix" {

        $matrix = @{
            0 = @{ 10=1 }
            1 = @{ 8=1; 9=1 }
            2 = @{ 9=1 }
        }
        
        $resultMatrix = Get-NextMatrix -matrix $matrix

        It "3 should survive" {
            $resultMatrix[1][8] | Should Be 1
            $resultMatrix[1][9] | Should Be 1
            $resultMatrix[2][9] | Should Be 1
        }

        It "3 should reporoduce" {
            $resultMatrix[2][8] | Should Be 1
            $resultMatrix[0][9] | Should Be 1
            $resultMatrix[1][10] | Should Be 1
        }

        It "1 should die" {
            $resultMatrix[0][10] | Should Be $null
        }

        It "6 should be alive" {
            $resultMatrix.Values.Keys.Count | Should Be 6
        }
    }
}