      subroutine cosini(x0,told,inpptr,outptr,stptr,clkptr,
     &     rpar,rptr,ipar,iptr,funptr,ierr)
C     
C     
C..   Formal Arguments .. 
      double precision x0(*)
      double precision told
      integer inpptr(*)
      integer outptr(*)
      integer stptr(*)
      integer clkptr(*)
      double precision rpar(*)
      integer rptr(*)
      integer ipar(*)
      integer iptr(*)
      integer funptr(*)
      integer flag,ierr
c
      double precision out
      double precision w
C     
C..   Common Blocks .. 
C...  Variables in Common Block ... 
      integer nblk,nxblk,ncblk,ndblk,nout,ncout,ninp,ncinp,ncst,ng,nrwp,
     &     niwp,ncord,niord,noord,nzord
      common /cossiz/ nblk,nxblk,ncblk,ndblk,nout,ncout,ninp,ncinp,
     &     ncst,ng,nrwp,niwp,ncord,niord,noord,nzord
C     ... Executable Statements ...
C     
      ierr = 0
C     initialization
C     loop on blocks
      do 10 kfun=ncblk+1,ncblk+ndblk
         flag=4
         ksz = inpptr(kfun+1) - inpptr(kfun)
         call callf(funptr(kfun),told,
     &        x0(stptr(kfun)),stptr(kfun+1)-stptr(kfun),
     &        x0(stptr(kfun+nblk)),stptr(kfun+1+nblk)-stptr(kfun+nblk),
     &        w,0,0,
     &        rpar(rptr(kfun)),rptr(kfun+1)-rptr(kfun),
     &        ipar(iptr(kfun)),iptr(kfun+1)-iptr(kfun),
     &        out,0,flag)
         if(flag.lt.0) then
            ierr=5-flag
            return
         endif
 10   continue
      end      
