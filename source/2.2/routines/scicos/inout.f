      subroutine inout(told,x0,outtb,inpptr,outptr,stptr,
     &     cmat,funptr,rpar,rptr,ipar,iptr,ninp,nout,
     &     ord,nord,w,nblk,ierr)
      double precision told
      integer inpptr(*)
      integer outptr(*)
      integer stptr(*)
      integer ninp,nout,nord,nblk
      integer cmat(ninp)
      double precision rpar(*)
      integer rptr(*)
      integer ipar(*)
      integer iptr(*)
      integer funptr(*)
      integer ord(*)
      integer flag

      double precision outtb(nout)
      integer ierr
      integer ksz,jj,j
      double precision x0(*)
      double precision w(*),t1
C   

      do 2 jj=1,nord
         kfun=ord(jj)
         ksz = inpptr(kfun+1) - inpptr(kfun)
         if(ksz.gt.0) then
            do 1 j=1,ksz
               w(j)=outtb(cmat(inpptr(kfun)-1+j))
 1          continue
         endif
         flag=1
         t1=told
         call callf(funptr(kfun),told,
     &        x0(stptr(kfun)),stptr(kfun+1)-stptr(kfun),
     &        x0(stptr(kfun+nblk)),stptr(kfun+1+nblk)-stptr(kfun+nblk),
     &        w,ksz,0,
     &        rpar(rptr(kfun)),rptr(kfun+1)-rptr(kfun),
     &        ipar(iptr(kfun)),iptr(kfun+1)-iptr(kfun),
     &        outtb(outptr(kfun)),outptr(kfun+1)-outptr(kfun),
     &        flag)
         if(flag.lt.0) then
            ierr=5-flag
            return
         endif
 2    continue
      end


