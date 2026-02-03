#!/bin/bash

source ./common.sh

CHECK_ROOT

cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGS_FILE
VALIDATE $? "Copying mongo repo"

dnf install mongodb-org -y &>>$LOGS_FILE
VALIDATE $? "Installing MongoDB server"


systemctl enable mongod 
VALIDATE $? "Enable MongoDB"

systemctl start mongod 
VALIDATE $? "Started MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE "$?" "Allowing remote connections"

systemctl restart mongod
VALIDATE $? "Restarted MongoDB"