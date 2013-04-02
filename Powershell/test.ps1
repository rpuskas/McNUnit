function Run-Program
{
    
    $environments = @(1..30)
    $jobs = @()
    foreach($env in $environments)
    {
       $jobs += Start-Job -ScriptBlock { param($iteration) Start-Sleep -s 1; write-host "completed: $iteration";} -ArgumentList $env
    }

    foreach($job in $jobs)
    {
        Wait-Job $job
        Receive-Job -job $job
        Remove-Job -job $job
    }
}

$elapsed = [System.Diagnostics.Stopwatch]::StartNew()
write-host "Started at $(get-date)"

Run-Program

write-host "Ended at $(get-date)"
write-host "Total Elapsed Time: $($elapsed.Elapsed.ToString())"

