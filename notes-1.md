### Синхронизация двух Entry виджетов

___Кратко___:
 - с помощью `.trace_add()` можно отслеживать, че происходит с объектом, у которого был вызван данный метод
 - пишем имя объекта, пишем че у него отслеживаем (здесь запись в переменную), пишем че вызываем если если был детект
 - в самой функции уже просто берем значение из `varEntry1` и кладем его в `varEntry2`

```python3
import tkinter as tk
import tkinter.ttk as ttk

root = tk.Tk()

# Первое поле
varEntry1 = tk.StringVar()
Entry1 = ttk.Entry(
    root,
    textvariable=varEntry1
)

# Второе поле
varEntry2 = tk.StringVar()
Entry2 = ttk.Entry(
    root,
    textvariable=varEntry2
)

# Функция, которая берет значение из Entry1 и кладет в Entry2
def updateEntry2(*args):
    varEntry2.set(value=f'{varEntry1.get()}')

# Вызов функции updateEntry2 при каждом изменении переменной varEntry1
varEntry1.trace_add("write", updateEntry2)

Entry1.pack()
Entry2.pack()

root.mainloop()
```
