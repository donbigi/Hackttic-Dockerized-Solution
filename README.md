# Hackttic-Dockerized-Solution

The problem we will be solving can be found at [Hackattic Website](https://hackattic.com/challenges/dockerized_solutions)


## Prerequisite
Create 2 VMs or ! Vm and use your local machine to access the the local registry server:
- name VM registry-server and node-1
- configure firewall rule for registry-server
- Map IP address of registry-server to domain name
- Generate SSL certificate with the domain name
-  Instal Docker

registry-server will host the docker registry

# TLDR

1. **Setup:**
    - Set up your Docker registry.
    - Configure access permissions for the platform to push an image to your registry.
    - Receive the problem JSON containing credentials, including username, password, ignition key, and trigger token.
3. **Push the Image:**
    - Trigger the push by sending a POST request to `/_/push/<trigger_token>`, including the `registry_host` in the JSON payload.
4. **Retrieve the Solution:**
    - Pull the pushed image from your registry.
    - Set the `IGNITION_KEY` environment variable to the specified value from the problem JSON.
    - Run the container using the pulled image.
5. **Submission:**
    - Submit the solution by sending a POST request to `/challenges/dockerized_solutions/solve`, including the secret key returned by the container in the JSON payload.

# **Setup:** 

### Folder Setup and HTTPS Support (TLS)

**Create Certificate Storage Folders**

```bash
# create folders
mkdir test
cd test
mkdir auth
mkdir certs
cd certs

# copy your certs here
gcloud compute scp LOCATION_OF_FILES_TO_BE_SENT/* VM_NAME:HOMEDIR/test/certs/ --zone=$ZONE
```

### Docker Registry Setup

**Configure Docker for Certificate Usage**
```bash
cd ..
sudo mkdir -p /etc/docker/certs.d/$IP:443
sudo cp certs/domain.crt /etc/docker/certs.d/$IP:443/
sudo cp certs/domain.cert /etc/docker/certs.d/$IP:443/
sudo cp certs/domain.key /etc/docker/certs.d/$IP:443/
sudo cp certs/SubCA.crt /etc/docker/certs.d/$IP:443/
sudo cp certs/Root_RSA_CA.crt /etc/docker/certs.d/$IP:443/
sudo systemctl restart docker
```

### Retrieve JSON Variables
Create a `retrieve_json.sh` script:

```bash
# install jq
sudo apt-get update
sudo apt-get install jq
```

Export Access TOKEN
```bash
export ACCESS_TOKEN=$TOKEN 
```

```bash
#!/bin/bash

# Define the URL to fetch the JSON from
URL="https://hackattic.com/challenges/dockerized_solutions/problem?access_token=$TOKEN"

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

```

Execute the script:

```bash
bash retrieve_json.sh > hackattic_exports.sh
```

**Source the Exported Variables:**

Load variables into your terminal

```bash
source hackattic_exports.sh
```

**Verify the Variables:**

Ensure variables are accessible:

```bash
echo $USERNAME echo $PASSWORD echo $IGNITION_KEY echo $TOKEN echo $ACCESS_TOKEN
```

 **Configure Authentication**
```bash
## username and password:
htpasswd -Bbn $USERNAME $PASSWORD > auth/htpasswd
```

**Create and Configure Docker Registry**
```bash
# sudo usermod -aG docker $USER
# docker info

docker run -d -p 443:443 --name=local-registry --restart=always \
  -v /home/test/certs:/certs \
  -v /home/test/auth:/auth \
  -e "REGISTRY_AUTH=htpasswd" \
  -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
  -e REGISTRY_HTTP_ADDR=0.0.0.0:443 \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.cert \
  -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
  registry:2
```


### Troubleshooting and Verification

Ensure login to the registry:

```bash
docker login -u $USERNAME -p $PASSWORD $IP:443
```

Check registry reachability:

```bash
curl https://$IP:443

```

Stop docker registry
```bash
docker stop local-registry
```

Change pass
```bash
htpasswd -Bbn $USERNAME $PASSWORD > auth/htpasswd
```

Start registry
```bash
docker start local-registry
```

## Alternatively, Use Ansible to automate creating the Local Registry
  - [Provision resources on GCP with Terraform](terraform)
  - [Creating an Ansible Playbook to create the Local Docker Registry](ansible)

## ______________________________________________________________

Trigger the Push
```bash
curl -X POST https://hackattic.com/_/push/$TOKEN -d '{"registry_host": "$IP"}'

```

Registry operations:

```docker
# check names
curl -u $USERNAME:$PASSWORD -X GET https://$IP/v2/_catalog

# check versions
curl -u $USERNAME:$PASSWORD -X GET https://$IP/v2/hack/tags/list
```

**Pull the Image from Registry:**
```bash
docker pull $IP/IMAGE:TAG
```

**Run the Docker Container:**

```bash

docker run -e IGNITION_KEY=$IGNITION_KEY --name YOUR_CHOSEN_NAME $IP/IMAGE:TAG


```

## Submit the Solution in JSON Format

Create a `submit.sh` script:

```bash
#!/bin/bash

# Your access token
ACCESS_TOKEN="$TOKEN"
# Extracted secret key from container logs
SECRET_KEY="SECRET
# Endpoint URL
URL="https://hackattic.com/challenges/dockerized_solutions/solve?access_token=$ACCESS_TOKEN"
PAYLOAD="{\"secret\":\"$SECRET_KEY\"}"

# Make the POST request
curl -X POST -H "Content-Type: application/json" -d "$PAYLOAD" "$URL"

```
