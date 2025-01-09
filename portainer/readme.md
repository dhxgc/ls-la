# **1. Portainer. Установка.**

Порты по умолчанию:
- 8000: используется для связи с другими Portainer'ами, больше не вычитал.
- 9000: используется для доступа по http.
- 9443: используется для доступа по https.

Типовая установка с доступом только по https (Проброшен только 9443).
```bash
docker run -d \
    -p 8000:8000 \
    -p 9443:9443 \
    --name=portainer --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data \
    portainer/portainer-ce
```
