#!/bin/bash

source ./common.sh
app_name=shipping

CHECK_ROOT
app_setup
java_setup
systemd_setup

dnf install mysql -y &>>$LOGS_FILE
VALIDATE $? "Installing mysql client"

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 -e 'use cities'
if [ $? -ne 0 ]; then

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOGS_FILE
VALIDATE $? "Loading schema in to db"

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$LOGS_FILE
VALIDATE $? "Create app user in mysql db"

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOGS_FILE
VALIDATE $? "Loading master data in to db"

else
  echo "data is already loaded .... skipping"
fi  

systemctl restart shipping
VALIDATE $? "restarting shipping service"

app_restart