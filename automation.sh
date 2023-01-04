#!/bin/bash
# Checking is the user is root or not if not the user will be changed to root
if [ "$(whoami)" != "root" ]
then
    sudo su -s "$0"
    exit
fi
#Uniqe Backet name
s3_bucket="upgrad-parwaiz-popalzai" 
echo "After 2 second the installatin will be start"
sleep 2
echo "Checking for package update"
apt update -y
echo "Installing AWSCLI"
apt install awscli
echo "Installing apache2 if it is not installed yet"
apt -y install apache2

ps cax | grep apache2
if [ $? -eq 1 ]
then
	echo "Process is running." || exit 1
elif [ $? -eq 0 ]
then
	echo "Process is not running" 
	echo "apache2 is starting after 1 second"
	systemctl start apache2
fi

#Cheking is apache2 is active or not
systemctl is-active apache2.service
#Cheking is apache2 is enable or not
is_enabled=$(systemctl is-enabled apache2)
echo "The result of is_enabled: $is_enabled"
if [ $is_enabled != disabled ]
then
echo "apache is enabled"
else
echo "apache2 is  going to enable"
systemctl enable apache2
fi
# Chenging the apache2.server restart mode to always
cd /lib/systemd/system

sed -i 's/on-abort/always/g' apache2.service
systemctl daemon-reload
echo "Installatin is successfully Completed"
sleep 3
name="parwiz-httpd-logs"
tar_file=$(date +"%d-%m-%y-%H-%M-%S")
newf=$name-$tar_file
dir_list="/var/log/apache2"
cd $dir_list
# Checking if the directory is present then generate the tar file from logs
if [ ! -d $dir_list ]
then 
        echo "Directory does not exist : $dir_list" || exit 1
else
tar cf $dir_list/$newf.tar *.log # access.log error.log
echo "Files have been archived" ||exit 1
#echo "$dir_list/$newf"
echo "Moving the file to tmp directory"
sleep 5
mv $newf.tar /tmp
echo "Archive file has been moved to tmp directory"
fi
cd /tmp
echo "Uploading tar file to s3 bucket"
sleep 3
aws s3 \
cp /tmp/${newf}.tar \
s3://${s3_bucket}/${newf}.tar

