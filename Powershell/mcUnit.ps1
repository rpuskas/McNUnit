$ProjectDir = Resolve-Path "..\"
$TestDir = "$ProjectDir\McUnit.TestScenarios\bin\Debug"

$nunitPath = "$ProjectDir\packages\NUnit.Runners.2.6.2\tools"
$tests = (Get-ChildItem $TestDir -Recurse -Include *McUnit.TestScenarios.dll)
$nunitArguments = "$tests"


$job = Start-Job -ScriptBlock { param($expression) Invoke-Expression "$expression"  } -ArgumentList "$nunitPath\nunit-console.exe $nunitArguments"
Wait-Job $job
Receive-Job -job $job
