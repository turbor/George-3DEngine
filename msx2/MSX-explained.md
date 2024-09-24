This document is meant for people who want more in-depth info about the way the MSX2 port of the engine works. Due to the nature of the MSX architecture this possed some interesing challenges.

# The architecture of the MSX
## The CPU
The main CPU of the MSX systems is a 3.5MHz Z80 cpu. This 8 bits CPU has a 16bits addressbus and 8bits databus. Beside memory access it has an aditional 256 I/O ports that are independend from the memory. This means that peripherals could be addressed without having to be mapped in to the address range of the memory as was more common in the homecomputeers of those days.

## The Video
The display on an MSX1 is provided by a TMS99x8 which in an MSX2 was replaced with the more powerfull V9938. These chips have there own memory independend from the main CPU and all communication is through the I/O ports of the CPU. This seperation means that while display doesn't take up any main memory used by the CPU it is slow to access and makes it difficult to implement timing senstive display effects.

## The memory layout
Here is were the MSX standard is getting utterly complex. So hold on to your hats..
### MSX1
The MSX is an Z80 based homecomputer so the (in the eighties) common 16 bit address range makes it possible for the main CPU to see an amount of 64KB memmory.
To make it possible to have more memory in the machine the MSX1 standard introduced bankswitching. The 64KB range was split up in 4 pieces of 16 KB and each of those pieces could be mapped to one of four mainslots. switching of these pages into the slots is done using I/O port 0xA8. To allow even more rom/ram to be used each slot can be divided into 4 subslots. These sublots are controled by writing into memory address 0xFFFF of the mainslot. Yes, switching subslots isn't a straightforward thing...
So in an MSX1 you have a 16KB BIOS rom and a 16KB BASIC rom. So the maximum amount of ram you can have is 4 mainslots * 4subslots per mainslot * 4 blocks of 16KB per subslot - 16KB BASIC -16KB BIOS => 992KB of ram.
### MSX2
In the MSX2 standard an extra way of adding memmory was introduced: The Memory Mapper.
A memory mapper is a set of maximum 256 blocks of 16KB of ram and occupies a complete subslot. So each subslot can now contain 4 megabyte of ram instead of 64KB. These blocks are visible in each of the four 16KB ranges of the CPU address space. You select the id  of the visible block by writing to I/O port 0xFC..0xFF. Writing to those I/O ports will set ALL memory mappers at the same time.
It is also now possible to make the same block of 16KB visible in multiple (even all four at the same time) pages byt writting the same value to all four I/O ports. So an MSX2 can have almost 64MB of memmory available! Not bad for an 8-bit computer.

## MSX Basic
### Memory layout when using Basic
In the 64KB that the Z80 can address the memory is used as follows

| | |
|--|--|
| 0x0000        |        |
| **BIOS ROM**  |        |
| 0x4000        |        |
| **BASIC ROM** |        |
| 0x8000        |        |
| **Start RAM** | Also default start of tokenized basic program, but that can be changed by altering system variable (0xF676)  |
| 0x????        |        |
| **Regular undimensioned basic variables** |        |
|               |   system variable (0xF6C2)  |
| 0x????        |        |
|               |   **All basic arrays**  |
|               |   system variable (0xF6C4)  |
| 0x????        |        |
| **Unused space**  |  system variable (0xF6C6)  |
| 0x????        |        |
| **Stack**     | in the SP register of the Z80  |
| 0x????        |        |
| **Stringpool** | Memory reserved to store string variables.<br>Size of the pool can be changed with the first argument of the Basic CLEAR command. Stored in system variable (0xF674)  |
| 0x????        |        |
|   **Ram used by DiskBasic.** | Size depends on MAXFILES command. Stored in system variable (0xF672)  |
| 0x????        |        |
| **Ram reserved by user**  | Address can be changed with the second argument of the Basic CLEAR command<br>Can be used to store ML routines that you can call using the USR() Basic command<br>Stored in system variable (0xFC4A)  |
| 0xDE78        |        |
| **Diskbuffers and BIOS-RAM workspace**  |  system variable (0xFC4A)  |
| 0xFFFF        |        |

I used the address as the are initialised on an unexpanded Philips NMS8245 machine. This shows that for a regular basic program you have about 22KB ram available. This is mainly due to the hefty size of both BIOS and BASIC roms. Since these 3D object need a huge amount of space to store all the vertices the MSX2 workarea for basic is whoofully undersized.

### Circumventing the limitation
A standard european MSX2 machine has 128KB of RAM on board, being 8 banks of 16KB in an internal mapper. When booting the MSX2, bank 0 is visible in the range 0xC000-0xFFFF, and bank 1 is visible from 0x8000-0xBFFF. This leaves 6 banks of 16KB unused for basic. 

In the 3D engine the memory hogs are the integer arrays used to store the 3D coordinates of each vertex (X%,Y%,Z%)  and the on screen projected 2D coorindates (VX%,VY%). The MSX2 basic program uses a small bit of Z80 ML code to store each of these arrays in its seperate memory bank. Since each bank is 16KB and an signed integer in MSX BASIC takes up two bytes this means that each array can store 8192 integers :-)

The faces of the 3D object are read sequentially each time and the visibility is determined immediately using the normal vector of the face. If the just read faace is not visible it will not be stored in memory. So the amount of visible faces is reduced significantly and this much smaller array is handled by the regular BASIC interpreter.


