      subroutine simblk(neq,t,xc,xcdot)
C 
      integer neq(*)
      double precision t
      double precision xc(*)
      double precision xcdot(*)
C 
C.. External Calls .. 
      external simbl1
C 
C... Variables in Common Block ... 
      integer lrpar,lrptr,lipar,liptr,louttb,lcmat,lrhot,linppt,loutpt,
     &        lstpt,lfunpt,lihot,ljroot,lclkpt,lcord,loord,lzord
      common /cosptr/ lrpar,lrptr,lipar,liptr,louttb,lcmat,lrhot,linppt,
     &                loutpt,lstpt,lfunpt,lclkpt,lihot,ljroot,lww,lcord,
     &                loord,lzord
C 
C 
C... Variables in Common Block ... 
      integer nblk,nxblk,ncblk,ndblk,nout,ncout,ninp,ncinp,ncst,ng,nrwp,
     &     niwp,ncord,niord,noord,nzord
      common /cossiz/ nblk,nxblk,ncblk,ndblk,nout,ncout,ninp,ncinp,
     &     ncst,ng,nrwp,niwp,ncord,niord,noord,nzord
C 
C ... Executable Statements ...
C 
      call simbl1(t,nxblk,ncblk,nout,noord,neq(loord),xc(lww),xc,
     &            xc(louttb),neq(linppt),neq(loutpt),neq(lstpt),ncst,
     &            ncout,ncinp,neq(lcmat),neq(lfunpt),xc(lrpar),
     &            neq(lrptr),neq(lipar),neq(liptr),nblk,ninp,xcdot)
      end
C
C
C
      subroutine simbl1(told,nxblk,ncblk,nout,noord,oord,w,xc,outtb,
     &                  inpptr,outptr,stptr,ncst,ncout,ncinp,cmat,
     &                  funptr,rpar,rpptr,ipar,ipptr,nblk,ninp,xcdot)
C 
      double precision told
      integer ncblk,nxblk
      integer nout
      double precision xc(*),w(*)
      double precision outtb(*)
      integer inpptr(nblk+1)
      integer outptr(nblk+1)
      integer stptr(*)
      integer ncst
      integer ncout
      integer noord
      integer ncinp
      integer oord(noord)
      integer cmat(ninp)
      integer funptr(nblk)
      double precision rpar(*)
      integer rpptr(nblk+1)
      integer ipar(*)
      integer ipptr(nblk+1)
      integer nblk
      integer ninp
      double precision xcdot(ncst)
      integer iero
      common /ierode/ iero
C 
C.. Local Scalars .. 
      integer i,flag
C 
C ... Executable Statements ...
C 
      iero = 0
      call inout(told,xc,outtb,inpptr,outptr,stptr,cmat,funptr,rpar,
     &           rpptr,ipar,ipptr,ninp,nout,oord,noord,w,nblk,iero)
      if (iero .ne. 0) return
      nclock = 0
      do 100 i = 1,nxblk
        ksz = inpptr(i+1) - inpptr(i)
        do 99 j = 1,ksz
          w(j) = outtb(cmat(inpptr(i)-1+j))
 99     continue
        flag = 2
        call callf(funptr(i),told,xc(stptr(i)),stptr(i+1)-stptr(i),
     &   xc(stptr(i+nblk)),stptr(i+1+nblk)-stptr(i+nblk),w,
     &             inpptr(i+1)-inpptr(i),nclock,rpar(rpptr(i)),
     &             rpptr(i+1)-rpptr(i),ipar(ipptr(i)),
     &             ipptr(i+1)-ipptr(i),xcdot(stptr(i)),
     &             stptr(i+1)-stptr(i),flag)
        if (flag .lt. 0) then
          iero = 5 - flag
          return
        endif
 100  continue
      end

