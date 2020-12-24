$path = $args[0] # "HKCU:Software\Microsoft\Windows\CurrentVersion"
$user = $args[1]

Get-ChildItem -Path $path -Recurse |
    Where-Object { (Get-Acl $_.FullName).Access | Foreach-Object{$_.IdentityReference -eq $user `
        -and $_.FileSystemRights -band [Security.AccessControl.FileSystemRights]::Read `
        -and -not $_.IsInherited `
        -and -bnot $_.FileSystemRights -band [Security.AccessControl.FileSystemRights]::Write `
    }
}
#$path = "C:\"
#$user = "BUILTIN\Администраторы"