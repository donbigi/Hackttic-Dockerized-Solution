#!/bin/bash

# Define the URL to fetch the JSON from
URL="https://hackattic.com/challenges/dockerized_solutions/problem?access_token=$TOKEN$"

# Use curl to fetch the JSON data and store it in a variable
JSON=$(curl -s "$URL")

# Parse the JSON data using a tool like jq and extract the variables
USER=$(echo "$JSON" | jq -r '.credentials.user')
PASSWORD=$(echo "$JSON" | jq -r '.credentials.password')
IGNITION_KEY=$(echo "$JSON" | jq -r '.ignition_key')
TOKEN=$(echo "$JSON" | jq -r '.trigger_token')

# Print the export commands
echo "export USERNAME='$USER'"
echo "export PASSWORD='$PASSWORD'"
echo "export IGNITION_KEY='$IGNITION_KEY'"
echo "export TOKEN='$TOKEN'"