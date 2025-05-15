#!/bin/bash

set -e

sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl enable apache2
sudo systemctl start apache2

git clone https://github.com/SmithaVerity/ABTestingApp.git

sudo mv ABTestingApp/cafe /var/www/html
sudo chmod -R 755 /var/www/html/cafe
