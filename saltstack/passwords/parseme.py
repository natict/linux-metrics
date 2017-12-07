import json
import sys
import pprint
import os


raw_data = json.load(open('uuids.json'))
raw_list = []
for key, value in raw_data.items():
    raw_list.append((key,value[:10]))

user_list = sorted(raw_list)
for user in user_list:
    print "{0}.example.net {1}".format(user[0],user[1])

