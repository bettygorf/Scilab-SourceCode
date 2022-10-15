      subroutine namstr(id,str,n,job)
c     
c     converti un nom code scilab en une chaine scilab
c     
c
      include '../stack.h'
      integer id(nsiz),ch,blank
      integer str(nlgh)
      data blank/40/
c     
      if(job.eq.0) goto 20
      id1=id(1)
      id2=id(2)
      do 10 i=1,nlgh/2
         k=id1/256
         ch=id1-256*k
         if(ch.eq.blank) then
            n=i-1
            return
         endif
         id1=k
         str(i)=ch
 10   continue
      do 11 i=nlgh/2+1,nlgh
         k=id2/256
         ch=id2-256*k
         if(ch.eq.blank) then
            n=i-1
            return
         endif
         id2=k
         str(i)=ch
 11   continue
      return
c     
 20   continue
      id(1)=0
      id(2)=0
      do 22 i=1,nlgh/2
         ii=nlgh/2+1-i
         if(ii.le.n) then
            id(1)=256*id(1)+abs(str(ii))
         else
            id(1)=256*id(1)+blank
         endif
 22   continue
      do 23 i=1,nlgh/2
         ii=nlgh+1-i
         if(ii.le.n) then
            id(2)=256*id(2)+abs(str(ii))
         else
            id(2)=256*id(2)+blank
         endif
 23   continue
      return
      end
