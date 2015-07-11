#
# PHP-FPM Dockerfile
#
# https://github.com/yangqi/docker-php-fpm
#

# Pull base image.
FROM yangqi/docker-debian
MAINTAINER Qi Yang <i@yangqi.me>

ENV DEBIAN_FRONTEND noninteractive

# Install PHP and PHP-FPM.
RUN \
  apt-get update && \
  apt-get install -y wget php5 php5-fpm && \
  echo "deb http://nginx.org/packages/debian/ jessie nginx" >> /etc/apt/sources.list.d/nginx.list && \
  echo "deb-src http://nginx.org/packages/debian/ jessie nginx" >> /etc/apt/sources.list.d/nginx.list && \
  wget -q http://nginx.org/keys/nginx_signing.key && \
  apt-key add nginx_signing.key && \
  apt-get update && \
  apt-get install -y nginx && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  mkdir /var/log/php-fpm

WORKDIR /root
ADD nginx.conf /etc/nginx/nginx.conf
ADD php-fpm.conf /etc/php5/fpm/php-fpm.conf
ADD www.conf /etc/php5/fpm/pool.d/www.conf
ADD start.sh /root/start.sh

VOLUME ["/var/log/php-fpm", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www"]

# Define default command.
CMD ["/root/start.sh"]

EXPOSE 80
EXPOSE 443
