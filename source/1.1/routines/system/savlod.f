      subroutine savlod(lunit,id,job,nvar)
c ====================================================================
c     Binary save and load of Scilab Objects 
c ====================================================================
      include '../stack.h'
      logical eqid
      integer lunit,id(nsiz),job,h(nsiz),blank
      integer iadr,sadr
      data blank/40/
c
c     lunit = logical unit number
c     id = name, format 4a1
c     nvar  numero d'ordre de la variable dans la pile
c
c
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (job .gt. 0) go to 20
c
c     save
   10 il=iadr(lstk(nvar))
      ilf=iadr(lstk(nvar+1))-1
      write(lunit) id,ilf-il+1
      write(lunit) (istk(i),i=il,ilf)
      return
c
c     load
   20 il=iadr(lstk(nvar))
      if(id(1).eq.blank) goto 25
c
   21 read(lunit,end=31,err=32) h,n
      if(eqid(h,id)) goto 26
c   23 read(lunit,end=30,err=32) (k,i=1,n)
   23 read(lunit,end=30,err=32)
      goto 21
c
   25 read(lunit,end=30,err=32) id,n
   26 if(n-iadr(job).gt.0) call error(17)
      if(err.gt.0) goto 30
      read(lunit,end=30,err=32) (istk(il+i-1),i=1,n)
      lstk(nvar+1)=sadr(il+n)
      return
c
c     end of file
   30 il=iadr(lstk(nvar))
      istk(il)=0
      lstk(nvar+1)=lstk(nvar)+1
      return
c la variable recherchee n'existe pas
   31 call putid(ids(1,pt+1),id)
      call error(102)
      goto 30
c le fichier n'a pas la bonne structure
   32 call error(49)
      goto 30
c
      end
