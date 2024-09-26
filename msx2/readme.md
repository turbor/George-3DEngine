# 3D Engine v2.6

For an MSX2 or higher with a maper of 128KB or more.   
Original non-msx version by Georgios Patsos 2023-11-18   
http://www.georgeschannel.de   
https://www.youtube.com/@GeorgesChannel

## MSX port by David Heremans 2024-09-16

### Introduction:
After stumbeling upon GeorgesChannel by pure serendipity, it seemed that this marvel programmed in Basic should be ported to my favorite 8-bitter. :-)
With this (very experimental) software you can render Wavefront Obj-Files on an MSX2 system. Tested with openMSX v20.0 emulating Philips_NMS_8245 and Panasonic_FS-A1GT. For people unfamiliar with the MSX and its internals, I explained some of it in the MSX-explained.md

The code is unoptimized, not bugfree and doesn't do any input sanitization so it won't render every 3D model perfectly, but with some effort and experience you can achieve good results. The software is a port from the Commander X16 port, which in turn was based upon the commodore plus/4 version, which is the original main development version. 

The code is kept small by intention with a very simple user-interface to have more RAM for the model-data left. Its also written by intention in BASIC to be easy portable on other Systems.

### How to run the program:
1. Start the emulator with the dir-as-disk feature to use the subdirectory as diskimage.
In case of openmsx, you could run from commandline like this:
```
openmsx -machine Philips_NMS_8245 -diska msx2
```
You can have the emulation run at maximum speed by pressing F9 to toggle the throttle function.

2. Wait until the program asks for the name of the object to render. Enter this name with out the extention. Remember no input checks here neither!

## Usage:
After the vertices are loaded the model-vertices (points) are drawn first. 
When the Symbol (!) appears in upper left, you have following choices by pressing one of the following keys:
| Key | Function |
| --- | -------- |
| L | START RENDERING, this is a SLOW process due to all the work involved! |
| I | INFO: display current values         |
|  |
| X | Set rotation angle for X-axis |
| Y | Set rotation angle for Y-axis |
| Z | Set rotation angle for Z-axis |
|  |
| V | Set vertical position |
| H | Set horizontal position |
|  |
| M | Set zoom-factor |
| C | Draw only faces with area over cp |
| E | FISHEYE, the lower the number the higher the distortion |
| D | Switch between wireframe and filled faces |
|  |
| F | Alternates the frame color (helps when zooming and positioning the model) |
|  |
| U | Scale model up to border |
| N | Center model |
|  |
| B | Restart program |
| Q | Quit the programm |

### How to render your own object:
 1. Create a 3d-Model in Blender (or other 3d-Programm) with max 1000 verts
 2. Keep the models as simple as possible, convex and avoid too complex faces. Ideal are triangles or squares faces.
 3. Export your model as OBJ File with "write Normals" Option clicked
 4. Convert the OBJ File with the convertor.py program
 5. Put the two files <objname>.ver and <objname>.fac into the msx disk directory
 6. Run the emulator as described above

Youtube tutorial (English, commodore plus/4 version):   
https://youtu.be/Zo7tMpFoxLY

Important Variables in the code:   
Line 30 gx=0:gy=135:gz=210   
(Rotation of the object around the midpoint in x,y,z axis in degrees)

Line 50 dx=130:dy=90: l=14: cp=2  
(dx,dy:Position of the midpoint in the screen ), l = Scalefactor,   
cp=Filters all faces out, which have area value smaller 2


Delivered files:
 * converter.py   
   Usage: python3 converter.py <objname>.obj   
   Converts an OBJ file (e.g from Blender) into <objname>.ver and <objname>.fac

 * test.bas   
   A readable version of the sourcecode of the 3dengine V2.6 ported to MSX2


Epilog:

Please check out the original version made by George and support him if you'ld like to.


