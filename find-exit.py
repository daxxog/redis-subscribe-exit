#!/usr/bin/python3
import redis
from os import environ
from time import sleep


debug_mode = environ.get('DEBUG', False)
r = redis.Redis.from_url(environ.get('REDIS_URL'))
p = r.pubsub()
p.subscribe(environ.get('REDIS_CHANNEL'))

while True:
    msg = p.get_message()

    if type(msg) == dict and type(msg['data']) == bytes:
        try:
            exit_code = int(msg['data'])
            print(f'do exit: {exit_code}')
            exit(exit_code)
        except ValueError:
            print(f"could not parse as integer: {msg['data']}")
    else:
        if debug_mode:
            print('waiting for message . .')

    sleep(1)
