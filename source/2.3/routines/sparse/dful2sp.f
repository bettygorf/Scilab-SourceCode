      subroutine dful2sp(ma,na,a,nel,indr,r)
c     converts a full matrix to a sparse representation
      double precision a(ma,na),r(*)
      integer indr(*)
c
      nel=0
      do 5 i=1,ma
         ni=0
         do 4 j=1,na
            if(abs(a(i,j)).ne.0.0d0) then
               nel=nel+1
               indr(ma+nel)=j
               r(nel)=a(i,j)
               ni=ni+1
            endif
 4       continue
         indr(i)=ni
 5    continue
      end
