#!/bin/bash

source ./common.sh

app_name=dispatch
CHECK_ROOT
app_setup
systemd_setup

dnf install golang -y &>>$LOGS_FILE
VALIDATE $? "Installing golang"

go mod init dispatch &>>$LOGS_FILE
VALIDATE $? "init go"

go get &>>$LOGS_FILE
VALIDATE $? "get go"

go build &>>$LOGS_FILE
VALIDATE $? "Build go"

app_restart

