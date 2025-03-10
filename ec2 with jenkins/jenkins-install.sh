#!/bin/bash

# Clean metadata & update system
sudo yum clean all
sudo yum update -y

# Install Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade -y

# Install Java 17 (Ensure correct version)
sudo yum install -y java-17-amazon-corretto

# Set Java 17 as the default
sudo alternatives --set java /usr/lib/jvm/java-17-amazon-corretto.x86_64/bin/java

# Verify Java version
java -version

# Install Jenkins
sudo yum install -y jenkins

# Set permissions for Jenkins user
sudo chown -R jenkins:jenkins /var/lib/jenkins
sudo chmod -R 755 /var/lib/jenkins

# Start & Enable Jenkins service
sudo systemctl daemon-reload
sudo systemctl enable --now jenkins

# Verify Jenkins status
sudo systemctl status jenkins --no-pager

# Install Git
sudo yum install -y git

# Install Terraform
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum install -y terraform

# Install kubectl (latest version)
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo chmod +x ./kubectl
sudo mkdir -p $HOME/bin && sudo cp ./kubectl $HOME/bin/kubectl
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
source ~/.bashrc
