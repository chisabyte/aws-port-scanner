#!/bin/bash

# AWS EC2 Instance Port Scanner
# Author: Daniel Chisasura
# This script gets the public IP of an EC2 instance and scans it with nmap.

# --- SCRIPT LOGIC ---

# Check if an instance ID was provided.
if [ -z "$1" ]; then
    echo "Usage: $0 <INSTANCE_ID>"
    echo "Example: $0 i-0123456789abcdef0"
    exit 1
fi

INSTANCE_ID=$1

echo "🔎 Retrieving Public IP for instance: $INSTANCE_ID"

# Use the AWS CLI to get the instance's public IP address.
PUBLIC_IP=$(aws ec2 describe-instances \
    --instance-ids "$INSTANCE_ID" \
    --query "Reservations[0].Instances[0].PublicIpAddress" \
    --output text)

# Check if a public IP was found.
if [ "$PUBLIC_IP" == "None" ] || [ -z "$PUBLIC_IP" ]; then
    echo "🚫 Error: No public IP address found for instance $INSTANCE_ID."
    exit 1
fi

echo "✅ Public IP found: $PUBLIC_IP"
echo "------------------------------------------------"
echo "🚀 Starting nmap scan on $PUBLIC_IP..."

# Run a standard nmap scan.
# -sV: Probe open ports to determine service/version info.
# -T4: Use an aggressive timing template for a faster scan.
nmap -sV -T4 "$PUBLIC_IP"

echo "------------------------------------------------"
echo "✅ Nmap scan complete."