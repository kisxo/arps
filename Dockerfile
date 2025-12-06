File: Dockerfile
FROM php:8.2-cli AS base

# System packages and PHP extensions
RUN apt-get update && apt-get install -y \
git unzip curl libpng-dev libonig-dev libxml2-dev \
libzip-dev libpq-dev libcurl4-openssl-dev libssl-dev \
zlib1g-dev libicu-dev g++ libevent-dev procps \
&& docker-php-ext-install pdo pdo_mysql pdo_pgsql mbstring zip exif pcntl bcmath sockets intl

# Swoole is installed from GitHub
RUN curl -L -o swoole.tar.gz https://github.com/swoole/swoole-src/archive/refs/tags/v5.1.0.tar.gz \
&& tar -xf swoole.tar.gz \
&& cd swoole-src-5.1.0 \
&& phpize \
&& ./configure \
&& make -j$(nproc) \
&& make install \
&& docker-php-ext-enable swoole

# Node.js 18 (Vite compatible) and Yarn installation
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
&& apt-get install -y nodejs \
&& npm install -g bun
