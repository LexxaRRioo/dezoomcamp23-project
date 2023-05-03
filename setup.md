# Project step-by-step setup

## Host machine

### Kaggle API
Create Kaggle account, generate and write down new token from here https://www.kaggle.com/settings

### Yandex cloud

Configure Yandex cloud account and get 4000 rub grant: https://cloud.yandex.com/en/docs/billing/quickstart/

Following this instruction, prepare bucket for terraform state and service account: https://cloud.yandex.com/en/docs/tutorials/infrastructure-management/terraform-state-storage 
* create and activate service account for the cloud, provide 'editor' and 'storage.admin' permissions
* create and write down static key for terraform as JSON (do not place aws credentials anywhere publicly!)
* create private s3 bucket for tf state
* configure yc cli

Clone this repo: 
```bash
git clone https://github.com/LexxaRRioo/dezoomcamp23-project.git
```
and configure backend based on ```template_backend.conf```, then rename it to ```backend.conf```

generate pair of ssh keys ```id_ed25519``` using:
```bash
ssh-keygen -t ed25519 <-f path-to-files-if-needed>
```
and fill in ```template_secret.tfvars```, then rename it to ```secret.tfvars```:
* yc_folder_id and yc_cloud_id (from cloud console in left upper corner)
* ssh_key_paths
* clickhouse user_name and passwords (pick any longer or equal 8 chars)

### Spin infrastructure up using Terraform

You need to install Terraform first https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

Then export environment variables (YC_TOKEN has to be renewed each 12 hours or more often):
* Windows 10 Powershell
```powershell
$Env:YC_CLOUD_ID=$(yc config get cloud-id)
$Env:YC_FOLDER_ID=$(yc config get folder-id)
$Env:YC_TOKEN=$(yc iam create-token)
```
* Linux
```bash
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
export YC_TOKEN=$(yc iam create-token)
```

Run terraform commands
```bash
terraform init --backend-config backend.conf
terraform plan -var-file="secret.tfvars" -out plan
terraform apply plan
```

### Finally, connect to the VM via SSH

Put ip address from Output section of terraform to ```~/.ssh/config``` pasting those lines to the end
```
Host yc_dez
	HostName <vm_ip>
	User ubuntu
	PreferredAuthentications publickey
	IdentityFile <absolute/path/to/private!/key>
```

Then I recommend you use VSCode remote window https://code.visualstudio.com/docs/remote/remote-overview

# On cloud VM

## Preparation

```bash
sudo apt-get update && sudo apt-get upgrade -y
sudo apt install git -y
sudo apt install python3-pip -y
sudo apt install python3.8-venv -y

git clone https://github.com/LexxaRRioo/dezoomcamp23-project.git
```

Fill in  ```templates/``` files using info from service account static key (AWS credentials), Kaggle API token, Terraform output and ```terraform/secret.tfvars```. Then place files where they are needed for authentication in services and make sure only this user would have access:
```bash
mkdir ~/.aws ~/.kaggle ~/.dbt
cp ~/dezoomcamp23-project/templates/.kaggle_kaggle.json ~/.kaggle/kaggle.json
cp ~/dezoomcamp23-project/templates/.aws_config ~/.aws/config
cp ~/dezoomcamp23-project/templates/.aws_credentials ~/.aws/credentials
cp ~/dezoomcamp23-project/templates/.dbt_profiles.yml ~/.dbt/profiles.yml
chmod 600 ~/.kaggle/kaggle.json
chmod 600 ~/.aws/credentials
chmod 600 ~/.dbt/profiles.yml
```
dbt and Clickhouse connection is configured using this instruction, use it if needed:
https://clickhouse.com/docs/en/integrations/dbt

also connection info for .dbt/profiles.yml is placed in Clickhouse cluster's page on console.cloud.yandex.ru

## Downloading from API and uploading into S3 cloud storage

Prepare python environment
```bash
cd ~/dezoomcamp23-project
. env/bin/activate
pip install -r requirements.txt
export PATH=$PATH:~/.local/bin
cd ~/dezoomcamp23-project
```

Run python script with <your-bucket-name> parameter. Bucket name has to be unique in whole yandex cloud namespace and would be configured for public read.
```bash
python3 upload_to_s3.py "<your-bucket-name>"
```

## dbt
	
Check connection configured in ~/.dbt/profiles.yml first:
```bash
cd ~/dezoomcamp23-project/dez_dbt
dbt debug
```
	
Replace <bucket_name> in ```dez_dbt/macros/init_s3_sources.sql``` using your-bucket-name. Unfortunately variable doesn't work here, use Ctrl+H.

Create tables from S3 objects and views based on them leveraging dbt power. Also check autocreated documentation, it's cool:
```bash
dbt run-operation init_s3_sources
dbt test
dbt run

dbt docs generate
dbt docs serve --port 9999
```


Then connect clickhouse to DataLens (BI service) via clickhouse cluster page in cloud console and manually setup connection, datasets, charts and dashboard.

![изображение](https://user-images.githubusercontent.com/63540060/235901176-b9a849c2-8bdc-4d12-80d1-50a044664047.png)
	
Result is available here (same link as in README.md): https://datalens.yandex/aq4trx4em99k0
