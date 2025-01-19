FROM httpd:latest AS origin

EXPOSE 80
RUN echo "<h1>Hello World!</h1>" > /usr/local/apache2/htdocs/index.html
VOLUME [ "/usr/local/apache2/htdocs/" ]