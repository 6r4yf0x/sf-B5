#!/bin/bash
apt update
apt upgrade
apt install -y apache2
myip=`curl ifconfig.co`
echo "Apache server - $myip" > /var/www/html/index.html
systemctl enable apache2
systemctl start apache2