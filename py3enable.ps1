$python2Path = 'C:\Python27'
$python3Path = 'C:\Program Files (x86)\Python36-32'



# param([switch]$Elevated)

function Test-Admin {
  $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
  $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
    if ($elevated) 
    {
        # tried to elevate, did not work, aborting
    } 
    else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
}

exit
}

'running with full privileges'




# Get it
$path = [System.Environment]::GetEnvironmentVariable(
    'PATH',
    'Machine'
)
# Remove unwanted elements
$path = ($path.Split(';') | Where-Object { $_ -ne $python3Path }) -join ';'
$path = ($path.Split(';') | Where-Object { $_ -ne ($python3Path+'\Scripts') }) -join ';'
$path = ($path.Split(';') | Where-Object { $_ -ne $python2Path }) -join ';'
$path = ($path.Split(';') | Where-Object { $_ -ne ($python2Path+'\Scripts') }) -join ';'
$path += ";"+$python3Path
$path += ";"+$python3Path+'\Scripts'
# Set it
[System.Environment]::SetEnvironmentVariable(
    'PATH',
    $path,
    'Machine'
)

'python 3 enabled'