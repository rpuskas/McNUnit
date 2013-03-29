$ProjectDir = Resolve-Path "..\"

$TestDir = "$ProjectDir\McUnit.TestScenarios\bin\Debug"
$testAssembly = [System.Reflection.Assembly]::LoadFrom((Get-ChildItem $TestDir -Recurse -Include *McUnit.TestScenarios.dll));

$nunitPath = "$ProjectDir\packages\NUnit.Runners.2.6.2\tools"
$nunitArgs = $testAssembly.Location

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

$fxs = Get-TestFixtures $testAssembly;
$exp = Get-NunitExpression $nunitPath $fxs
write-host $exp;


$job = Start-Job -ScriptBlock { param($expression) Invoke-Expression "$expression"  } -ArgumentList $exp
Wait-Job $job
Receive-Job -job $job
