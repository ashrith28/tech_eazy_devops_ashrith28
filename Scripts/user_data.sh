#!/bin/bash
sudo apt update -y
sudo apt install openjdk-21-jdk maven -y

git clone https://github.com/Trainings-TechEazy/test-repo-for-devops.git
cd test-repo-for-devops
mvn clean package
nohup java -jar target/hellomvc-0.0.1-SNAPSHOT.jar &

sleep 300  # Wait 5 minutes for everything to complete

# Upload logs again (after some time)
aws s3 cp /var/log/cloud-init.log s3://$BUCKET/cloud-init.log
aws s3 cp target/hellomvc-0.0.1-SNAPSHOT.jar s3://$BUCKET/app/logs/

shutdown -h now  # Shut down the EC2 instance to save cost
