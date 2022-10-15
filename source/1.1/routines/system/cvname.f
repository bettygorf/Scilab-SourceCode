      subroutine cvname(id,str,job)
c     =====================================
c     Scilab internal coding of vars to string 
c     =====================================
      include '../stack.h'
      integer id(nsiz),name(nlgh),ch
      character*(*) str
c
      if(job.ne.0) then 
         id1=id(1)
         id2=id(2)
         do 10 i=1,nlgh/2
            k=id1/256
            ch=id1-256*k
            id1=k
            str(i:i)=alfa(ch+1)
 10      continue
         do 11 i=nlgh/2+1,nlgh
            k=id2/256
            ch=id2-256*k
            id2=k
            str(i:i)=alfa(ch+1)
 11      continue
      else
         call cvstr(nlgh,name,str,0)
         id(1)=0
         id(2)=0
         do 21 i=1,nlgh/2
            id(1)=256*id(1)+abs(name(nlgh/2+1-i))
            id(2)=256*id(2)+abs(name(nlgh+1-i))
 21      continue
      endif
      return
      end

      subroutine cvnamel(id,str,job,l)
c     =====================================
c     Scilab internal coding of vars to string 
c      plus elimination of trailing blank
c     =====================================
      include '../stack.h'
      integer id(nsiz),job,l
      character*(*) str
      call cvname(id,str,job)
      if (job.eq.1) then 
         l=1+nlgh
 42      l=l-1
         if(str(l:l).eq.' ') goto 42
      endif
      return
      end







