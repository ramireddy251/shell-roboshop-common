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
VALIDATE $? "Enavle and start rabbitmq server"

rabbitmqctl add_user roboshop roboshop123 &>>$LOGS_FILE
VALIDATE "adding roboshot user and password"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOGS_FILE
VALIDATE $? "setting permissions to roboshop user"
