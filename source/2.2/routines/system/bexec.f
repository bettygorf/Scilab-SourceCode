      subroutine bexec(vname,nv,ne,ierr)
c     ==========================================================
c     This routine prepare execution of a scilab  instruction given 
c     by a scilab  variable (vector of character strings) within a C 
c     or fortran procedure
c     if ne>0 execute only the ne_th element of the scilab variable
c     ==========================================================
      include '../stack.h'
c     integer sadr,iadr
      integer id(nsiz)
      character*(*) vname
      integer retu(6),comma,eol
c
      data retu/27,14,29,30,27,23/,comma/52/,eol/99/
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      ierr=0
      if (ddt .eq. 4) then
         write(buf(1:12),'(i4)') top
         call basout(io,wte,' bexec  top:'//buf(1:4))
      endif
      mrhs=0
      fin=0
      call cvname(id,vname(1:nv),0)
      call stackg(id)
      if(fin.eq.0) then
         call cvname(id,buf,1)
         call basout(io,wte,'Warning:undefined variable : '//
     $        buf(1:nlgh))
         ierr=1
         return
      endif
      il=iadr(lstk(top))
      if(istk(il).ne.10) then 
         call basout(io,wte,'Variable associated with a button '//
     +        'must be character string')
         ierr=1
         return
      endif
      l=il+5+istk(il+1)*istk(il+2)
      if(ne.gt.0) then
c     extract element #ne
         if(istk(il+1)*istk(il+2).lt.ne) then
            call basout(io,wte,'Undefined action associated with '//
     +        'this submenu')
            ierr=1
            return
         endif
         le=l+istk(il+3+ne)-1
         me=istk(il+4+ne)-istk(il+3+ne)
         istk(il+1)=1
         istk(il+2)=1
         istk(il+5)=1+me
         call icopy(me,istk(le),1,istk(il+6),1)
         l=il+6
      endif
      l1=l+istk(l-1)-1
      istk(l1)=comma
      l1=l1+1
      call icopy(6,retu,1,istk(l1),1)
      l1=l1+6
      istk(l1)=comma
      l1=l1+1
      istk(l1)=eol
      l1=l1+1
      istk(l1)=eol
      istk(l-1)=istk(l-1)+10
      lstk(top+1)=sadr(l1)+1
      fin=lstk(top)
      return
      end
