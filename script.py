import os
import boto3


dir = 'de-course/data'
os.system(f'kaggle datasets download -p "{dir}" --unzip --force jvanelteren/boardgamegeek-reviews')

#!/usr/bin/env python
#-*- coding: utf-8 -*-
session = boto3.session.Session()
s3 = session.client(
    service_name='s3',
    endpoint_url='https://storage.yandexcloud.net'
)

# Создать новый бакет
s3.create_bucket(Bucket='dez-rzv-final-project')

# Загрузить объекты в бакет

## Из строки

for filename in os.listdir(dir):
    s3.upload_file(dir + '/' + filename, 'dez-rzv-final-project', 'data/' + filename)
# todo: add progress bar and/or direct downloading with unpacking into s3 bucket