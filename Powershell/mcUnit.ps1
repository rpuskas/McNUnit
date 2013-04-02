function Get-NunitExpression ($path,$fixtures) {

    return "$path\nunit-console.exe $fixtures";
}

function Get-TestFixtures {
    param([System.Reflection.Assembly]$assembly)

    $fixtures = @()

    foreach ($type in $assembly.GetTypes())
    {
        $customAttributes = [System.Attribute]::GetCustomAttributes($type)

        foreach ($attribute in $customAttributes) 
        {
            if($attribute.TypeId.ToString() -eq "NUnit.Framework.TestFixtureAttribute")
            {
                $fixtures += "/fixture:$type "+$assembly.Location;
            }
        }
    }

    return $fixtures;      
}

function Run-Program
{
    $ProjectDir = Resolve-Path "..\"

    $TestDir = "$ProjectDir\McUnit.TestScenarios\bin\Debug"
    $testAssembly = [System.Reflection.Assembly]::LoadFrom((Get-ChildItem $TestDir -Recurse -Include *McUnit.TestScenarios.dll));

    $nunitPath = "$ProjectDir\packages\NUnit.Runners.2.6.2\tools"
    $nunitArgs = $testAssembly.Location

    $fxs = Get-TestFixtures $testAssembly;
    write-host $exp;


    $jobs = @()
    foreach($fixture in $fxs)
    {
        $exp = Get-NunitExpression $nunitPath $fixture
        $jobs += Start-Job -ScriptBlock { param($expression) Invoke-Expression "$expression"  } -ArgumentList $exp    
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

