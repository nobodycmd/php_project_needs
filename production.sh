#!/bin/bash

echo 'sudo timedatectl set-timezone Asia/Kolkata'

#sudo timedatectl set-timezone Asia/Kolkata

sudo groupadd www-data
useradd -m -g www-data www-data


if [ -e .env ]
then
  echo 'found .env, continue to go'
else
  echo 'not found .env'
  exit
fi


# root="/var/www/websitename"

# if [ ! -d $root ]
# then
#   mkdir -p $root
# fi

cr=`pwd`
# if [ $root != $cr ]
# then
#   echo "not sitesource code path"
#   exit
# fi


# sudo chown $USER:$USER -R ./

sudo chown www-data:www-data -R ./


if ! which nginx >/dev/null 2>&1; then
  echo 'install php7.4&php-fpm  nginx'
  sh do_app_deploy_config/soft.sh
fi



cp do_app_deploy_config/nginx.conf /etc/nginx/nginx.conf


cp do_app_deploy_config/api.conf /etc/nginx/sites-enabled/api.conf


cp do_app_deploy_config/php.ini /etc/php/7.4/cli/php.ini


cp do_app_deploy_config/www.conf /etc/php/7.4/fpm/pool.d/www.conf

#git config --global credential.helper store
#git config --global --add safe.directory /var/www/pay
#git pull

mkdir bootstrap/cache
mkdir -p storage/framework/sessions
mkdir -p storage/framework/views
mkdir -p storage/framework/cache

#sudo chown -R azureuser:azureuser ./
#sudo -u  azureuser php composer.phar install --optimize-autoloader --no-dev #Autoloader Optimization


php composer.phar install --optimize-autoloader --no-dev #Autoloader Optimization
chmod -R 777 storage
chmod  -R 777 bootstrap/cache
chmod  -R 777 storage/framework
chmod -R 777  storage/logs
chmod  -R 777 do_app_deploy_config

php artisan clear-compiled
#php artisan clear
php artisan view:clear
php artisan route:clear
php artisan config:clear

#php artisan route:cache

#cp .env.example .env

touch /var/log/www.log.slow
chown www-data:www-data /var/log/www.log.slow
#echo "sh do_app_deploy_config/ssl.sh"

#cd /var/www && wget https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.zip