#!/bin/bash

# Ansible 2.9+ Installation Script for Debian/Ubuntu
# This script installs Ansible and its dependencies on Debian-based systems

set -e  # Exit on any error

echo "=== Ansible 2.9+ Installation for Debian/Ubuntu ==="

# Step 1: Update package manager
echo "Step 1: Updating package lists..."
sudo apt-get update

# Step 2: Install Python and pip (required for Ansible)
echo "Step 2: Installing Python 3 and pip..."
sudo apt-get install -y python3 python3-pip python3-venv

# Step 3: Install system dependencies
echo "Step 3: Installing system dependencies..."
sudo apt-get install -y git curl wget openssh-client

# Step 4: Upgrade pip to latest version
echo "Step 4: Upgrading pip..."
python3 -m pip install --upgrade pip

# Step 5: Install Ansible 2.9 or later
echo "Step 5: Installing Ansible..."
python3 -m pip install 'ansible>=2.9'

# Step 6: Verify installation
echo "Step 6: Verifying installation..."
ansible --version

echo ""
echo "=== Installation Complete ==="
echo "Ansible is ready to use. Run 'ansible --version' to confirm."