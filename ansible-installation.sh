#!/bin/bash

# Ansible 2.9+ Installation Script for Red Hat/CentOS 8
# This script installs Ansible and its dependencies on Red Hat-based systems

set -e  # Exit on any error

echo "=== Ansible 2.9+ Installation for Red Hat/CentOS 8 ==="

# Step 1: Update package manager
echo "Step 1: Updating package lists..."
sudo dnf update -y

# Step 2: Install Python and pip (required for Ansible)
echo "Step 2: Installing Python 3.8 and pip..."
#sudo dnf install -y python3 python3-pip
sudo dnf install -y python38 python38-devel

# Step 3: Install system dependencies
echo "Step 3: Installing system dependencies..."
sudo dnf install -y git curl wget openssh-clients rsync

# Step 4: Upgrade pip to latest version
echo "Step 4: Upgrading pip..."
sudo python3.8 -m pip install --upgrade pip
export PATH=$PATH:/usr/local/bin

# Step 5: Install Ansible 2.9 or later
echo "Step 5: Installing Ansible..."
python3.8 -m pip install 'ansible>=2.9'

# Step 6: Verify installation
echo "Step 6: Verifying installation..."
ansible --version

echo ""
echo "=== Installation Complete ==="
echo "Ansible is ready to use. Run 'ansible --version' to confirm."