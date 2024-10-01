#!/usr/bin/python3
import os.path
import sys
import argparse
from pprint import pprint

def add_vertex(obj:dict, info:str) -> None:
    vertex=info.split(" ")
    obj['v'].append(vertex)

def add_vertexnorm(obj:dict, info:str) -> None:
    vertex=info.split(" ")
    obj['vn'].append(vertex)

def add_face(obj:dict, info:str) -> None:
    vertex=info.split(" ")
    faceinfo=list()
    for i in vertex:
        faceinfo.append(i.split('/'))
    obj['f'].append(faceinfo)

def load_obj(filename: str) -> dict:
    obj=dict()
    obj['d']=100
    obj['v']=list()
    obj['vn']=list()
    obj['f']=list()
    with open(filename) as f:
        for line in f.readlines():
            if line[0] == '#':
                continue
            elif line.startswith("v "):
                add_vertex(obj,line[2:].rstrip())
            elif line.startswith("f "):
                add_face(obj,line[2:].rstrip())
            elif line.startswith("vn "):
                add_vertexnorm(obj,line[3:].rstrip())
    return obj

def normalize_obj(obj:dict) -> dict:
    xmin = min(map(lambda a:float(a[0]) ,obj['v']))
    xmax = max(map(lambda a:float(a[0]) ,obj['v']))
    ymin = min(map(lambda a:float(a[1]) ,obj['v']))
    ymax = max(map(lambda a:float(a[1]) ,obj['v']))
    zmin = min(map(lambda a:float(a[2]) ,obj['v']))
    zmax = max(map(lambda a:float(a[2]) ,obj['v']))
    xoffset = (xmax + xmin)/float(2.0)
    yoffset = (ymax + ymin)/float(2.0)
    zoffset = (zmax + zmin)/float(2.0)
    maxdist = max(abs(xmax-xoffset),abs(ymax-yoffset),abs(zmax-zoffset))
    for i,v in enumerate(obj['v']):
        obj['v'][i][0] = ((200.0 / 15.0) / maxdist) * (float(v[0]) + xoffset)
        obj['v'][i][1] = ((200.0 / 15.0) / maxdist) * (float(v[1]) + yoffset)
        obj['v'][i][2] = ((200.0 / 15.0) / maxdist) * (float(v[2]) + zoffset)
    return obj


def save_vertex(obj:dict, filename:str) -> None:
    # first find the multiplier to get the maximum resolution out of these 16bit signed integers
    # for now we simply go for 100
    obj['d']=100
    m=obj['d']
    fm=1+max(map(lambda a:len(a) ,obj['f']))
    tf=sum(map(lambda a:1+len(a) , obj['f'] ) )
    with open(filename,'wt',newline='\r\n') as f:
        # First the header line with the needed info
        header=f"{len(obj['v'])},{m},{tf},{fm}"
        f.write(f"{header}\n")
        # Then dump each vertex on a single line
        for v in obj['v']:
            line=','.join( map(lambda a: str(int(float(a)*m)), v) )
            f.write(f"{line}\n")
        f.write("\n")


def save_faces(obj:dict, filename:str) -> None:
    m=obj['d']
    with open(filename,'wt',newline='\r\n') as f:
        for i,face in enumerate(obj['f']):
            facenormal=face[0][2]
            # check if all the same!
            for g in face:
                if g[2] != facenormal:
                    print(f"Not all normal vectors the same for face {i}!")
                    pprint(face)
                    sys.exit(1)
            facenormal=int(facenormal) - 1
            #now first dump the face normal
            line=','.join( map(lambda a: "{:.5g}".format(float(a)*m), obj['vn'][facenormal]) )
            f.write(f"{line}\n")
            #then dump all vertices that make up this face
            for p in obj['f'][i]:
                f.write(f"{p[0]}\n")
            #then close with a '0' line
            f.write("0\n")
        f.write("\n")

def parseArguments():
    parser = argparse.ArgumentParser(
                    prog='convertor.py',
                    description='This program converts OBJ files to two sequential files for the BASIC 3D engine',
                    epilog='Enjoy the show!')
    parser.add_argument('filename')     # positional argument
    parser.add_argument('-d', '--divider', type=int,nargs=1,
                    help="Manual set the divider used to convert the BASIC int back to float. If not specified the convertor will find the maximum divider.")    # manually set the divider
    parser.add_argument('-v', '--verbose',action='store_true')  # on/off flag
    return parser.parse_args()

if __name__ == '__main__':
    args=parseArguments()
    filename=args.filename
    obj=load_obj(filename)
    obj=normalize_obj(obj)
    save_vertex(obj,os.path.splitext(filename)[0]+".ver")
    save_faces(obj,os.path.splitext(filename)[0]+".fac")
