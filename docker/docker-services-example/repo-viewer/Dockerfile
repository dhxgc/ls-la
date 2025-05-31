FROM python:3.11-slim

# Устанавливаем markdown и git
RUN apt-get update && apt-get install -y git && pip install markdown

WORKDIR /app
COPY simple_server.py /app/simple_server.py
COPY init.sh /app/init.sh
RUN chmod +x /app/init.sh

EXPOSE 8000

CMD ["/app/init.sh"]
