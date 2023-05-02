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

. сгенерировать пару ключей для ssh с именем ```id_ed25519``` и указать путь до .pub в ```variables.tf.vm_ssh_key_path``` (по умолчанию ~/.ssh/id_ed25519.pub)

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

code ~/.kaggle/kaggle.json
chmod 600 ~/.kaggle/kaggle.json
code ~/.aws/config
code ~/.aws/credentials
chmod 600 ~/.aws/credentials

sudo apt-get update && sudo apt-get upgrade -y
sudo apt install git -y
sudo apt install python3-pip -y
sudo apt install python3.8-venv -y

git clone https://github.com/LexxaRRioo/dezoomcamp23-project.git
cd dezoomcamp23-project
. env/bin/activate
pip install -r requirements.txt

export PATH=$PATH:~/.local/bin
cd ~/dezoomcamp23-project
python3 upload_to_s3.py "your-bucket-name"

code ~/.dbt/profiles.yml

dbt and clickhouse connection configured using this instruction:
https://clickhouse.com/docs/en/integrations/dbt
create and fill ~/.dbt/profiles.yml using connection info from clickhouse console.cloud.yandex.ru

cd ~/dezoomcamp23-project/dez_dbt
dbt debug

replace <bucket_name> in dez_dbt/macros/init_s3_sources.sql using your bucket_name

dbt run-operation init_s3_sources
dbt test
dbt run

dbt docs generate
dbt docs serve --port 9999 


Then connect clickhouse to DataLens (BI service) via clickhouse cluster page in cloud console.


Room to improve:
. Replace Kaggle dataset with BoardGameGeek (BGG) API and automate batch processing via Mage or Airflow
. Configure Liquibase on VM to manage database schema for tables based on s3 files/BGG API
. Put everything into docker container and/or provision all needed configuration through Ansible
. Fix service account permissions from clickhouse to s3 object storage
. Replace each credential with variable to change it only in one place


What didn't work:
. service account to access s3 object storage from clickhouse server without secret keys
. 