#!/bin/bash

sudo groupadd www-data
useradd -m -g www-data www-data

mkdir -p storage/framework/{sessions,views,cache}

chmod -R 777 storage
mkdir bootstrap/cache
chmod -R 777  bootstrap/logs
chmod  -R 777 bootstrap/cache

php artisan clear-compiled
#php artisan clear
php artisan view:clear
php artisan route:clear
php artisan config:clear


php composer.phar install --optimize-autoloader --no-dev #Autoloader Optimization

chown www-data:www-data ./ -R