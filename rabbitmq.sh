#!/bin/bash

source ./common.sh
app_name=rabbitmq

CHECK_ROOT

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$LOGS_FILE
VALIDATE $? "Copying rabbitmq.repo"

dnf install rabbitmq-server -y &>>$LOGS_FILE
VALIDATE $? "Installing rabbitmq"

systemctl enable rabbitmq-server
systemctl start rabbitmq-server
VALIDATE $? "Enable and start rabbitmq server"

rabbitmqctl list_users | grep -w roboshop &>>$LOGS_FILE

if [ $? -ne 0 ]; then
    rabbitmqctl add_user roboshop roboshop123 &>>$LOGS_FILE
    VALIDATE $? "adding roboshop user and password"
else
    echo -e "roboshop user already exists ... $Y SKIPPING $N" | tee -a $LOGS_FILE
fi

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOGS_FILE
VALIDATE $? "setting permissions to roboshop user"
