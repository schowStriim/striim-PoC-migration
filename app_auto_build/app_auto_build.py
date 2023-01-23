import requests

credentials = {
    'username':'admin',
    'password':'cloud123'
}
auth = requests.post(url = 'http://54.201.160.136:9080/security/authenticate', data = credentials)

token = auth.json().get('token')
print(token)

curl --request POST \
--url http://54.201.160.136:9080/api/v2/tungsten \
--header 'authorization: STRIIM-TOKEN 01ed9b28-6da4-13a1-8523-0accdb7d3fc1' \
--header 'content-type: text/plain' \
--data-raw '@/home/ec2-user/striim-PoC-migration/app_auto_build/admin.postgres_to_postgres.tql;' --user 'striim:cloud123'
