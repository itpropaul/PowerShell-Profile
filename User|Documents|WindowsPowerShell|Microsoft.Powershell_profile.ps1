##############################################################
## Module Path = C:\Program Files\WindowsPowerShell\Modules ##
##############################################################

# A couple functions for frequently used git commands that don't require parameters
function gitp {git push}
function gits {git status}

# Use Bash Vim from powershell
# Make sure to use this formatting: vi /mnt/c/Users/pmasek/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1 
function vi ($File){
bash -c "vi $File"
}

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

# The previous code here to make commandline history persistent is no longer needed. See these two articles for how / where Powershell
# saves the commandline history and how to access it.
# https://blogs.technet.microsoft.com/heyscriptingguy/2014/06/18/better-powershell-history-management-with-psreadline/
# https://www.jaapbrasser.com/quicktip-powershell-command-history-on-windows-10-using-psreadline/

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# The following two commands are based on https://github.com/alexanderepstein/Bash-Snippets that I
# have installed on Bash on Windows (via the "Git Install" method - will be able to update via "Git Update").

# Show the weather for 46807 upon PowerShell load
bash -c "weather 46807"

# Show the available Bash-Snippets Utilities
bash -c "echo 'Bash-Snippets Utilities (To run from PowerShell: bash -c comand):';cat /mnt/c/Users/pmasek/Bash-Snippets/README.md |grep -m 19 '^<summary>' |cut -f2 -d'>' |cut -f1 -d'<' |tr -d '\n';echo"

# from: http://community.idera.com/powershell/powertips/b/tips/posts/find-installed-software
function Get-InstalledSoftware
{
    param
    (
        $DisplayName='*',

        $DisplayVersion='*',

        $UninstallString='*',

        $InstallDate='*'

    )
    
    # registry locations where installed software is logged
    $pathAllUser = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
    $pathCurrentUser = "Registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
    $pathAllUser32 = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
    $pathCurrentUser32 = "Registry::HKEY_CURRENT_USER\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"

   
    # get all values
    Get-ItemProperty -Path $pathAllUser, $pathCurrentUser, $pathAllUser32, $pathCurrentUser32 |
      # choose the values to use
      Select-Object -Property DisplayVersion, DisplayName, UninstallString, InstallDate |
      # skip all values w/o displayname
      Where-Object DisplayName -ne $null |
      # apply user filters submitted via parameter:
      Where-Object DisplayName -like $DisplayName |
      Where-Object DisplayVersion -like $DisplayVersion |
      Where-Object UninstallString -like $UninstallString |
      Where-Object InstallDate -like $InstallDate |

      # sort by displayname
      Sort-Object -Property DisplayName 
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
