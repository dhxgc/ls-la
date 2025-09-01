# Functions for WSL operations
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

def listMachine():
    rawListMachine = subprocess.run(["wsl.exe", "--list"], capture_output=True, text=True, encoding="utf-16le")
    cleanListMachine = []
    for rawLine in rawListMachine.stdout.split('\n'):
        cleanLine = rawLine.split(' ')[0]
        cleanListMachine.append(cleanLine)
    
    # Удаление левых строк
    cleanListMachine.pop(-1)
    cleanListMachine.pop(0)

    return cleanListMachine

def addMachineFromFile(distrName: str, destinationPath: str, originalPath: str, vhdSign: str):
    if vhdSign == "tar":
        subprocess.run(["wsl.exe", "--import", distrName, destinationPath, originalPath], 
                                capture_output=True, 
                                text=True,
                                encoding='utf-16le')
    else:
        subprocess.run(["wsl.exe", "--import", distrName, destinationPath, originalPath, "--vhd"], 
                                capture_output=True, 
                                text=True,
                                encoding='utf-16le')
    return 1
    
def unregisterMachine (distrName: str):
    subprocess.run(["wsl.exe", "--unregister", distrName], 
                        capture_output=True, 
                        text=True,
                        encoding='utf-16le')
    return 1

def copyMachine (newDistroName: str, templateDistrName: str, pathOfNewDistro: str):
    subprocess.run(
        ["wsl.exe",
         "--import",
         f"{newDistroName}",
         f"{pathOfNewDistro}",
         f"{getMachinePath(templateDistrName)}\\ext4.vhdx",
         "--vhd"],
        capture_output=True, 
        text=True, 
        encoding="utf-16le"
    )
    return 1
# Получение пути оригинальной машины
