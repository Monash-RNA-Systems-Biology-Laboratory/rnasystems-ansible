#!/usr/bin/env python

# Also try tcpdump post 53

import os

seen = set()
show = [ ]
for line in list(os.popen("grep UFW /var/log/syslog","r"))[::-1]:
    dsts = [ item for item in line.split() if item[:4] == "DST=" ]
    for dst in dsts:
        if dst in seen: continue
        seen.add(dst)
        show.append((line.strip(), dst[4:]))

for line, addr in show[::-1]:
    print line
    os.system("host "+addr)
    print

