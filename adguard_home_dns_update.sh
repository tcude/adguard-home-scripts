#!/bin/bash
# Script for adding DNS rewrites in AdGuard Home

# Input hostname and IP address
read -p "Enter hostname (e.g., testvm.yourdomain.com): " HOSTNAME
read -p "Enter IP address (e.g., 192.168.1.100): " IP_ADDRESS

# Validate inputs
if [[ ! "$HOSTNAME" =~ ^[a-zA-Z0-9.-]+$ ]]; then
    echo "Invalid hostname format."
    exit 1
fi

if [[ ! "$IP_ADDRESS" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Invalid IP address format."
    exit 1
fi

# Function to update DNS in AdGuard Home
function update_dns {
    ADGUARD_API_URL=${ADGUARD_API_URL:-"http://<adguard_instance_ip>:80/control/rewrite/add"}
    USERNAME=${ADGUARD_USERNAME:-"adguard_username"}
    PASSWORD=${ADGUARD_PASSWORD:-"adguard_password"}
    BASIC_AUTH=$(echo -n "$USERNAME:$PASSWORD" | base64)

    JSON_PAYLOAD="{\"domain\":\"$HOSTNAME\",\"answer\":\"$IP_ADDRESS\",\"ttl\":3600}"

    # Debug print statement
    echo "JSON Payload: $JSON_PAYLOAD"

    # Make the API request and capture the response
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$ADGUARD_API_URL" -H "Content-Type: application/json" -H "Authorization: Basic $BASIC_AUTH" -d "$JSON_PAYLOAD")

    # Check the response status code
    if [ "$RESPONSE" -eq 200 ]; then
        echo "DNS rewrite added successfully."
    else
        echo "Failed to add DNS rewrite. HTTP status code: $RESPONSE"
    fi
}

# Call the update_dns function to update DNS
update_dns
