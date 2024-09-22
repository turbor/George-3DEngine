10 SCREEN7:COLOR3,1,1:FC=0
15 MAXFILES=2:OPEN "GRP:" AS #1
20 GOSUB 2500
30 GX=10:GY=195:GZ=180:P=3.1415926535#/180
40 CF=3:CD=0:CC=100
50 FS=400:DX=160:DY=120:L=15:CP=2
60 OPEN "VERTEX.SEQ" FOR INPUT AS #2
70 INPUT#2,C,D,H,U:DIMU(U):DIMSL(U)
80 REM DIMX%(C):DIMY%(C):DIMZ%(C):DIMXI(U)
90 REM DIMVX%(C):DIMVY%(C):FR=400
95 FR=400:DIMXI(U)
100 DIMOO%(FR):DIMOI%(FR):DIMFF%(FR*5)
110 HH=0:VV=0:PRINT"LOADING VERTICES"
120 FORA=1TOC:
130 INPUT#2,X%,Y%,Z%
132 E$=USR0("X"+HEX$(A)+","+HEX$(X%))
133 E$=USR0("Y"+HEX$(A)+","+HEX$(Y%))
134 E$=USR0("Z"+HEX$(A)+","+HEX$(Z%))
150 HH=1:VV=0:GOSUB3300::PRINT #1,STR$(A)+"/"+STR$(C)
160 NEXT
170 CLOSE #2:GOTO 470
210 A$=INPUT$(1):
220 a=asc(a$):if a>96 and a<123 then A$=chr$(axor32)
230 IFA$="X"THENGOSUB3200:?#1,"ANGLE X-AXIS ("+STR$(GX)+")":INPUTGX
240 IFA$="Y"THENGOSUB3200:?#1,"ANGLE Y-AXIS ("+STR$(GY)+")":INPUTGY
250 IFA$="Z"THENGOSUB3200:?#1,"ANGLE Z-AXIS ("+STR$(GZ)+")":INPUTGZ
320 IFA$="V"THENGOSUB3200:?#1,"VERTICAL POS DY ("+STR$(DY)+")":INPUTDY
330 IFA$="H"THENGOSUB3200:?#1,"HORIZONT.POS DX ("+STR$(DX)+")":INPUTDX
340 IFA$="C"THENGOSUB3200:?#1,"FACES OVER CP ("+STR$(CP)+")":INPUTCP
355 IFA$="P"THEN GOSUB 2400
356 IFA$="F"THEN GOSUB 2398:GOTO210
357 IFA$="B"THEN CLR:GOTO10
370 IFA$="E"THENGOSUB3200:?#1,"FISHEYE FS ("+STR$(FS)+")":INPUTFS
390 IFA$="M"THENGOSUB3200:?#1,"ZOOM L ("+STR$(L)+")":INPUTL
410 IFA$="L"THEN TI$="000000":GOTO 690
412 IFA$="Q"THEN CLS:END
413 IFA$="D"THEN CF=(NOT(CF))+2:CD=(NOT(CD))+2
414 IFA$="N"THEN GOSUB 5100: REM CENTER MODEL
415 IFA$="U"THEN GOSUB 7000: REM SCALE MODEL TO BORDER
420 REM
430 IFA$="I"THEN GOSUB 3100: GOTO210
420 REM
460 REM
470 REM7290
480 GOSUB 2500
490 REM Start drawing all vertices. Press a key to interrupt
500 RX=GX*P
510 RY=GY*P
520 RZ=GZ*P
530 CX=COS(RX):SX=SIN(RX)
540 CY=COS(RY):SY=SIN(RY)
550 CZ=COS(RZ):SZ=SIN(RZ)
560 REM
570 FORNP=1TOC
575 A$=INKEY$:IF A$<>""THEN GOTO 220
580 XP=USR1("X"+HEX$(NP))/D*L
590 YP=USR1("Y"+HEX$(NP))/D*L
600 ZP=USR1("Z"+HEX$(NP))/D*L
605 print xp,yp,zp
610 REM
620 GOSUB 1290
630 X1=DX+INT(((XP*FS)/(ZP+FS))+0.5)
640 Y1=DY+INT(((YP*FS)/(ZP+FS))+0.5)
641 E$=USR0("V"+HEX$(NP)+","+HEX$(X1)):REM VX%(NP)=X1
642 E$=USR0("W"+HEX$(NP)+","+HEX$(Y1))::REM VY%(NP)=Y1
650 PSET (X1,Y1),CF
655 preset(0,0):print#1," "+str$(x1)+" "
656 preset(0,8):print#1," "+str$(y1)+" "
660 NEXT
670 GOSUB3200:?#1,"!":GOTO210
680 REM Load faces and draw them...
690 GOSUB 3200:?#1,"FIND FACES " :REM  + STR$(FRE(0))
700 OPEN "PLANES.SEQ" FOR INPUT AS #2
710 I=1:FR=0:FF=0:II=0:FV=0
720 FOR A=1 TO H
725 IF I=1 THEN INPUT#2,M1,M2,M3:GOSUB 4000
730 INPUT#2,V
740 U(I)=V
750 IF V>0 THEN I=I+1:GOTO 770
751 FR=FR+1:GOSUB790:I=1
770 NEXT
780 CLOSE #2:GOSUB 1500:T1=TI:GOTO 210
790 REM All points for this face(A) are read 11000
791 IF VS=0 THEN RETURN
792 GOSUB 2390:REM POKE$30D,3:POKE$30E,0:SYS$FFF0:? "AR:"+STR$(AR)+" " + STR$(I):
793 IF AR<=CP THEN RETURN
810 OO=0
820 FORG = 1 TO I-2
829 REM LINEVX%(U(G)),VY%(U(G)),VX%(U(G+1)),VY%(U(G+1)),CF
830 LINE (USR1("V"+HEX$(U(G)))  , USR1("W"+HEX$(U(G))) )-(USR1("V"+HEX$(U(G+1)))  ,  usr1("W"+HEX$(U(G+1))) ),CF
831 XP=USR1("X"+HEX$(U(G))):YP=USR1("Y"+HEX$(U(G))):ZP=USR1("Z"+HEX$(U(G)))
832 GOSUB 5000
840 OO=OO+ZP
850 NEXT
860 REM LINEVX%(U(G)),VY%(U(G)),VX%(U(1)),VY%(U(1)),CF
861 LINE (USR1("V"+HEX$(U(G)))  , USR1("W"+HEX$(U(G))) )-(USR1("V"+HEX$(U(1)))  ,  usr1("W"+HEX$(U(1))) ),CF
870 REM ?G, I: GRAPHIC 0: END
851 REM XP=X%(U(G)):YP=Y%(U(G)):ZP=Z%(U(G))
852 XP=USR1("X"+HEX$(U(G))):YP=USR1("Y"+HEX$(U(G))):ZP=USR1("Z"+HEX$(U(G)))
853 GOSUB 5000
1190 OO=(OO+ZP)/G:G=I:
1200 FF=FF+1:PRESET(0,8):?#1,"F:"+STR$(FF)
1210 FV=FV+G:Preset(0,16):?#1,"V:"+STR$(FV)
1220 OO%(FF) = OO
1221 OI%(FF)=II+1
1230 FORYY=1TOG-1
1240 FF%(II+YY)=U(YY)
1250 NEXT
1260 FF%(II+G)=FR*(-1):II=II+G
1270 RETURN
1290 REM40000
1299 REM rotate around X,Y,Z
1300 YT=YP:YP=CX*YT-SX*ZP:ZP=SX*YT+CX*ZP
1310 XT=XP:XP=CY*XT+SY*ZP:ZP=-SY*XT+CY*ZP
1320 XT=XP:XP=CZ*XT-SZ*YP:YP=SZ*XT+CZ*YP
1330 RETURN
1410 REM SHELL SORT
1420 REM
1430 W1=FF
1431 PRESET(0,24):?#1,"              "
1432 PRESET(0,16):?#1,"              "
1435 PRESET(0,8):?#1,STR$(FF)+"->"+STR$(W1)+ "    "
1440 IF W1<=0 THEN 1480
1445 W1=INT(W1/2): W2=FF-W1
1450 V=0
1455 FOR N1=0 TO W2
1460 W3=N1+W1
1465 IF OO%(N1)<OO%(W3)THEN GOSUB1477: V=1
1470 NEXT N1
1475 IF V>0 THEN 1450
1476 GOTO 1435
1477 S1=OO%(N1): OO%(N1)=OO%(W3): OO%(W3)=S1
1479 S1=OI%(N1): OI%(N1)=OI%(W3): OI%(W3)=S1
1480 RETURN
1490 REM
1500 REM GET VISIBLE FACES
1510 REM ZEICHNESICHTBAREFACES
1520 PRESET(0,0):?#1,"SORT"
1530 GOSUB 1410 : REM shell sort
1540 GOSUB 2500 : CLS
1550 K=1
1560 FORJ=1TOFF
1570 FORI=OI%(J)TOFV
1580 U(K)=FF%(I)
1590 IF FF%(I)>0 THEN K=K+1
1600 IF FF%(I)<0 THEN GOSUB1970:K=1:GOTO1640
1620 NEXTI
1630 REM 42111
1640 NEXTJ
1650 RETURN
1960 REM DRAW FACES
1970 G=K:REM61200
1971 IFU(G)<-1THENCS=3:GOTO 1980
1972 CS=2
1980 N=G-1:IT=I:JT=J:TX=DX:TY=DY:TK=K:YN=200:YX=0:UG=U(G):U(G)=U(1)
1990 REM
2000 FORI=1TON
2010 IF USR1("W"+HEX$(U(I)))<YN THEN YN=USR1("W"+HEX$(U(I)))
2020 IF USR1("W"+HEX$(U(I)))>YX THEN YX=USR1("W"+HEX$(U(I)))
2030 DY=USR1("W"+HEX$(U(I+1)))-USR1("W"+HEX$(U(I)))
2040 DX=USR1("V"+HEX$(U(I+1)))-USR1("V"+HEX$(U(I)))
2050 IFDY=0THENSL(I)=1.0
2060 IFDX=0THENSL(I)=0.0
2070 IF(DY<>0)AND(DX<>0)THENSL(I)=DX/DY
2080 NEXT
2090 CL=0:REM CL=RND(1)*255+1
2100 FORY=YNTOYX-1
2110 K=0
2120 REM
2130 FORI=1TON
2140 IF((USR1("W"+HEX$(U(I)))<=Y)AND(USR1("W"+HEX$(U(I+1)))>Y))THENGOSUB2350
2150 IF((USR1("W"+HEX$(U(I)))>Y)AND(USR1("W"+HEX$(U(I+1)))<=Y))THENGOSUB2350
2160 NEXT
2170 REM
2180 FORJ=0TOK-2
2190 FORI=0TOK-2
2200 IFXI(I)>XI(I+1)THENT=XI(I):XI(I)=XI(I+1):XI(I+1)=T
2210 NEXT
2220 NEXT
2230 REM
2240 FORI=0TOK-1STEP2
2250 LINE(XI(I),Y)-(XI(I+1),Y),CL
2260 NEXT
2270 NEXT
2280 REM
2290 FORI=1TON
2300 REM LINE VX%(U(I)),VY%(U(I)),VX%(U(I+1)),VY%(U(I+1)),5: REM CD
2305 LINE(USR1("V"+HEX$(U(I))), USR1("W"+HEX$(U(I))))-(USR1("V"+HEX$(U(I+1))),USR1("W"+HEX$(U(I+1)))),5
2310 NEXT
2320 REM
2330 I=IT:J=JT:DX=TX:DY=TY:K=TK:U(G)=UG
2340 RETURN
2350 REM61600
2360 XI(K)=USR1("V"+HEX$(U(I)))+SL(I)*(Y-USR1("W"+HEX$(U(I))))
2370 K=K+1
2380 RETURN
2388 REM Calculate area of face
2389 REM TODO is 2393 wrong? shouldn't that be a -
2390 AR = 0
2391 AJ = I-1 
2392 FOR AI=1 TO I-1
2393 AR=AR+(USR1("V"+HEX$(U(AJ)))+usr1("V"+HEX$(U(AI))))*(USR1("W"+HEX$(U(AJ)))-USR1("W"+HEX$(U(AI))))
2394 AJ=AI
2395 NEXT AI
2396 AR=ABS(AR/2)
2397 RETURN 
2398 IFFC=0THENCOLOR4,2,1:FC=1:RETURN:REM TODO adjust to MSX oclors
2399 COLOR4,1,0:FC=0:RETURN:REM TODO adjust to MSX oclors
2400 RETURN: REM GFX SAVE ROUTINE
2500 CLS: RETURN: REM SCNCLR
3097 REM
3098 REM PRINT info on screen
3099 REM
3100 HH=0:VV=0:GOSUB3300:?#1,"GX:"+STR$(GX)+" DX:"+STR$(DX)+" L:"+STR$(L)
3110 HH=1:VV=0:GOSUB3300:?#1,"GY:"+STR$(GY)+" DY:"+STR$(DY)+" M:" + STR$(FRE(0))
3120 HH=2:VV=0:GOSUB3300:?#1,"GZ:"+STR$(GZ)+" FS:"+STR$(FS)+" CD:" + STR$(CD)
3125 HH=3:VV=0:GOSUB3300:?#1,"TI:"+STR$(T/60)+"S"
3130 RETURN
3197 REM
3198 REM go to topleft for on screen printing
3199 REM
3200 PRESET(0,0):return
3297 REM
3298 REM go to (VV,HH) for on screen printing
3299 REM
3300 preset(VV*8,HH*8):RETURN
3997 REM
3998 REM Determine visibilty of normal vector
3999 REM
4000 XP=M1:YP=M2:ZP=M3
4620 GOSUB5000
4670 VS=0:IFZP<0.0THENVS=1
4780 RETURN
4997 REM
4998 REM Determine ZP
4999 REM
5000 ZP=SX*YP+CX*ZP
5010 ZP=-SY*XP+CY*ZP
5020 RETURN
