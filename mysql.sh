#!/bin/bash

source ./common.sh

app_name=mysql
CHECK_ROOT

dnf install mysql-server -y &>>$LOGS_FILE
VALIDATE $? "Installing mysql server"

systemctl enable mysqld 
systemctl start mysqld 
VALIDATE $? "Enabled and started mysql service"

mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "Setting password for mysql db"