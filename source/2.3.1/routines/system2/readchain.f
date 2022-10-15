      subroutine readchain(name,itslen,chai)
c!but
c     this routine reads a string in scilab's  memory
c
c!calling sequence
c
c     integer       itslen
c     character*(*) chai,name
c
c     name    : character string = name of scilab variable (input)
c     chai    : chain to be read (output)
c     itslen  : length of chain  (output)
c     if Scilab variable x='qwert' exists 
c     call readchain('x',l,ch) returns l=5 and ch='qwert'
c
      character*(*) chai,name
      include '../stack.h'
      integer iadr
c
      integer id(nsiz)
c
c
      iadr(l)=l+l-1
c      sadr(l)=(l/2)+1
c
      lon=0
      do 100 i=1,csiz
         if(name(i:i).eq.char(0)) goto 200
         lon=lon+1
 100  continue
 200  continue
      lon1=len(name)
      if((lon1.gt.0).and.(lon1.lt.lon)) then
         ln=lon1
      else
         ln=lon
      endif
      if(lon.eq.lon1) ln=lon
      ln=min(nlgh,ln)
      call cvname(id,name(1:ln),0)
c
      fin=-1
      call stackg(id)
      if(err.gt.0) return
      if(fin.eq.0) call putid(ids(1,pt+1),id)
      if(fin.eq.0) call error(4)
      if(err.gt.0) return
      il=iadr(lstk(fin))
      if(istk(il).ne.10) call error(44)
      if(err.gt.0) return
c
      m=istk(il+1)
      n=istk(il+2)
      if(m.ne.1.and.n.ne.1) then
      buf='readchain: variable is not a valid string'
      call error(9999)
      return
      endif
      l=il+5
      k=l+m*n
      itslen=istk(l)-istk(l-1)
      n1=itslen
      call cvstr(n1,istk(k),chai,1)
      end

