function Run-Program
{
    $ProjectDir = Resolve-Path "..\"
    $TestDll = "$ProjectDir\McUnit.TestScenarios\bin\Debug\McUnit.TestScenarios.dll"
    $RunnerDll = "$ProjectDir\McUnit.Runner\bin\Debug\McUnit.Runner.dll"

    Add-Type -Path $RunnerDll


    $object = New-Object -TypeName McUnit.Runner.ParallelRunner -ArgumentList 2,$TestDll
    $object.Run() 
    
}

$elapsed = [System.Diagnostics.Stopwatch]::StartNew()
write-host "Started at $(get-date)"

Run-Program

write-host "Ended at $(get-date)"
write-host "Total Elapsed Time: $($elapsed.Elapsed.ToString())"
