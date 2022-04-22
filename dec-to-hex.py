#!/usr/bin/python

from sys import argv

oid = argv[1]

oid = oid.split('.')

oid.pop(0)
oid.pop(0)

mac = ""
for i in oid:
    temp = str(hex(int(i))).replace("0x","")

    if len(temp) ==1:
        temp = "0" + temp

    mac = mac +":"+ temp

mac = mac[1:]
print(mac)
