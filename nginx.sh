#!/bin/bash
apt update
apt upgrade
apt install -y nginx
myip=`curl ifconfig.co`
echo "NGINX server - $myip" > /var/www/html/index.html
systemctl enable nginx
systemctl start nginx