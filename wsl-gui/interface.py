from functions import *

# Constants
defaultMachinesPath = "C:\\Users\\admin\WSL\\"

# CLI Interface
def cliMain():
    menuChoice = -1
    while menuChoice != 0:
        menuChoice=int(input("1 - List\n2 - Copy\n3 - Delete\n0 - Exit\n> "))
        match menuChoice:
            case 1:
                listMachine()
            case 2:
                nameOfNewDistro = input("Name of virtual machine: ")
                pathFileForImport = input("Path of template: ")
                destinationPathForMachine = defaultMachinesPath + nameOfNewDistro
                vhd=bool(int(input("> .tar = 0\n> .vhdx = 1\n> ")))
                copyMachine(nameOfNewDistro, destinationPathForMachine, originalPath=pathFileForImport, vhd=vhd)
            case 3:
                nameOfNewDistro = input("Name of virtual machine: ")
                unregisterMachine(nameOfNewDistro)
            case 0:
                print("exit")
                break
            case _:
                print("Unknown choice.")

def guiMain():
    root = tk.Tk()
    root.title("GUI WSL")
    root.geometry("1000x600")
    root.tk.call('tk', 'scaling', 2.2)
    root.eval('tk::PlaceWindow . center')

    topbarCreate(root=root)
    sidebarCreate(root=root)

    root.mainloop()