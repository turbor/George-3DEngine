#!/usr/bin/python3
def load_obj(filename: str) -> dict:
    obj=dict()
    obj['v']=list()
    obj['vn']=list()
    obj['f']=list()
    with open(filename) as f:
        for line in f.readlines():
            if line[0] == '#':
                continue
            if line.startswith("v "):
                add_vertex(obj,line[2:])
            elif line.startswith("f "):
                add_face(obj,line[2:])
            elif line.startswith("vn "):
                add_vertexnorm(obj,line[3:])
    return obj

if __name__ == '__main__':
    load_obj("suzanneN.obj")
