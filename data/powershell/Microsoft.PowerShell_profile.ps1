## powershell profile
## michael@mwild.me

new-alias open start
new-alias grep Select-String
new-alias gch Get-ChildItem
new-alias touch New-Item
function ll ($params)  { ls -Force $params }
function reset-color { [Console]::ResetColor() }

new-alias npp "C:\Program Files (x86)\Notepad++\notepad++.exe"
new-alias vi npp

new-alias ps-admin "d:\michael.wildman\tools\powershell-michaelw-admin.lnk"

# fake linux 'which'
function which ($com) { (Get-Command -All $com).Definition }

# fake tail -f
function tail ([switch]$f,$file) {  if ($f) { Get-Content $file -Tail 10 -Wait } else { Get-Content $file -Tail 10 } }

# ssh
new-alias putty "C:\Program Files (x86)\PuTTY\putty.exe"
new-alias ssh putty
new-alias plink "C:\Program Files (x86)\PuTTY\plink.exe"
new-alias pageant "C:\Program Files (x86)\PuTTY\pageant.exe"
function ssh-agent { pageant "g:\system\keys\id_rsa.ppk" }
new-alias winscp "C:\Program Files (x86)\WinSCP\winscp.exe"
new-alias openssl "c:\program files\openssl\bin\openssl.exe"

new-alias dig "C:\Program Files\ISC BIND 9\bin\dig.exe"

new-alias splunk "C:\Program Files\SplunkUniversalForwarder\bin\Splunk.exe"

new-alias chrome "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
function google { chrome "https://www.google.co.nz/search?q=$args" }

# build
new-alias nuget "d:\michael.wildman\tfs\Sourcecode-Dev\BuildProcessTemplates\Scripts\nuget.exe"
new-alias tf "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\TF.exe"
new-alias tfpt "C:\Program Files (x86)\Microsoft Team Foundation Server 2015 Power Tools\TFPT.exe"
new-alias msbuild-v140 "C:\Program Files (x86)\MSBuild\14.0\Bin\MSBuild.exe"
new-alias msbuild msbuild-v140

# git
function git-log { git log --pretty=oneline --decorate --graph --abbrev-commit $args }

# python
new-alias py "C:\Windows\py.exe"
new-alias python "~\AppData\Local\Programs\Python\Python35-32\python.exe"
new-alias pip "~\AppData\Local\Programs\Python\Python35-32\Scripts\pip.exe"

# media
new-alias youtube-dl "C:\Program Files (x86)\youtube-dl\youtube-dl.exe"
new-alias ffmpeg "C:\Program Files\ffmpeg\bin\ffmpeg.exe"
new-alias ffprobe "C:\Program Files\ffmpeg\bin\ffprobe.exe"
new-alias ffplay "C:\Program Files\ffmpeg\bin\ffplay.exe"




# test if the current shell is elevated
function test-isadmin {
	return ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}

# custom prompt
function prompt {
	$isAdmin = test-isadmin
	$cd = (pwd)

	if ((h).length -gt 0) {
		add-content -path "~/.logs/shell-history-$(get-date -f 'yyyy-MM').log" `
			-value "$((h)[-1].StartExecutionTime.toString('yyyy-MM-dd.HH:mm:ss')) [$global:promptPrevDir] $((h)[-1].commandLine)"
	}

	$global:promptPrevDir = $cd

	if ($isAdmin) {
		$host.UI.RawUI.WindowTitle = "Admin: $cd"
		write-host "[$(split-path $cd -leaf)]" -noNewLine
		write-host "#" -noNewLine -foregroundColor red
	} else {
		$host.UI.RawUI.WindowTitle = "$cd"
		write-host "[$(split-path $cd -leaf)]$" -noNewLine
	}
	return " "
}

# set initial "previous" directory
$global:promptPrevDir = (pwd)


# set a new "home" directory
# Set and force overwrite of the $HOME variable
Set-Variable HOME "g:\" -Force

# Set the "~" shortcut value for the provider
(get-psprovider 'FileSystem').Home = "g:\"
