      subroutine grblk(neq,t,xc,ng1,z)
C 
C.. Formal Arguments .. 
      integer neq(*)
      double precision t
      double precision xc(*)
      integer ng1
      double precision z(ng1)
C 
C 
C.. External Calls .. 
      external grblk1
C 
C.. Common Blocks .. 
C... Variables in Common Block ... 
      integer lrpar,lrptr,lipar,liptr,louttb,lcmat,lrhot,linppt,loutpt,
     &        lstpt,lfunpt,lihot,ljroot,lclkpt,lcord,loord,lzord
      common /cosptr/ lrpar,lrptr,lipar,liptr,louttb,lcmat,lrhot,linppt,
     &                loutpt,lstpt,lfunpt,lclkpt,lihot,ljroot,lww,lcord,
     &                loord,lzord
C
C... Variables in Common Block ... 
      integer nblk,nxblk,ncblk,ndblk,nout,ncout,ninp,ncinp,ncst,ng,nrwp,
     &     niwp,ncord,niord,noord,nzord
      common /cossiz/ nblk,nxblk,ncblk,ndblk,nout,ncout,ninp,ncinp,
     &     ncst,ng,nrwp,niwp,ncord,niord,noord,nzord
C 
C ... Executable Statements ...
C 
      call grblk1(t,ncblk,ndblk,nzord,neq(lzord),xc(lww),nout,xc,
     &            xc(louttb),neq(linppt),neq(loutpt),neq(lstpt),
     &            neq(lclkpt),ncst,ncout,ncinp,neq(lcmat),neq(lfunpt),
     &            xc(lrpar),neq(lrptr),neq(lipar),neq(liptr),nblk,ninp,
     &            z,ng)
      end
C
      subroutine grblk1(told,ncblk,ndblk,nzord,zord,w,nout,xc,outtb,
     &                  inpptr,outptr,stptr,clkptr,ncst,ncout,ncinp,
     &                  cmat,funptr,rpar,rpptr,ipar,ipptr,nblk,ninp,z,ng
     &                 )
C 
C.. Formal Arguments .. 
      double precision told
      integer ncblk
      integer ndblk
      integer nout
      double precision xc(*)
      double precision outtb(*)
      double precision w(*)
      integer inpptr(nblk+1)
      integer outptr(nblk+1)
      integer stptr(*)
      integer clkptr(nblk+1)
      integer zord(*)
      integer ncst
      integer ncout
      integer ncinp
      integer cmat(ninp)
      integer funptr(nblk)
      double precision rpar(*)
      integer rpptr(nblk+1)
      integer ipar(*)
      integer ipptr(nblk+1)
      integer nblk
      integer ninp
      double precision z(ng)
      integer ng
C 
C.. Local Scalars .. 
      integer iz,i
C 
C.. External Calls .. 
      external inout
C 
C ... Executable Statements ...
C
      iero = 0
      call inout(told,xc,outtb,inpptr,outptr,stptr,cmat,funptr,rpar,
     &           rpptr,ipar,ipptr,ninp,nout,zord,nzord,w,nblk,iero)
      if (iero .ne. 0) return
C
      iz=1
      do 99 i = inpptr(ncblk+ndblk+1),inpptr(nblk+1)-1
         z(iz) = outtb(cmat(i))
         iz=iz+1
 99   continue
      end

