#!/bin/bash

# Log everything to /var/log/user-data.log for debugging
exec > /var/log/user-data.log 2>&1
set -x  # Enable debug mode

echo "### Updating System Packages ###"
sudo dnf clean all
sudo dnf update -y

echo "### Installing Java (Amazon Corretto 17) ###"
sudo dnf install -y java-17-amazon-corretto || { echo "Java installation failed"; exit 1; }

echo "### Installing Jenkins Dependencies ###"
sudo dnf install -y fontconfig tzdata libXext || { echo "Dependency installation failed"; exit 1; }

echo "### Adding Jenkins Repository ###"
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo || { echo "Failed to download Jenkins repo"; exit 1; }

echo "### Importing Jenkins GPG Key ###"
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key || { echo "Failed to import Jenkins GPG key"; exit 1; }

# Verify the repo file exists
if [ ! -f /etc/yum.repos.d/jenkins.repo ]; then
    echo "Error: Jenkins repo file not found!"
    exit 1
fi

echo "### Installing Jenkins ###"
sudo dnf install -y jenkins || { echo "Jenkins installation failed"; exit 1; }

echo "### Enabling and Starting Jenkins Service ###"
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Wait for Jenkins to start
sleep 15
sudo systemctl status jenkins --no-pager || { echo "Jenkins failed to start"; exit 1; }

echo "### Configuring Firewall Rules for Jenkins ###"
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload || { echo "Firewall configuration failed"; exit 1; }

echo "### Installing Git ###"
sudo dnf install -y git || { echo "Git installation failed"; exit 1; }

echo "### Installing Terraform ###"
sudo dnf install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo dnf install -y terraform || { echo "Terraform installation failed"; exit 1; }

echo "### Installing Kubectl (Latest Stable Version) ###"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/ || { echo "Kubectl installation failed"; exit 1; }

echo "### Verifying Installed Versions ###"
java -version
jenkins --version || echo "Jenkins installation verification failed!"
git --version
terraform -version
kubectl version --client

echo "### Jenkins Installation Completed Successfully! ###"
