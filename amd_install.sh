#!/bin/bash
#Script for the easy installation of AMD Drivers on HiveOS/Ubuntu based OS
#Date: 2020-04-05
#Rewrite rezzocrypt

systemctl stop hivex
miner stop

echo
cd /hive-drivers-pack/
echo "Please note Drivers with the 18.04 suffix require an OS upgrade, or On Hiveos u can download the latest beta from http://download.hiveos.farm/ and install on a fresh usb."
PS3='Please enter your choice Drivers: '

options=( `/usr/bin/wget -qO- http://download.hiveos.farm/drivers/ | /bin/sed -n 's/.*href="\(amd[^"]*\).*/\1/p'` )
options+=( "Quit" )

select opt in "${options[@]}"
do
	if [[ $opt = "Quit" ]]; then
		exit
	fi
	if [[ $opt != "" ]]; then
		echo
		version=${opt/.tar.xz/};
		filename=$version.tar.xz;
		if [ -e "$filename" ]; then
			echo "Skip download. File $filename exists.";
		else
			wget http://download.hiveos.farm/drivers/${opt}
		fi
		break
	fi
	echo "Invalid option $REPLY"
done

echo
read -p "Do you want remove current AMD Drivers?(y/n)" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	echo
	/usr/bin/amdgpu-pro-uninstall
	apt-get -f install
fi

tar -Jxvf $filename
cd $version

./amdgpu-pro-install -y
dpkg -l amdgpu-pro

miner restart