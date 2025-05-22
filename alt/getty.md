# Разрешить работу по консольному порту в Alt'е
> Источник: https://www.altlinux.org/SerialLogin#%D0%9D%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B9%D0%BA%D0%B0_getty

Включить:
```bash
systemctl --now enable getty@ttyS0
```

Разрешить логиниться под рутом:
```bash
echo ttyS0 >> /dev/securetty
echo ttyS1 >> /dev/securetty
```