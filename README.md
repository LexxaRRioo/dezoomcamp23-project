Dataset: https://www.kaggle.com/datasets/jvanelteren/boardgamegeek-reviews
1GB in an archive

![DEZ_project drawio](https://user-images.githubusercontent.com/63540060/235530006-03517b74-4663-4215-b7c6-f0fbfe98138b.png)



# setup:
### set yandex cloud secrets:
* yc_folder_id
* yc_cloud_id

create and activate service account for the cloud, provide 'editor' and 'storage.admin' permissions
create and write down static key for terraform

create s3 bucket for tf state and configure ./backend.conf
https://cloud.yandex.com/en/docs/tutorials/infrastructure-management/terraform-state-storage 

. сгенерировать пару ключей для ssh с именем ```id_rsa``` и указать путь до .pub в ```variables.tf.vm_ssh_key_path``` (по умолчанию ~/.ssh/id_rsa.pub)
add service_account_id to the variables

. перед запуском каждой сессии нужно задать переменные. вариант для windows, powershell (токен следует обновлять каждый час, не реже раза в 12 часов):
```powershell
$Env:YC_CLOUD_ID=$(yc config get cloud-id)
$Env:YC_FOLDER_ID=$(yc config get folder-id)
$Env:YC_TOKEN=$(yc iam create-token)
```

. наконец, запустить команды в terraform
```bash
terraform init --backend-config backend.conf
terraform plan -var-file="secret.tfvars" -out plan
terraform apply plan # then hit yes
```


then connect to base_vm_ip using ssh and key generated earlier
adding this ip to ~/.ssh/config



create Kaggle account
download new token: https://www.kaggle.com/settings and put it in ~/.kaggle/kaggle.json


history:
sudo apt-get update && sudo apt-get upgrade -y
sudo apt install git -y
sudo apt install python3-pip
pip install dbt-clickhouse
git clone https://github.com/LexxaRRioo/dezoomcamp23-project.git
mkdir ~/.kaggle && cd ~/.kaggle
code kaggle.json
chmod 600 ~/.kaggle/kaggle.json
mkdir ~/.aws && cd ~/.aws
code config
code credentials

run upload_to_s3.py

export PATH=$PATH:~/.local/bin
cd ~/dezoomcamp23-project
dbt init dez_dbt
code ~/.dbt/profiles.yml

dbt and clickhouse connection configured using this instruction:
https://clickhouse.com/docs/en/integrations/dbt
create and fill ~/.dbt/profiles.yml using connection info from clickhouse console.cloud.yandex.ru

cd ~/dezoomcamp23-project/dez_dbt
dbt debug

add credentials from ~/.aws/credentials to the 2nd and the 3rd parameters of 'FROM s3()' function


in dbt project:

vars:
  aws_key_id: # fill in
  aws_access_key: # fill in

dbt run-operation init_s3_sources
dbt run

dbt docs generate
dbt docs serve --port 9999 



Room to improve:
. Replace Kaggle dataset with BoardGameGeek (BGG) API and automate batch processing via Mage or Airflow
. Configure Liquibase on VM to manage database schema for tables based on s3 files/BGG API
. Put everything into docker container and/or provision all needed configuration through Ansible
. Fix service account permissions from clickhouse to s3 object storage
. Replace each credential with variable to change it only in one place