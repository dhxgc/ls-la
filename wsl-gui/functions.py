from system_functions import *

import tkinter as tk
from tkinter import ttk
from tkinter import messagebox


# Interfaces functions
def topbarCreate(root):
    topbar = tk.Menu()
    root.config(menu=topbar)

    topbarActions = tk.Menu(topbar, tearoff=False)
    topbarActions.add_command(
        label="Добавить",
        command=lambda: guiAddMachine(rootWindow=root)
    )
    topbarActions.add_command(
        label="Склонировать",
        command=lambda: guiCopyMachine(root=root)
    )
    topbarActions.add_command(
        label="Удалить",
        command=lambda: guiUnregisterMachine(root=root)
    )
    topbar.add_cascade(menu=topbarActions, label="Actions")

def sidebarDelete (root):
    if hasattr(root, 'sidebarFrame'):
        root.sidebarFrame.destroy()

def sidebarCreate(root):
    root.sidebarFrame = tk.Frame(root)
    root.sidebarFrame.grid(row=0, column=0, rowspan=len(listMachine()))
    for row, distroName in zip(range(0, len(listMachine())), listMachine()):
        tk.Button(
            root.sidebarFrame,
            text=f"{distroName}",
            width=14,
            height=1
        ).grid(row=row, column=0, padx=5, pady=5)

# Кнопки для топбара
def guiAddMachine(rootWindow):
    subRoot = tk.Toplevel(rootWindow)
    subRoot.title("Добавить машину")
    subRoot.grab_set()
    subRoot.focus_force()

    # Кнопки для выбора типа оригинального темплейта
    vhdSign = tk.StringVar()
    vhdSignButtonTar = ttk.Radiobutton(
        subRoot,
        text="Machine store in .tar archive",
        value="tar",
        variable=vhdSign
    )
    vhdSignButtonVHDX = ttk.Radiobutton(
        subRoot,
        text="Machine store in .vhdx file",
        value="vhdx",
        variable=vhdSign
    )
    vhdSignButtonTar.pack(fill='x', padx=5, pady=5)
    vhdSignButtonVHDX.pack(fill='x', padx=5, pady=5)

    button_frame = ttk.Frame(subRoot)
    button_frame.pack(padx=10, pady=10, fill=tk.X)
    
    okButton = ttk.Button(button_frame, text="OK", command=lambda: print("OK"))
    okButton.pack(side=tk.LEFT, padx=5)
    cancelButton = ttk.Button(button_frame, text="Отмена", command=subRoot.destroy)
    cancelButton.pack(side=tk.LEFT, padx=5)
    
def guiCopyMachine(root):
    subRoot = tk.Toplevel(root)
    subRoot.title("Скопировать машину")
    subRoot.grab_set()
    subRoot.focus_force()
    
# Имя дистрибутива
    labelNameDistro = ttk.Label(
        subRoot,
        text="Введите имя нового дистрибутива:"
    )
    subRoot.nameOfNewDistro = tk.StringVar()
    subRoot.entryNameOfNewDistro = ttk.Entry(
        subRoot,
        textvariable=subRoot.nameOfNewDistro
    )
    labelNameDistro.pack(fill='x', padx=5, pady=5)
    subRoot.entryNameOfNewDistro.pack(fill='x', padx=5, pady=5)

# Выпадающий список всех машин
    labelChoiceMachine = ttk.Label(
        subRoot,
        text="Выберите машину для копирования:"
    )
    subRoot.cmbChoiceMachine = tk.StringVar(value=listMachine()[0])
    subRoot.cmbListMachine = ttk.Combobox(
        subRoot,
        values=listMachine(),
        textvariable=subRoot.cmbChoiceMachine,
        state="readonly"
    )
    labelChoiceMachine.pack(padx=10, pady=10, fill=tk.X)
    subRoot.cmbListMachine.pack(padx=10, pady=10, fill=tk.X)

# Путь к новой машине
    def updateEntry(*args):
    # После начала изменения поля имени получаем его содержимое и вставляем в переменную для поля пути
        temp = subRoot.nameOfNewDistro.get()
        subRoot.pathOfNewDistro.set(value=f'C:\\Users\\admin\\WSL\\{temp}')
    # Отслеживание изменений в поле имени машины
    # При измененении вызывается updateEntry()
    subRoot.nameOfNewDistro.trace_add("write", updateEntry)

    labelDistroPath = ttk.Label(
        subRoot,
        text="Введите путь для хранения новой машины:"
    )
    subRoot.pathOfNewDistro = tk.StringVar(subRoot, value='C:\\Users\\admin\\WSL\\')
    subRoot.entryPathOfNewDistro = ttk.Entry(
        subRoot,
        textvariable=subRoot.pathOfNewDistro
    )
    labelDistroPath.pack(fill='x', padx=5, pady=5)
    subRoot.entryPathOfNewDistro.pack(fill='x', padx=5, pady=5)

# Фрейм с кнопками ОК и Отмена
    def onOk():
        if copyMachine(
            subRoot.nameOfNewDistro.get(),
            subRoot.cmbChoiceMachine.get(),
            subRoot.pathOfNewDistro.get()
        ):
        # Обновление списка ВМ главного окна
            sidebarDelete(root=root)
            sidebarCreate(root=root)
            messagebox.showinfo("Успешно", f"Дистрибутив {subRoot.nameOfNewDistro.get()} добавлен.")
            subRoot.destroy()
        else:
            messagebox.showerror("Ошибка", f"Во время копирования дистрибутива {subRoot.nameOfNewDistro.get()} произошла ошибка")
            subRoot.destroy()

    button_frame = ttk.Frame(subRoot)
    button_frame.pack(padx=10, pady=10, fill=tk.X)
    
    okButton = ttk.Button(button_frame, text="OK", command=onOk)
    okButton.pack(side=tk.LEFT, padx=5)
    cancelButton = ttk.Button(button_frame, text="Отмена", command=subRoot.destroy)
    cancelButton.pack(side=tk.LEFT, padx=5)

def guiUnregisterMachine(root):
    subRoot = tk.Toplevel(root)
    subRoot.title("Delete machine")
    subRoot.grab_set()
    subRoot.focus_force()

    mainInfoLabel = ttk.Label(subRoot, text="Выберите дистрибутив для удаления:")
    mainInfoLabel.pack(padx=10, pady=0, side=tk.TOP, fill=tk.X)

    machineValues = tuple(listMachine())
    listvariableMachines = tk.Variable(value=machineValues)
    listboxMachines = tk.Listbox(subRoot, listvariable=listvariableMachines, height=10)
    listboxMachines.pack(padx=10, pady=10, expand=True, fill=tk.BOTH, side=tk.LEFT)

    def onOk():
        # Получаем выбранный элемент
        selection = listboxMachines.curselection()
        if selection:
            selectedMachine = listboxMachines.get(selection[0])
            if unregisterMachine(selectedMachine):
            # Обновление списка ВМ главного окна
                sidebarDelete(root=root)
                sidebarCreate(root=root)
                messagebox.showinfo("Успешно", f"Дистрибутив {selectedMachine} удален.")
                subRoot.destroy()
            else:
                messagebox.showerror("Ошибка", f"Во время удаления дистрибутива {selectedMachine} произошла ошибка")
        else:
            messagebox.showwarning("Предупреждение", "Выберите дистрибутив для удаления")

    button_frame = ttk.Frame(subRoot)
    button_frame.pack(padx=10, pady=10, fill=tk.X)

    okButton = ttk.Button(button_frame, text="OK", command=onOk)
    okButton.pack(side=tk.RIGHT, padx=5)
    
    cancelButton = ttk.Button(button_frame, text="Отмена", command=subRoot.destroy)
    cancelButton.pack(side=tk.RIGHT, padx=5)

    return 0