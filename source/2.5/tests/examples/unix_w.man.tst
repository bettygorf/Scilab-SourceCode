clear;lines(0);
if MSDOS then unix_w("dir "+WSCI+"\demos");
else unix_w("ls $SCI/demos"); end
