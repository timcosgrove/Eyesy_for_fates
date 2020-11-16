#!/bin/bash

set -ex

# Add nodejs Debian package as source.
# Note the need to allow releaseinfo changes. See https://askubuntu.com/questions/989906/explicitly-accept-change-for-ppa-label
curl -sL https://deb.nodesource.com/setup_14.x | sed -e 's/apt-get /apt-get --allow-releaseinfo-change /g' | sudo bash -

# Debian packages
sudo apt install -y python-pygame python-liblo python-alsaaudio python-pip nodejs

# Python packages
sudo pip install psutil cherrypy

# Node packages
cd web/node && npm install && cd ../..

# Move service files into place and make sure perms are set correctly.
services=("eyesy-python.service" "eyesy-web.service" "eyesy-web-socket.service" "eyesy-pd.service")
for i in "${services[@]}"
do
  sudo chmod 644 systemd/$i
  sudo cp systemd/$i /etc/systemd/system
done

# Move PD into place.
cp pd/*.pd_linux ../../pdexternals

# Reload services.
sudo systemctl daemon-reload
