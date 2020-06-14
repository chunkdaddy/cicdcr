FROM php:7.4.6-fpm
RUN apt-get update && \
   apt-get install -y \
           libzip-dev \
           libxml2-dev \
           libfreetype6-dev \
           libjpeg62-turbo-dev \
           libpng-dev \
           zip \
   && apt-get clean -y \
   && docker-php-ext-configure zip --with-libzip \
   && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
   && docker-php-ext-install -j$(nproc) gd \
   && docker-php-ext-install pdo_mysql pcntl exif zip soap bcmath \
   && pecl install grpc protobuf xdebug \
   && docker-php-ext-enable grpc \
   && echo "extension=grpc.so" >> `php --ini | grep "Loaded Configuration" | sed -e "s|.*:\s*||"`
