import json
import requests
from requests.exceptions import RequestException, Timeout

#Create app
headers = {
    'Authorization': 'STRIIM-TOKEN 01ed7583-7ab3-7421-b5af-0a4c7c2c0bb3',
    'Content-Type': 'Content-Type'
}

data = {
  "templateId": "database-to-database-initialload",
  "templateDefinition": {
    "sourceAdapter": "DatabaseReader",
    "formatter": "string",
    "parser": "string",
    "targetAdapter": "DatabaseWriter"
  },
  "applicationName": "admin.test3",
  "applicationSettings": {
    "recovery": {
      "enabled": "true",
      "period": 0
    },
    "encryption": "false",
    "exceptionHandlers": {}
  },
  "sourceParameters": {
    "Username": "myname",
    "Password": "mypassword",
    "Password_encrypted": "false",
    "ConnectionURL": "198.51.100.15:1521:orcl",
    "Tables": "MYSCHEMA.%"
  },
  "targetParameters": {
    "Username": "myname",
    "Password": "mypassword",
    "Password_encrypted": "false",
    "ConnectionURL": "198.51.100.15:1521:orcl",
    "Tables": "MYSCHEMA.%,MYSCHEMA.%"
  },
  "parserParameters": {},
  "formatterParameters": {}
}
response = requests.post(url='http://35.89.203.89:9080//api/v2/applications', headers=headers, data=data)

print(response)