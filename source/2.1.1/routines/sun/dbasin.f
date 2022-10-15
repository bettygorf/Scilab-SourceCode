      subroutine dbasin(ierr,lunit,fmt,v,iv,n)
c ====================================================================
c
c     gestion de la standard input
c
c ================================== ( Inria    ) =============
c
      include '../stack.h'
      character*(*) fmt
      double precision v(*)
      integer ierr,lunit
      character*512 string
c
      ierr=0
      if(lunit.eq.rte) then

         string=' '
         call xscion(iflag)
         if (iflag.eq.0) then 
            call zzledt(string,len(string),lline,status)
         else
            call zzledt1(string,len(string),lline,status)
         endif
         if(status.ne.0) goto 10
         if (lline.eq.0) then
            string(1:1)=' '
            lline=1
	 endif
         if(fmt(1:1).ne.'*') then
            read(string(1:lline),fmt,end=10,err=20) (v(i),i=1,n*iv,iv)
         else
            call s2val(string(1:lline),v,iv,n1,n,ierr)
            if(ierr.ne.0) goto 20
            if(n1.lt.n) goto 10
c            read(string(1:lline),*,end=10,err=20) (v(i),i=1,n*iv,iv)
         endif
      else

         if(fmt(1:1).ne.'*') then
            read(lunit,fmt,end=10,err=20) (v(i),i=1,n*iv,iv)
         else
            read(lunit,*,end=10,err=20) (v(i),i=1,n*iv,iv)
         endif
      endif
c
      return
c
 10   ierr=1
      return
 20   ierr=2
      return
      end
      subroutine s2val(str,v,iv,n,maxv,ierr)
c!but
c     emulation d'une lecture "list-directed" de fortran sur une
c     chaine de caractere
c!
      double precision v(iv,maxv),vv
      character*(*) str
      character*1 si
      logical del
c
      ls=len(str)
      del=.true.
c
      ierr=0
      n0=n
      n=0
      i=0
 10   i=i+1
      if(i.gt.ls) goto 20
      si=str(i:i)
      if(si.eq.'/'.or.si.eq.',') then
         if(del) then
            if(n+1.gt.maxv) return
            v(1,n+1)=0.0d0
            n=n+1
            goto 10
         else
            del=.true.
         endif
      endif
      if(si.ne.' '.and.si.ne.'/'.and.si.ne.',') then
         call nextv(str(i:),vv,nv,ir,ierr)
         if(ierr.ne.0) return
         if(n+nv.gt.maxv) nv=maxv-n
         if(nv.le.0)  return
         call dset(nv,vv,v(1,n+1),iv)
         n=n+nv
         i=i+ir-2
         del=.false.
      endif
      goto 10
 20   continue 
      if(del) then
         if(n+1.gt.maxv) return
         v(1,n+1)=0.0d0
         n=n+1
      endif
      return
      end

      subroutine nextv(str,v,nv,ir,ierr)
      character*(*) str
      character*1 si
      double precision v,v1,v2,v3,d
      logical expn,fact,dec

      ls=len(str)
      v=0.0d0
      v1=0.0d0
      v2=0.0d0
      v3=0.0d0
      d=10.0d0
      expn=.false.
      fact=.false.
      dec=.false.
      
      i=0
 10   i=i+1
      if(i.gt.ls) goto 20
      si=str(i:i)
      if(si.eq.'0') then
         v=d*v
      elseif(si.eq.'1') then
         v=d*v+1.0d0
      elseif(si.eq.'2') then
         v=d*v+2.0d0
      elseif(si.eq.'3') then
         v=d*v+3.0d0
      elseif(si.eq.'4') then
         v=d*v+4.0d0
      elseif(si.eq.'5') then
         v=d*v+5.0d0
      elseif(si.eq.'6') then
         v=d*v+6.0d0
      elseif(si.eq.'7') then
         v=d*v+7.0d0
      elseif(si.eq.'8') then
         v=d*v+8.0d0
      elseif(si.eq.'9') then
         v=d*v+9.0d0
      elseif(si.eq.'d'.or.si.eq.'D'.or.
     $        si.eq.'e'.or.si.eq.'E') then
         if(expn.or.fact) then 
            ierr=2
            return
         endif
         expn=.true.
         v1=v
         v=0.0d0
      elseif(si.eq.'*') then
         if(expn.or.fact) then 
            ierr=2
            return
         endif
         fact=.true.
         v2=v
         v=0.0d0
      elseif(si.eq.'.') then
         if(expn.or.dec) then 
            ierr=2
            return
         endif
         dec=.true.
         v3=v
         v=0.0d0
      elseif(si.eq.' '.or.si.eq.','.or.si.eq.'/') then
         goto 20
      else
         ierr=2
         return
      endif
      goto 10
 20   nv=1
      ir=i
      if(fact) nv=int(v2)
      if(dec) then
         if(v.eq.0.0d0) then
            v=v3
         else
            nd=int(log(v)/log(10.0d0))+1
            v=v3+v*10.0d0**(-nd)
         endif
      endif
      if(expn) v=v1*10.0d0**int(v)


      end

