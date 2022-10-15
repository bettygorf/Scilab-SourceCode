      subroutine floyd(lg,n,pg,pig)
      implicit integer (a-z)
      doubleprecision lg(n,n),pig(n,n),infr,z
      dimension pg(n,n)
      infr=10.d6
      infe=32700
      do 10 i=1,n
         do 10 j=1,n
            pg(i,j)=-infe
            pig(i,j)=lg(i,j)
 10      continue
         do 110 k=1,n
            do 105 i=1,n
               if(pig(i,k).ge.infr) goto 105
               if((pig(i,k)+pig(k,i)).lt.0.)goto 990
               do 100 j=1,n
                  z=pig(i,k)+pig(k,j)
                  if(z.ge.pig(i,j))goto 100
                  pig(i,j)=z
                  pg(i,j)=k
 100           continue
 105        continue
 110     continue
         goto 999
 990     continue
         call erro('negative length circuit')
         return
 999     continue
         end
