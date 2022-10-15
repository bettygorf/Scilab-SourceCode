      subroutine tlink(name,job,loc)
c     tlink manages table of dynmaically linked routines
c     name : character string . Name of procedure
c     job  : integer, code of required operation
c            0 : get name in the table returns the procedure position
c                within the table in loc if it exists or 0
c            1 : add name at the end of the procedure table. return the
c                procedure position  within the table in loc if
c                operation ok  or 0  
c            2 : delete name in the table (only if name is in the last
c                position 
c     loc  : integer
c!
      include '../stack.h'
c
      integer job,loc
      character*(*) name
c
      integer it1
c
      if(job.eq.0) then
c     .  look for a name in the table
         it1=nlink+1
 10      it1=it1-1
         if(it1.le.0) goto 20
         if(tablin(it1).ne.name) goto 10
 20      loc=it1
      elseif(job.eq.1) then
c     .  add a name in the table
         if(nlink.ge.maxlnk) then
            loc=0
         else
            nlink=nlink+1
            tablin(nlink)=name
            loc=nlink
         endif
      elseif(job.eq.2) then
c     .  delete a name in the table
         if(nlink.ne.0) then
            if(tablin(nlink).eq.name) then
               nlink=nlink-1
               loc = nlink
            else
               loc=0
            endif
         endif
      endif
c
      return
      end

