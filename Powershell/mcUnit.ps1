$ProjectDir = Resolve-Path "..\"

$TestDir = "$ProjectDir\McUnit.TestScenarios\bin\Debug"
$tests = (Get-ChildItem $TestDir -Recurse -Include *McUnit.TestScenarios.dll)

$nunitPath = "$ProjectDir\packages\NUnit.Runners.2.6.2\tools"
$nunitArgs = "$tests"


function Get-NunitExpression ($path,$arguments) {

    return "$path\nunit-console.exe $arguments";
}


$job = Start-Job -ScriptBlock { param($expression) Invoke-Expression "$expression"  } -ArgumentList (Get-NunitExpression $nunitPath $nunitArgs)
Wait-Job $job
Receive-Job -job $job
