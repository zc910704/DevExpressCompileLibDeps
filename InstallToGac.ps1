function InstallToGacutil
{    
    if($args.Count -eq 0)
    {
        [string]$Path = Get-Location
    }
    else 
    {
        $Path = $args[0]    
    }
        $gac = Get-GacUtilsLocation
        $dlls = Get-ChildItem "$Path" -Recurse | ? { $_.extension -eq ".dll" }   
        for($i = 0;$i -lt $dlls.Length;$i++)
        {
            Write-Host("当前第{0}共{1}：{2}" -f $i, $dlls.Length, $dlls[$i].FullName)
            & $gac /i $dlls[$i].FullName 
         }
}


function Get-IsVersionX64
{
    #$os =  win32_operatingsystem | select osarchitecture
    $os = (Get-CimInstance -ClassName CIM_OperatingSystem).OSArchitecture
    return $os.Contains("64")
}

function Get-GacUtilsLocation
{
    $SearchPaths = "C:\Program Files (x86)\Microsoft SDKs\Windows", "C:\Program Files\Microsoft SDKs\Windows"
    if(Get-IsVersionX64)
    {
        return $SearchPaths[0] | SearchGacLocation;
    }
    else
    {
        return $SearchPaths[1] | SearchGacLocation;
    }
    
}

function SearchGacLocation
{
    Param
    (
        [parameter(Mandatory=$true, ValueFromPipeline=$true)]
        $searchFolder
    )
    process
    {
        Write-Host("search folder {0} for gacutil.exe" -f $searchFolder)
        $Dir = Get-ChildItem "$searchFolder" -Recurse
        $exes = $Dir | ? { $_.Name -eq "gacutil.exe" }
        if($exes.Length -gt 0)
        {
            Write-Host("found gacutil in path: {0}" -f $exes[0].FullName)
            return $exes[0].FullName
        }
    }
}

# InstallToGacutil D:\code
InstallToGacutil