import requests

credentials = {
    'username':'admin',
    'password':'cloud123'
}
auth = requests.post(url = 'http://54.201.160.136:9080/security/authenticate', data = credentials)

token = auth.json().get('token')
print(token)
headers = {
    'authorization': 'STRIIM-TOKEN %s' % token,
    'content-type': 'text/plain',
}

data = '@/opt/striim/striim-PoC-migration/app_auto_build/admin.postgres_to_postgres.tql;'

response = requests.post('http://54.201.160.136:9080/api/v2/tungsten', headers=headers, data=data)

print(response.content)
