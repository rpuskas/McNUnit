$job = Start-Job { Start-Sleep -Seconds 2; return 1..5 }

$null = Register-ObjectEvent $job -EventName StateChanged -Action {


    write-host "here"
    if($sender.State -eq 'Completed')
    {
        Receive-Job -job $job
        Remove-Job -job $job
        write-host "completed"
    } 
}   

