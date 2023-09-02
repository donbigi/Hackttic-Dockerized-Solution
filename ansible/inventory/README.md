# Dynamic Inventory using Google Cloud

1. Install google-auth module using pip. I am using pip3.
    
    ```shell
    sudo pip3 install requests google-auth
    ```
    
2. Create a inventory directory. You can create this anywhere of your choice and change permissions.
    
    ```shell
    sudo mkdir -p ansible/inventory
    ```
    
3. Create the YAML inventory file (gcp.yaml) and copy the below contents and please change the file according to your project and service account:
```yaml
---
plugin: gcp_compute
projects:
	- PROJECT_ID # List your GCP project(s) here
auth_kind: serviceaccount
service_account_file: PATH_TO_SA # Path to your service account key file
keyed_groups:
	- key: labels
	  prefix: label
	- key: zone
	  prefix: zone
groups:
	remote: "'LABEL_OF_RESOURCES' in (labels|list)" # label to identify your vm instance
```

### Create a config file `~/.ansible.cfg`
```shell
[defaults]
private_key_file = ~/.ssh/PRIVATE_KEY
inventory = /PATH_TO_INVENTRY_YAML
```
### Test:
```shell
ansible remote -m ping   
## or run
ansible-inventory --list
```