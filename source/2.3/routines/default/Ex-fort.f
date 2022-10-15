c -----------------------
c Scilab command:
c  [y1,y2,...,ym]=fort('routinename',x1,x2,...,xn)
c  the input variables xi's and the output variables yi's
c  are (matrices) of integers, real or double (or strings).
c
c  the utility function msize allows to recover the dimensions of the matrices
c  passed by the "fort":
c  the command i.e. ivol=msize(i,nr,nc) gives the number of rows
c  nr and columns nc of the matrix "xi" and ivol=nr*nc.
c  i is input to msize and ivol,nr,nc are outputs.
c  
c
c  Utility function alloc allocates memory and sets types of variables.
c     call alloc(nvar,ivol,nr,nc,type)
c     nvar = variable number 
c     ivol =  volume as a fortran variable = nr x nc
c     nr = number of rows
c     nc = number of columns
c     type =  'd' for double precision
c          =  'r' for real (float)
c          =  'i' for integer
c          =  'c' for chain (character string)
c
c  nvar,ivol,nr,nc,type are inputs to alloc.
c
c  If the parameter 'out' is not among the parameters of fort,
c  one call to alloc for each output variable is necessary.
c  
c  call back(no) means: variable # no is an output variable
c   
c         foobar1 is the interface program for foubare called by
c         -->mul=str2code('mul')
c         -->x=[1,2,3];y=x;z=x;
c         -->[a,b,c,d]=fort('foobar1',mul,x,y,z)
c     -----------------------------------------
      subroutine foobar1()
      include '../stack.h'
c retrieving dimensions of variables # 1,2,3,4 (ch,x,y,z) sent by fort
      lch= msize(1,nrch,ncch)
      ix= msize(2,nrx,ncx)
      iy= msize(3,nry,ncy)
      iz= msize(4,nrz,ncz)
c lch=3 (length of 'mul')   ix=iy=iz=3
c nrch=3, nlch=1;  nrx=nry=nrz=1; ncx=ncy=ncz=3;
c    
c allocating place in the internal stack and defining type
      call alloc(1,lch,nrch,ncch,'c')
      call alloc(2,ix,nrx,ncx,'i')
      call alloc(3,iy,nry,ncy,'r')
      call alloc(4,iz,nrz,ncz,'d')
      call alloc(5,iz,nrz,ncz,'d')
      call alloc(6,iz,nrz,ncz,'d')
c ladr(1),ladr(2),ladr(3),ladr(4),ladr(5),ladr(6) are pointers
c in stk() to (ch,x,y,z,d,w) resp. 
c calling the routine
      call foubare(stk(ladr(1)),stk(ladr(2)),ix,stk(ladr(3)),iy,
     +            stk(ladr(4)),nrz,ncz,stk(ladr(5)),stk(ladr(6)),junk)
c return of output variables (in increasing order) located
c at (ladr(2),ladr(3),ladr(4),ladr(5)) resp. i.e (a,b,c,d) resp.
      call back(2)
      call back(3)
      call back(4)
      call back(5)
      return
      end
c
c -------------------------------------
c test mixed form (test # 3 in fort.tst)
c -------------------------------------
c scilab command:
c
c [a,b,c,d]=fort('foobar3',x,1,'i',y,2,'r',z,3,'d','out',1,2,3,4)
c
c alloc for d and w variables which are not set by fort
c no call to back since 'out' exists.
c
      subroutine foobar3()
      include '../stack.h'
c   retrieving dimensions of input variables 1,2,3 (x,y,z)
      ix=msize(1,nrx,ncx)
      iy=msize(2,nry,ncy)
      iz=msize(3,nrz,ncz)
c   defining variables 4 and 5 (d and w in foubare)
      call alloc(4,iz,nrz,ncz,'d')
      call alloc(5,iz,nrz,ncz,'d')
      call foubare('mul',stk(ladr(1)),ix,stk(ladr(2)),iy,
     +              stk(ladr(3)),nrz,ncz,stk(ladr(4)),stk(ladr(5)),junk)
      return
      end

      subroutine foubare(ch,a,ia,b,ib,c,mc,nc,d,w)
c     -----------------------------------------
c     -----------   EXAMPLE   -----------------
c     inputs:  ch, a,b and c; ia,ib and mc,nc
c     ch=character, a=integer, b=real and c=double 
c     ia,ib and [mc,nc] are the dimensions of a,b and c resp.
c     outputs: a,b,c,d
c     if ch='mul'   a,b and c = 2 * (a,b and c) 
c     and d of same dimensions as c with
c     d(i,j)=(i+j)*c(i,j)
c     if ch='add' a,b and c = 2 + (a,b and c)
c     d(i,j)=(i+j)+c(i,j)
c     w is a working array of size [mc,nc]
c     -------------------------------------------
      character*(*) ch
      integer a(*)
      real b(*)
      double precision c(mc,*),d(mc,*),w(mc,*)
      if(ch(1:3).eq.'mul') then
      do 1 k=1,ia
         a(k)=2*a(k)
 1    continue
      do 2 k=1,ib
         b(k)=2.0*b(k)
 2    continue
      do 3 i=1,mc
      do 3 j=1,nc
         c(i,j)=2.0d0*c(i,j)
 3    continue
      do 4 i=1,mc
      do 4 j=1,nc
       w(i,j)=dble(i+j)
       d(i,j)=w(i,j)*c(i,j)
 4    continue
      elseif(ch(1:3).eq.'add') then
      do 10 k=1,ia
         a(k)=2+a(k)
 10   continue
      do 20 k=1,ib
         b(k)=2.0+b(k)
 20   continue
      do 30 i=1,mc
      do 30 j=1,nc
         c(i,j)=2.0d0+c(i,j)
 30   continue
      do 40 i=1,mc
      do 40 j=1,nc
       w(i,j)=dble(i+j)
       d(i,j)=w(i,j)+c(i,j)
 40   continue
      endif
      end

