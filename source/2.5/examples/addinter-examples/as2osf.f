      subroutine as2osf(str)
c     do not use len with str 
      character str*(*)
      integer l 
      do 10 i = 1,len(str)
         if ( str(i:i).eq.'a') str(i:i)='o'
 10   continue
      return
      end 













