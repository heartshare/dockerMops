#!/bin/sh
PHPATH=/usr/local/php/etc
mkdir $PHPATH -p
curl -Lk  https://raw.githubusercontent.com/marksugar/dockerMops/master/docker-php/alpine-php-7.3.4-gosu/php-fpm.conf -o $PHPATH/php-fpm.conf
curl -Lk  https://raw.githubusercontent.com/marksugar/dockerMops/master/docker-php/alpine-php-5.6.40/php.ini -o $PHPATH/php.ini
curl -Lk  https://raw.githubusercontent.com/marksugar/dockerMops/master/docker-php/alpine-php-7.3.4-gosu/docker-compose.yml -o $PWD/docker-compose.yml
docker-compose -f $PWD/docker-compose.yml up -d