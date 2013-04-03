function Run-Program
{
    $ProjectDir = Resolve-Path "..\"

    $TestDir = "$ProjectDir\McUnit.Runner\bin\Debug\"
    Add-Type -Path $TestDir"McUnit.Runner.dll"


    $object = New-Object -TypeName McUnit.Runner.ParallelRunner
    $object.Run() 
    
}

$elapsed = [System.Diagnostics.Stopwatch]::StartNew()
write-host "Started at $(get-date)"

Run-Program

write-host "Ended at $(get-date)"
write-host "Total Elapsed Time: $($elapsed.Elapsed.ToString())"
