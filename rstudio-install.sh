#!/bin/bash
VERSION=$(lsb_release -a 2>/dev/null | grep Codename | cut -f2)
DEB="rstudio-server-0.99.903-amd64.deb"
sudo echo -e "\n# The Comprehensive R Archive Network \ndeb https://cloud.r-project.org/bin/linux/ubuntu $VERSION/" >> /etc/apt/sources.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install r-base r-base-dev gdebi-core
wget -O /tmp/$DEB https://download2.rstudio.org/$DEB
sudo gdebi /tmp/$DEB
sudo rstudio-server verify-installation
[[ $? = 1 ]] && echo -e "\nInstallation failed.\n" && exit 1
read -p "Listen on port (default is 8787): " PORT
[[ $PORT = "" ]] && PORT="8787"
mkdir -p /etc/rstudio
echo "www-port=$PORT" > /etc/rstudio/rserver.conf
sudo rstudio-server restart
read -p "Create user (can be left empty): " USER
[[ $USER != "" ]] && sudo useradd $USER --create-home && sudo passwd $USER
echo -e "\nDone!\n"
