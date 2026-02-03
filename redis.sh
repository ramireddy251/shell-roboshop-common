#!/bin/bash

source ./common.sh
app_name=catalogue

CHECK_ROOT

dnf module disable redis -y &>>$LOGS_FILE
VALIDATE $? "Disable redis"

dnf module enable redis:7 -y &>>$LOGS_FILE
VALIDATE $? "enable redis 7"

dnf install redis -y &>>$LOGS_FILE
VALIDATE $? "Installing redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf
VALIDATE $? "Allowing remote connections"

sed -i 's/^protected-mode yes/protected-mode no/' /etc/redis/redis.conf
VALIDATE $? "changed protected-mode to no"

systemctl enable redis 
systemctl start redis 
VALIDATE $?  "Enabled and started redis service"