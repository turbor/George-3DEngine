sjasmplus --nologo --msg=war --dirbol --fullpath --longptr --syntax=Fwa --raw=defusr.bin --sym=defusr.sym --lst defusr.asm
cat defusr.b1 >defusr.bas
python3 lst_2_data.py >>defusr.bas
echo '1000 data *' >>defusr.bas
unix2dos defusr.bas
