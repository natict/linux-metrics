## Print generated password

The user salt state has created the `lab` user using the first 10 characters from the server's salt "UUID". All server full UUID's can be printed in json format by running:
```
$ salt-ssh ws* grains.get uuid --out=json --static > uuids.json
```
Passwords can be printed on screen by running:
```
$python parseme.py
```
