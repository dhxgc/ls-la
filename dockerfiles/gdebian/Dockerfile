FROM debian as gdebian
# Образ для тестов работоспособности всякого

ENV TEST1='ippp'

RUN apt update \ 
    && apt install -y \ 
    curl nmap iproute2 \
    iputils-ping bind9-utils

ENTRYPOINT [ "/bin/bash"]