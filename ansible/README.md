# Docker Registry Setup Playbook  

This Ansible playbook automates the setup of a Docker Registry on a remote host. It includes SSL/TLS encryption, authentication with htpasswd, and other necessary configurations. 
## Prerequisites  
Before using this playbook, ensure you have the following prerequisites in place:  

1. [Create VM in GCP, Configure firewall rule and add static IP](../terraform)
2. Create a Service Account
3. [Create Dynamic Inventory using Google Cloud](inventory) 
4. An access token from your desired source (in this example, we use "https://hackattic.com/challenges/dockerized_solutions"). 
5. SSL certificates for your domain (domain.cert and domain.key) placed in the specified folder.
## Usage

1. Clone this repository to your local machine: ```git clone https://github.com/donbigi/Hackttic-Dockerized-Solution.git`
2. Modify [Dynamic Inventry](ansible/inventory/README.md) to specify your remote host(s).
3. First install docker in your server or run the `install_docker.yaml` playbook
3. Update the playbook as needed (e.g., change the paths, URLs, or Docker Registry configurations) in the `install_docker_registry.yaml` file.
4. Run the playbook using the following command: `ansible-playbook install_docker_registry.yaml`
5. The playbook will execute the necessary tasks to set up the Docker Registry on the remote host.

## Configuration

You can customize various aspects of the playbook by editing the `install_docker_registry.yaml` file:
- Modify the `URL` variable in the `Create retrieve_json.sh script` task to use your desired source for JSON data.
- Update SSL certificate paths and domain names in the `Copy SSL certificates` task.
- Customize the Docker container configuration in the `Start Docker Registry Container` task to match your requirements.
