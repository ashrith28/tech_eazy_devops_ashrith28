#!/bin/bash
sudo apt update -y
sudo apt install openjdk-21-jdk maven -y

git clone https://github.com/Trainings-TechEazy/test-repo-for-devops.git
cd test-repo-for-devops
mvn clean package
nohup java -jar target/hellomvc-0.0.1-SNAPSHOT.jar &

# Simulate log uploads to S3
BUCKET="ashrith-devops-app-logs"
aws s3 cp /var/log/cloud-init.log s3://$BUCKET/cloud-init.log
aws s3 cp target/hellomvc-0.0.1-SNAPSHOT.jar s3://$BUCKET/app/logs/
