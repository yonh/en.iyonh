FROM alpine:3.5
MAINTAINER Yonh Lai <azssjli@163.com>
LABEL Description="A Simple apache/php image using alpine Linux for Web Apps"

#replace default sources.list
ADD sources.list /etc/apk/repositories


# Setup apache and php
RUN apk --update add apache2 php7-apache2 curl \
	php7-pdo_mysql php7-mysqli php7-curl php7-dom php7-xml php7-json php7-ctype php7-mbstring php7-session php7-iconv php7 php7-phar \
    && rm -f /var/cache/apk/* \
    && mkdir /run/apache2 \
    && sed -i 's/#LoadModule\ rewrite_module/LoadModule\ rewrite_module/' /etc/apache2/httpd.conf \
    && mkdir -p /opt/utils
    
ADD start.sh /opt/utils/
RUN chmod +x /opt/utils/start.sh

ADD composer /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer

#RUN deluser apache && addgroup apache && adduser -S apache -G apache -u 1000

COPY app /app

WORKDIR /app
RUN composer install --no-dev && composer dumpautoload

EXPOSE 80

ENV WEBAPP_ROOT public


ENTRYPOINT ["/opt/utils/start.sh"]
