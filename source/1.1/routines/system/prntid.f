C/MEMBR ADD NAME=PRNTID,SSI=0
      subroutine prntid(id,argcnt)
c
c     print variable names
c
c
      include '../stack.h'
      integer id(nsiz,*),argcnt
      integer equal
      data equal/50/
c
      nl=(lct(5)-1)/10
      j1 = 1
   10 j2 = min(j1+nl-1,abs(argcnt))
      l = 2
      buf(1:1)=' '
      do 15 j = j1,j2
      call cvname(id(1,j),buf(l:l+nlgh-1),1)
      l=l+nlgh
      buf(l:l+1)='  '
      l=l+2
   15 continue
      l=l-1
      if (argcnt .eq. -1) l=l+1
      if (argcnt .eq. -1) buf(l:l) = alfa(equal+1)
      call basout(io,wte,buf(1:l))
      if(io.eq.-1)  return
   21 j1 = j1+nl
      if (j1 .le. abs(argcnt)) go to 10
      return
      end

