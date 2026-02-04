#!/bin/bash

source ./common.sh

app_name=frontend
app_dir=/usr/share/nginx/html
CHECK_ROOT

dnf module disable nginx -y &>>$LOGS_FILE
VALIDATE $? "Disable Nginx"

dnf module enable nginx:1.24 -y &>>$LOGS_FILE
VALIDATE $? "Enabled Nginx 1.24"

dnf install nginx -y &>>$LOGS_FILE
VALIDATE $? "Installing Nginx"

systemctl enable nginx 
systemctl start nginx 
VALIDATE $? "Enabled and started Nginx"

rm -rf $app_dir/* &>>$LOGS_FILE
VALIDATE $? "Removing existing index.html file"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$LOGS_FILE
VALIDATE $? "Downloading front end configuration"

cd $app_dir &>>$LOGS_FILE
VALIDATE $? "Changing directory to /usr/share/nginx/html"

unzip /tmp/frontend.zip &>>$LOGS_FILE
VALIDATE $? "unzip front end configuration"

rm -rf /etc/nginx/nginx.conf

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf &>>$LOGS_FILE
VALIDATE $? "Copying nginx config"

systemctl restart nginx 
VALIDATE $? "Restarted Nginx"