$path = $args[1] # "HKCU:Software\Microsoft\Windows\CurrentVersion"
$user = $args[2] #"BUILTIN\Администраторы"
$flag = $args[3] #0

switch($flag){
0 { Get-ChildItem -Path $path -Recurse | Where-Object{ 
      (Get-Acl $_.PSPath).Access | Where-Object {
            $_.IdentityReference -eq $user`
            -and ($_.RegistryRights -band [Security.AccessControl.RegistryRights]::WriteKey)
            }
     }

}
1 { Get-ChildItem -Path $path -Recurse | Where-Object { (Get-Acl $_.PSPath).Access | Where-Object {
        $_.IdentityReference -eq $user`
        -and -not (($_.RegistryRights -band [Security.AccessControl.RegistryRights]::WriteKey))
        }
    }
}
default { " "}

}

# HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run "NT AUTHORITY\СИСТЕМА" 0
# cd C:\Users\maks\Desktop\\oshw
# C:\Users\maks\Desktop\oshw\2.ps1 HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run "NT AUTHORITY\СИСТЕМА" 0

