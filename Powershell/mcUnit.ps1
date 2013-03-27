
$ProjectDir = "..\" 
$PackagesDir = "..\packages"
$TestDir = "..\McUnit.TestScenarios\bin\Debug"

$nunitPath = resolve-path "..\packages\NUnit.Runners.2.6.2\tools"
$nunitArguments = "/noshadow /framework:net-4.0"
$tests = (Get-ChildItem $TestDir -Recurse -Include *McUnit.TestScenarios.dll)
$job = Start-Job { param($path,$args) & "$path\nunit-console.exe $args" } -ArgumentList $nunitPath, $nunitArguments

Wait-Job $job
Receive-Job -job $job
