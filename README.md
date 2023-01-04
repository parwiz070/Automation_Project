# Automation_Project

This Project is will install the apache server as will as other related softwares
And finaly compress the apache log file and copy the compress file to the S3 bucket and then this script will be run montly.

#Steps to use the script:

1. Download the automation.sh file or you can click on Code and Download the ZIP File.
2. Create a directoryt by the name Automation_Project in root user directory.
3. Copy the automation.sh file and past it into the Auomation_Project directory.
4. To Run the automation.sh file You have to use on of these three methods

#Make the script executible

chmod  +x  /root/Automation_Project/automation.sh

#switch to root user with sudo su

sudo  su
./root/Automation_Project/automation.sh

# or run with sudo privileges
sudo ./root/Automation_Project/automation.sh
