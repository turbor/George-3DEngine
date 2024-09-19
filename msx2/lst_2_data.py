#!/usr/bin/python3
def convert_to_data(filename: str) -> None:
    dblist=list()
    with open(filename) as f:
        for line in f.readlines():
            if line[0] == '#':
                continue
            data=line[11:24].rstrip()
            if len(data)>0:
                dblist.extend(data.split(' '))
    linenr = 100
    while len(dblist) > 1:
        print(str(linenr) + " data " + ",".join(dblist[0:8]))
        dblist = dblist[8:]
        linenr += 10

if __name__ == '__main__':
    convert_to_data("defusr.lst")
