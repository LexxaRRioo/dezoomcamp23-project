# Инструкция

## Первичная настройка (уже выполнена)
. создать организацию с федерацией, облако, каталог и сервисный аккаунт ```sa-yc-cert-terraform```, выдать sa права ```editor``` и ```data-transfer.admin``` на каталог

. создать статический ключ доступа для сервисного аккаунта и записать реквизиты

. положить в корневую директорию проекта ```secret.tfvars``` со значением следующих переменных:
```
yc_folder_id = ""
yc_cloud_id  = ""
mysql_mng_user_name = ""
mysql_mng_user_pass = ""
mysql_user_name = ""
mysql_user_pass = ""
```

. создать бакет и описать его в backend.conf (следуя инструкции https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-state-storage)

. отредактировать инструкцию ниже (приведённые id ресурсов)


## Запуск после первичной настройки

. проверить наличие файлов ```backend.conf```, ```secret.tfvars``` в корневой директории проекта

. настроить локальный экземпляр терраформ (шаги 3-5 https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-state-storage), затем инициализировать yc profile:

```bash
yc init --federation-id=bpfni7vj8309b6frbi62 # создайте новый профиль и введите в wizard'e данные ниже или воспользуйтесь командами
yc config profile create tf-profile
yc config set service_account_id aje97g594kqsmv4vr1vj
yc config set cloud-id b1g8vi5r0mavd45gbj86
yc config set folder-id b1gncejninir3oj1jd1n
yc config set compute-default-zone ru-central1-a

# yc iam key create --folder-name yc-cert --service-account-name sa-yc-cert-terraform --output key.json # этот вариант лучше, если его можно как-то получить без авторизации через OAuth
# yc config set service-account-key .\key.json # needed??
```

. сгенерировать пару ключей для ssh с именем ```id_ed25519``` и указать путь до .pub в ```variables.tf.vm_ssh_key_path``` (по умолчанию ~/.ssh/id_ed25519.pub). rsa wouldn't work!
например, на win10:

```powershell
ssh-keygen -t ed25519
```

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

. прописать в ```C:\Windows\System32\drivers\etc\hosts``` или ```/etc/hosts```
<mysql_store_ip> ya-sample-store.local 
(ip высветится в terraform outputs)


. после работы с базой следует удалить созданные ресурсы:
```bash
terraform destroy -var-file="secret.tfvars" # then hit yes
```
