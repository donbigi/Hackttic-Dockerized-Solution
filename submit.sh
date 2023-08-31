#!/bin/bash

# Your access token
ACCESS_TOKEN="$TOKEN$"
# Extracted secret key from container logs
SECRET_KEY="SECRET
# Endpoint URL
URL="https://hackattic.com/challenges/dockerized_solutions/solve?access_token=$ACCESS_TOKEN"
PAYLOAD="{\"secret\":\"$SECRET_KEY\"}"

# Make the POST request
curl -X POST -H "Content-Type: application/json" -d "$PAYLOAD" "$URL"