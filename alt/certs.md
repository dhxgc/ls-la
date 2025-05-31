# Сертификат в доверенные на Altе
> Источник: https://www.altlinux.org/%D0%A3%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0_%D0%BA%D0%BE%D1%80%D0%BD%D0%B5%D0%B2%D0%BE%D0%B3%D0%BE_%D1%81%D0%B5%D1%80%D1%82%D0%B8%D1%84%D0%B8%D0%BA%D0%B0%D1%82%D0%B0

#### 1. Серт в хранилище:
> На примере `step-ca`
```bash
cp ~/.step/certs/root_ca.crt /etc/pki/ca-trust/source/anchors/
```

#### 2. Обновить серты:
```bash
update-ca-trust
```