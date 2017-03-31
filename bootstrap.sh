#! /usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

MYSQL_ROOT_PASSWORD="password"

apt-get update > /dev/null 2>&1

echo -e "\n --- Installing MySQL 5.6 ---\n"
echo mysql-server-5.6 mysql-server/root_password password $MYSQL_ROOT_PASSWORD | debconf-set-selections
echo mysql-server-5.6 mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD | debconf-set-selections
apt-get -y install mysql-server-5.6 > /dev/null 2>&1
sed -i "s/bind-address/#bind-address/g" /etc/mysql/my.cnf
service mysql restart > /dev/null 2>&1

mysql -uroot -p$MYSQL_ROOT_PASSWORD << EOF
 use mysql;
 CREATE USER 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
 GRANT ALL PRIVILEGES ON *.* TO 'root'@'%';
 UPDATE mysql.user SET Grant_priv='Y', Super_priv='Y' WHERE User='root';
 FLUSH PRIVILEGES;
EOF
