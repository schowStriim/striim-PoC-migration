from auth_token import AuthToken

if __name__ == '__main__':
    authToken = AuthToken('http://52.43.246.11:9080')
    print(authToken.get_token('admin', 'cloud123'))