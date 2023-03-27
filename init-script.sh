#!/bin/bash

set -e

sudo -s
apt-get update
apt-get install -y apache2
systemctl enable apache2

git clone https://github.com/SmithaVerity/ABTestingApp.git

mv ABTestingApp/cafe /var/www/html
