import os
import sys
import boto3

from pathlib import Path

PATH = 'data'
BUCKET_NAME = sys.argv[1] #

Path(PATH).mkdir(parents=True, exist_ok=True)
os.system(f'kaggle datasets download -p "{PATH}" --unzip --force jvanelteren/boardgamegeek-reviews')

session = boto3.session.Session()
s3 = session.client(
    service_name='s3',
    endpoint_url='https://storage.yandexcloud.net'
)

# Create new bucket
if boto3.resource('s3',endpoint_url='https://storage.yandexcloud.net').Bucket(f'{BUCKET_NAME}').creation_date is None:
    s3.create_bucket(ACL='public-read', Bucket=f'{BUCKET_NAME}')

# Upload files into bucket
for filename in os.listdir(PATH):
    if filename in ['2022-01-08.csv', 'bgg-19m-reviews.csv']: # only files that are needed for downstream
        s3.upload_file(PATH + '/' + filename, f'{BUCKET_NAME}', 'data/' + filename)
        print(f'{filename} was loaded successfully!')