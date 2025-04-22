#!/bin/bash

set -e
echo "Hello Terraform!" > test.txt
sudo -s
apt-get update
apt-get install -y apache2
systemctl enable apache2

git clone https://github.com/SmithaVerity/ABTestingApp.git

mv ABTestingApp/cafe /var/www/html
