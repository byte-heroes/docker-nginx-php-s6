FROM php:7.1.11-fpm

MAINTAINER Thomas Strohmeier


RUN apt-get update && apt-get install -y libmcrypt-dev unzip python cron supervisor \
    mysql-client libmagickwand-dev --no-install-recommends \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && docker-php-ext-install mcrypt pdo_mysql \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && cd /tmp && curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" \
    && unzip awscli-bundle.zip && ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws \
    && rm awscli-bundle.zip && rm -rf awscli-bundle
