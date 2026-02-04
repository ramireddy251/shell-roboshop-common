#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
SCRIPT_DIR=$PWD
MONGODB_HOST=mongodb.ramireddy.co.in
MYSQL_HOST=mysql.ramireddy.co.in


CHECK_ROOT(){

    if [ $USERID -ne 0 ]; then
        echo -e "$R Please run this script with root user access $N" | tee -a $LOGS_FILE
        exit 1
    fi
}

mkdir -p $LOGS_FOLDER

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$2 ... $R FAILURE $N" | tee -a $LOGS_FILE
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N" | tee -a $LOGS_FILE
    fi
}

nodejs_setup() {
    dnf module disable nodejs -y &>>$LOGS_FILE
    VALIDATE $? "disable nodejs"

    dnf module enable nodejs:20 -y &>>$LOGS_FILE
    VALIDATE $? "enable jodejs 20 version"

    dnf install nodejs -y &>>$LOGS_FILE
    VALIDATE $? "Installing nodejs"

    npm install 
    VALIDATE $? "installing npm"
}

java_setup() {
    dnf install maven -y &>>$LOGS_FILE
    VALIDATE $? "Installing maven"

    cd /app
    mvn clean package &>>$LOGS_FILE
    VALIDATE $? "Installing and Building $app_name"

    mv target/$app_name-1.0.jar $app_name.jar &>>$LOGS_FILE
    VALIDATE $? "renaming and moving to /app"
}

app_setup() {
    id roboshop &>>$LOGS_FILE
    if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOGS_FILE
    VALIDATE $? "creating system user"
    else
    echo -e "Roboshop user already exists .... $Y SKIPPING $N"
    fi

    mkdir -p /app 
    VALIDATE $? "created /app directory" &>>$LOGS_FILE

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$LOGS_FILE
    VALIDATE $? "Downloading $app_name code"

    cd /app 
    VALIDATE $? "Moving to app directory"

    rm -rf /app/*
    VALIDATE $? "Removing existing code"

    unzip /tmp/$app_name.zip
    VALIDATE $? "unzip $app_name code"
}

systemd_setup() {
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service
    VALIDATE $? "Copying $app_name service config"

    systemctl daemon-reload
    systemctl enable $app_name 
    systemctl start $app_name
    VALIDATE $? "Starting and enabling $app_name"
}

app_restart() {
    systemctl restart $app_name
    VALIDATE $? "Restarting $app_name"
}