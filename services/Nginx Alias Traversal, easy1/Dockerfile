FROM nginx:alpine

COPY ./src/app/ /app/
COPY /src/app/img/ /app/img/
COPY ./src/default.conf /etc/nginx/conf.d/default.conf

RUN echo "flag{awd}" > /app/flag.txt