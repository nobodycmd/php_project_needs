

#link https://www.digitalocean.com/community/tutorials/how-to-install-php-7-4-and-set-up-a-local-development-environment-on-ubuntu-20-04
function setup {
  sudo apt-get update
  sudo apt -y install software-properties-common
  sudo add-apt-repository ppa:ondrej/php
}


function install_php {
  sudo apt -y install php7.4 php7.4-dev

  sudo apt-get install -y php7.4-cli php7.4-json php7.4-common php7.4-mysql php7.4-zip php7.4-gd php7.4-mbstring php7.4-curl php-xml php7.4-xml php7.4-bcmath
  sudo apt-get install -y php7.4-redis

  sudo apt-get install -y php7.4-fpm
  #The FPM service will start automatically, once the installation is over. You can verify that using the following systemd command:
  #systemctl status php7.4-fpm
  systemctl enable php7.4-fpm # enable it to start at system reboot:

  apt-get install libevent-dev -y
  #echo "https://www.workerman.net/doc/workerman/install/install.html"
  echo "tip:For ' Include libevent OpenSSL support [yes] : ' , input no "
  #pecl install event
}


function install_swoole {
    echo 'for swoole'

    sudo apt-get install libcurl4-openssl-dev -y

    sudo apt-get install libc-ares-dev -y

    pecl install -D 'enable-sockets="no" enable-openssl="yes" enable-http2="yes" enable-mysqlnd="yes" enable-swoole-json="no" enable-swoole-curl="yes" enable-cares="yes"' https://pecl.php.net/get/swoole-4.8.11.tgz

    echo extension=swoole.so > /etc/php/7.4/cli/conf.d/20-swoole.ini
}


function remove_apache2 {
  killall apache2
  killall htcacheclean
  apt purge apache2
  apt autoremove
}


# 安装Nginx
function install_nginx {
    sudo apt-get update
    sudo apt-get install -y nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
}


# 安装MySQL
function install_mysql {
    sudo apt-get install -y mysql-server
    sudo mysql_secure_installation
    #ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'new_password';
    #FLUSH PRIVILEGES;
}

function main {
      setup
      install_php
      install_swoole
      remove_apache2
      install_nginx
      install_mysql
}

main