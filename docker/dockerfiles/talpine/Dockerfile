FROM alpine as talpine

RUN apk update && apk add \ 
    bash bash-completion nano \ 
    curl nmap wget util-linux

ENTRYPOINT [ "/bin/bash" ]