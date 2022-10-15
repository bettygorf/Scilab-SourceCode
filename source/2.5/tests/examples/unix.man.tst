clear;lines(0);
unix("ls $SCI/demos");
deff('wd=dir()','if MSDOS then unix(''cd>''+TMPDIR+''\path'');..
                else unix(''pwd>''+TMPDIR+''/path'');end..
      wd=read(TMPDIR+''/path'',1,1,''(a)'')')
wd=dir()
