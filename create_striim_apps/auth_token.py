import json
import requests
from requests.exceptions import RequestException, Timeout

class AuthErr(Exception):
    pass

class AuthToken:
    PATH = '/security/authenticate'
    def __init__(self, url):
        self.url = url

    def get_token(self, username, password):
        payload = {'username': username, 'password': password}
        try:
            url = self.url + AuthToken.PATH
            resp = requests.post(url, data=payload)
            if resp.status_code != 200:
                raise AuthErr('Likely: wrong username / password.')
            tokenjson = json.loads(resp.text)
            return tokenjson["token"]
        except RequestException as ex:
            raise ex

if __name__ == '__main__':
    authToken = AuthToken('http://35.89.203.89:9080')
    print(authToken.get_token('admin', 'cloud123'))
