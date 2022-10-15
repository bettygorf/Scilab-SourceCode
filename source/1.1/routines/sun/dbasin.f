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
         call zzledt(string,len(string),lline,status)
         if(status.ne.0) goto 10
         if (lline.eq.0) then
            string(1:1)=' '
            lline=1
	 endif
         if(fmt(1:1).ne.'*') then
            read(string(1:lline),fmt,end=10,err=20) (v(i),i=1,n*iv,iv)
         else
            read(string(1:lline),*,end=10,err=20) (v(i),i=1,n*iv,iv)
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
