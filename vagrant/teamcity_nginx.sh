#!/bin/sh

# install nginx
sudo apt-get install -y nginx

# update the config
sudo cp  /vagrant/files/server/conf/nginx.conf /etc/nginx/sites-available/teamcity
sudo mkdir -p /var/www/teamcity

# create syn link
sudo ln -s /etc/nginx/sites-available/teamcity /etc/nginx/sites-enabled/teamcity

sudo rm -rf /etc/nginx/sites-enabled/default
sudo rm -rf /etc/nginx/sites-available/default

# reload
sudo /etc/init.d/nginx reload
