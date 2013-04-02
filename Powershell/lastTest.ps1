﻿$maxConcurrentJobs = 3;
 
# Read the input and queue it up
$jobInput = @(1..10)
$queue = [System.Collections.Queue]::Synchronized( (New-Object System.Collections.Queue) )
foreach($item in $jobInput)
{
    $queue.Enqueue($item)
}
 
 
# Function that pops input off the queue and starts a job with it
function RunJobFromQueue
{
    if( $queue.Count -gt 0)
    {
        $j = Start-Job -ScriptBlock {param($x); Write-Output $x;} -ArgumentList $queue.Dequeue()
        Register-ObjectEvent -InputObject $j -EventName StateChanged -Action { 
            Write-Output "done"
            RunJobFromQueue; 
            Unregister-Event $eventsubscriber.SourceIdentifier; 
            Remove-Job $eventsubscriber.SourceIdentifier 
            return "done"
        } | Write-Host
    }
}
 
 
# Start up to the max number of concurrent jobs
# Each job will take care of running the rest
for( $i = 0; $i -lt $maxConcurrentJobs; $i++ )
{
    RunJobFromQueue
}