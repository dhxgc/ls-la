FROM debian
# Image for SSH connections

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN apt update && apt install shellinabox ssh -y

ENTRYPOINT [ "./entrypoint.sh" ]