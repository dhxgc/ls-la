import subprocess

def getMachinePath (distrName):
    result = subprocess.run(
        ["powershell.exe", 
         "-Command", 
         "Get-ChildItem 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Lxss' -Recurse |", 
         "ForEach-Object {Get-ItemProperty $_.PsPath | Select-Object DistributionName, BasePath}"],
        capture_output=True,
        text=True
    )
    raw_result = result.stdout.splitlines()
    for lines in raw_result:
        if distrName+" " in lines:
            lines = lines.replace(distrName, "", 1)
            lines = lines.strip()
            if "\\\?\\" in lines:
                lines = lines.replace("\\\?\\", "")
            return lines



print(
    # getMachinePath("AlpineLinux"),
    # getMachinePath("WSL-Tested"),
    getMachinePath("Debian"),
    # getMachinePath("Debian_2"),
    getMachinePath("Distrobox")
)
