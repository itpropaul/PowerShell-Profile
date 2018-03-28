##############################################################
## Module Path = C:\Program Files\WindowsPowerShell\Modules ##
##############################################################


# Looks up the command name for an alias like Get-Alias, but also returns other aliases associated with the discovered command.
function Get-AllAliases ($Name){
Get-Alias $name |
    ForEach-Object {
        Get-Alias -Definition $_.Definition
    }
}

# Human Readable File Sizes Function - from https://gist.github.com/LambdaSix/cc689cb34212b1d9a252
Function Format-FileSize() {
    Param ([long]$size)
    If     ($size -gt 1TB) {[string]::Format("{0:0.00} TB", $size / 1TB)}
    ElseIf ($size -gt 1GB) {[string]::Format("{0:0.00} GB", $size / 1GB)}
    ElseIf ($size -gt 1MB) {[string]::Format("{0:0.00} MB", $size / 1MB)}
    ElseIf ($size -gt 1KB) {[string]::Format("{0:0.00} kB", $size / 1KB)}
    ElseIf ($size -gt 0)   {[string]::Format("{0:0.00} B", $size)}
    Else                   {""}
}

# Utilizes the Format-FileSize function
Function Get-FileSize ($File){
ls $File | Select Name, @{Name="Size";Expression={Format-FileSize($_.Length)}}
}


# from: http://community.idera.com/powershell/powertips/b/tips/posts/pipe-information-to-excel
# This function pipes to Excel and instantly opens in Excel. It puts the csv in temp, so that you don't need to clean up after.
function Out-Excel 
{

  param(
    $path = "$env:temp\report$(Get-Date -Format yyyyMMddHHmmss).csv"
  )
  
  $Input | 
    Export-Csv $path -NoTypeInformation -UseCulture -Encoding UTF8
    Invoke-Item $path 
}

# The previous code here to make commandline history persistent is no longer needed. See these two articles for how / where Powershell
# saves the commandline history and how to access it.
# https://blogs.technet.microsoft.com/heyscriptingguy/2014/06/18/better-powershell-history-management-with-psreadline/
# https://www.jaapbrasser.com/quicktip-powershell-command-history-on-windows-10-using-psreadline/
# Chocolatey profile

# Installed by Chocolatey install script
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
