      subroutine ffuncex(x,nx,y,ny,z,f)
c     Copyright INRIA
      double precision x(*),y(*),z(nx,ny),zz
      integer nx,ny
      external f
      do 1 i=1,nx
      do 1 j=1,ny
      call f(x(i),y(j),zz)
      z(i,j)=zz
  1   continue
      end

      subroutine fp1(x,y,z) 
      double precision x,y,z
      z=x+y
      end

      subroutine fp2(x,y,z)
      double precision x,y,z
      z=x*x+y*y
      end

