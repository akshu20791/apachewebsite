FROM httpd
RUN apt update
RUN apt install git -y
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /usr/local/apache2/htdocs/*
RUN git clone https://github.com/akshu20791/apachewebsite/ /usr/local/apache2/htdocs/
EXPOSE 80
CMD ["httpd-foreground"]
