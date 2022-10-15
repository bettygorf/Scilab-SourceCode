
      subroutine savlod(lunit,id,job,nvar)
c ====================================================================
c     Binary save and load of Scilab Objects 
c ====================================================================
      include '../stack.h'
      integer blank
      parameter (blank=40)
      logical eqid
      integer lunit,id(nsiz),job,h(nsiz)
      integer iadr,sadr
      integer nsiz1
c
c     lunit = logical unit number
c     id = name, format 4a1
c     nvar  variable number in the stack
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (job .gt. 0) go to 20
c
c     save
   10 il=iadr(lstk(nvar))
      ilf=iadr(lstk(nvar+1))-1
      write(lunit,err=32) id,ilf-il+1
      write(lunit,err=32) (istk(i),i=il,ilf)
      return
c
c     load
   20 continue
      nsiz1=nsiz
      il=iadr(lstk(nvar))
      if(id(1).eq.blank) goto 25
c
   21 read(lunit,end=31,err=32) (h(i),i=1,nsiz1),n
   22 if(eqid(h,id)) goto 26
      read(lunit,end=30,err=32)
      goto 21
c
   25 read(lunit,end=30,err=32)  (h(i),i=1,nsiz1),n
   26 if(n-iadr(job).gt.0) call error(17)
      if(err.gt.0) goto 30
      read(lunit,end=30,err=32) (istk(il+i-1),i=1,n)
      lstk(nvar+1)=sadr(il+n)
      call putid(id,h)
      return
c
c     end of file
   30 il=iadr(lstk(nvar))
      istk(il)=0
      lstk(nvar+1)=lstk(nvar)+1
      return
c     looked for Variable does not exist
   31 call putid(ids(1,pt+1),id)
      call error(102)
      goto 30
c     file has an incorrect structure
   32 call error(49)
      goto 30

      end
