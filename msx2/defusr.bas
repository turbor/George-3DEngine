10 rem CLEAR 200,&HD800
20 P=&HD800:DEFUSR0=P:DEFUSR1=P+2
30 READ A$:IF A$="*" THEN 50
40 POKE P,VAL("&H"+A$):P=P+1:GOTO 30
50 RUN"test.bas"
100 data 18,11,CD,25,D8,5E,23,56
110 data ED,53,F8,F7,3E,02,32,63
120 data F6,18,0C,CD,25,D8,E5,CD
130 data 42,D8,EB,E1,73,23,72,3E
140 data 01,D3,FE,FB,C9,2A,F8,F7
150 data 46,23,5E,23,56,EB,7E,05
160 data D6,53,F3,D3,FE,23,EB,CD
170 data 42,D8,29,3E,3F,A4,F6,80
180 data 67,C9,21,00,00,78,B7,C8
190 data 1A,13,05,D6,30,D8,FE,0A
200 data 38,05,D6,07,FE,10,D0,29
210 data 29,29,29,D5,16,00,5F,19
220 data D1,18,E2
1000 data *
