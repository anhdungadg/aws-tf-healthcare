#!/bin/bash
sudo yum update
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd1
echo "<h1>Hello from aws-healthcare-architecture</h1>" | sudo tee /var/www/html/index.html