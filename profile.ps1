#region Custom prompt config
<#
# Install modules
Install-Module -Name posh-git, PSReadLine -Verbose
Get-Module -Name posh-git, PSReadLine -ListAvailable

# Download "Caskaydia Cove Nerd Font" from:
- https://www.nerdfonts.com/font-downloads
- https://github.com/microsoft/cascadia-code/releases

# Change font settings in VSCode (only for terminal, as rendering issues for backticks)
"editor.fontFamily": "'Cascadia Code PL', 'Consolas', 'Courier New', monospace",
"editor.fontLigatures": false,
"terminal.integrated.fontFamily": "'CaskaydiaCove NF', 'Cascadia Code PL', 'Courier New', monospace"

Blog post:
https://www.hanselman.com/blog/taking-your-powershell-prompt-to-the-next-level-with-windows-terminal-and-oh-my-posh-3
# https://ohmyposh.dev/docs/upgrading/
#>

# add local bin to path
$env:PATH = "~/.local/bin:$env:PATH"

# show prompt
oh-my-posh init pwsh --config ~/.go-my-posh.json | Invoke-Expression
#endregion Custom prompt config


#region PSReadLine
<#
https://www.hanselman.com/blog/you-should-be-customizing-your-powershell-prompt-with-psreadline
https://github.com/PowerShell/PSReadLine/blob/master/PSReadLine/SamplePSReadLineProfile.ps1#L13-L21

# Show current settings
Get-PSReadLineOption
Get-PSReadLineKeyHandler
#>

# Enable history suggestions
Set-PSReadLineOption -PredictionSource History

# Clear history
# Get-PSReadlineOption | Select-Object -ExpandProperty HistorySavePath | Remove-Item -WhatIf

# Searching for commands with up/down arrow is really handy.  The
# option "moves to end" is useful if you want the cursor at the end
# of the line while cycling through history like it does w/o searching,
# without that option, the cursor will remain at the position it was
# when you used up arrow, which can be useful if you forget the exact
# string you started the search on.
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# add nicer tab completion
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
#endregion PSReadLine


# Source: https://gist.github.com/GABeech/98df2f95fb3a79cd2ccaa80a439aa975
function Clear-DeletedBranches {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    [Alias("cdb")]
    param(
        [Parameter(Mandatory = $false)]
        [string]
        $GitDir = $PWD
    )

    $defaultBranch = ((git symbolic-ref --short refs/remotes/origin/HEAD) -split "/")[1]
    Write-Host "Switching to branch [$defaultBranch]..." -ForegroundColor Yellow
    git checkout $defaultBranch

    $branchesBefore = git branch -a

    $branchesToPrune = git remote prune origin --dry-run
    if ($branchesToPrune) {
        Write-Host "Branches to Be Pruned..." -ForegroundColor Green
        Write-Host $branchesToPrune -ForegroundColor Red

        if ($PSCmdlet.ShouldProcess("Remove Local Branches?")) {
            git remote prune origin
            $branchesAfter = git branch -a
            $removed = Compare-Object -ReferenceObject $branchesBefore -DifferenceObject $branchesAfter
            foreach ($b in $removed.InputObject) {
                $localName = $b.Split('/')[-1]
                git branch -D $localName
            }
        }
    } else {
        Write-Host "Nothing To prune" -ForegroundColor Green
    }

    Write-Host "`nPulling changes from default branch..." -ForegroundColor Green
    git pull

    Write-Host "`nCurrent branches..." -ForegroundColor Green
    git branch -a
}

# Git log functions
function Get-GitLogCurrentBranch {
    [CmdletBinding()]
    [Alias("glc")]

    $currentBranch = git rev-parse --abbrev-ref HEAD
    $output = git log --pretty=format:"- %s" master..$currentBranch
    $output | Out-String | Set-Clipboard
    $output
    Write-Host "Commit messages copied to clipboard" -ForegroundColor Green
}

function Get-GitLogPretty {
    [CmdletBinding()]
    [Alias("gll")]

    $gitCommand = "git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
    Invoke-Expression $gitCommand
}

function Get-GitLogFormattedCurrentBranch {
    [CmdletBinding()]
    [Alias("glr")]

    $currentBranch = git rev-parse --abbrev-ref HEAD
    $output = git log --pretty=format:"- %s" master..$currentBranch

    # Apply regex replacements (equivalent to the sed commands)
    $formattedOutput = $output | ForEach-Object {
        $line = $_
        # Replace version numbers with backtick-wrapped version numbers
        $line = [regex]::Replace($line, '([0-9]+\.[0-9]+\.[0-9]+)', '`$1`')

        # Convert verbs to past tense
        $line = [regex]::Replace($line, '\badd\b', 'added', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        $line = [regex]::Replace($line, '\bupdate\b', 'updated', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        $line = [regex]::Replace($line, '\bbump\b', 'bumped', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        $line = [regex]::Replace($line, '\bchange\b', 'changed', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        $line = [regex]::Replace($line, '\bdelete\b', 'deleted', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        $line = [regex]::Replace($line, '\bfix\b', 'fixed', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

        $line
    }

    # Output to console and copy to clipboard
    $formattedOutput | Out-String | Set-Clipboard
    $formattedOutput
    Write-Host "Formatted commit messages copied to clipboard" -ForegroundColor Green
}

# Aliases
Set-Alias -Name g -Value git
Set-Alias -Name k -Value kubectl
Set-Alias -Name l -Value gci
Set-Alias -Name tf -Value terraform
