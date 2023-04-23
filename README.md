Dataset: https://www.kaggle.com/datasets/jvanelteren/boardgamegeek-reviews
1GB in an archive




# setup:
### set yandex cloud secrets:
* yc_folder_id
* yc_cloud_id

create and activate service account for the cloud, provide 'editor' and 'storage.admin' permissions
create and write down static key for terraform

create s3 bucket for tf state and configure ./backend.conf
https://cloud.yandex.com/en/docs/tutorials/infrastructure-management/terraform-state-storage 

. сгенерировать пару ключей для ssh с именем ```id_rsa``` и указать путь до .pub в ```variables.tf.vm_ssh_key_path``` (по умолчанию ~/.ssh/id_rsa.pub)


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

