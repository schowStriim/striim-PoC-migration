from auth_token import AuthToken

if __name__ == '__main__':
    authToken = AuthToken('http://54.244.39.172:9080')
    print(authToken.get_token('admin', 'cloud123'))