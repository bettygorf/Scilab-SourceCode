      subroutine interf(x1 ,x2 ,x3 ,x4 ,x5 ,x6 ,x7 ,x8 ,x9 ,x10,
     $                  x11,x12,x13,x14,x15,x16,x17,x18,x19,x20,
     $                  x21,x22,x23,x24,x25,x26,x27,x28,x29,x30)
c!
c
c Calling fortran from scilab
c This file can be customized according to your needs...
c see also "fort" in the directory /tests
c
c!
c! example
c
c Calling the following routine:
c
c      subroutine bidon(a,ia,b,ib,c,ic,d,w,nw)
ccc     computes stupid quantities for testing "fort"
c      dimension a(*),b(*),c(*),d(*),w(nw)
c      integer a
c      real b
c      double precision c,d,w(nw)
c      do 1 k=1,ia
c      a(k)=2*a(k)
c   1  continue
c      do 2 k=1,ib
c      b(k)=2.*b(k)
c  2   continue
c      do 3 k=1,ic
c      c(k)=2.0d+0*c(k)
c   3  continue
c      return
c      do 4 k=1,ic
c      w(k)=dble(real(k))
c      d(k)=w(k)+c(k)
c  4   continue
c      end
c
c  Calling the routine by the command:
c   [a,b,c,d]=fort('bidon',a,1,'i',b,2,'r',c,3,'d',...
c                  'out',1,2,3,4)
c  or after uncommenting some lines below (see below):
c
c    [a,b,c,d]=fort('bidon',x,y,z)
c
c!
c the xi's variables are (matrices) of integers, real or double precision
c
c the utility function size allows to recover the sizes of the matrices
c passed by the "fort" command i.e. size(i,nl,nc) gives the number of rows
c nl and columns nc of the matrix "xi" and size=nl*nc.
c
c If a variable has no dimensions  (output variable or working matrix)
c it must be dimensionned by calling the utility function alloc.
c   Here 4 corresponds to its number in "fort",
c      ic   volume as a fortran variable.
c      nlc  number of rows
c      ncc  number of columns
c     'd'   type with the meaning   : 'd'=double precision
c                                     'r'=real
c                                     'i'=integer
c one call to alloc for each output variable is necessary.
c c
c the routine "entier" converts integer variables
c the routine "simple" converts real (single precision) variables.
c call back(no) means a=output variable # ll(no)
c!
c
      double precision x1 (*),x2 (*),x3 (*),x4 (*),x5 (*),x6 (*)
      double precision x7 (*),x8 (*),x9 (*),x10(*),x11(*),x12(*)
      double precision x13(*),x14(*),x15(*),x16(*),x17(*),x18(*)
      double precision x19(*),x20(*),x21(*),x22(*),x23(*),x24(*)
      double precision x25(*),x26(*),x27(*),x28(*),x29(*),x30(*)
      include '../stack.h'
      integer size
      integer ia,ib,ic,nca,ncb,ncc,nla,nlb,nlc,it1
c
      character*6    name,nam1
      common /inter/ name
      common /adre/ lbot,ie,is,ipal,nbarg,ll(30)
c JPC
c      character*512 buf1, buf2,buf0
      call majmin(6,name,nam1)
c -----------------------
c example
c -----------------------
c
      if(nam1.eq.'bidon') then
c sizes of variables
      ia= size(1,nla,nca)
      ib= size(2,nlb,ncb)
      ic= size(3,nlc,ncc)
c allocating place in the internal stack
      call alloc(1,ia,nla,nca,'i')
      call alloc(2,ib,nlb,ncb,'r')
      call alloc(3,ic,nlc,ncc,'d')
      call alloc(4,ic,nlc,ncc,'d')
      call alloc(5,ic,nlc,ncc,'d')
c calling the routine
      call bidon(stk(ll(1)),ia,stk(ll(2)),ib,stk(ll(3)),ic,
     +           stk(ll(4)),stk(ll(5)),ic)
c return of output variables
      call back(1)
      call back(2)
      call back(3)
      call back(4)
      return
      endif
c
c --------------------------------------------
c brief form (see test 1 in fort.tst)
c --------------------------------------------
c call in scilab is [a,b,c,d] = fort('bidon',x,y,z)
c
c one call to alloc for each variable
c  call back(no) means: a = output variable # ll(no)
c
      if(nam1.eq.'bidon1') then
c size of variables sent by "fort"
      ia= size(1,nla,nca)
      ib= size(2,nlb,ncb)
      ic= size(3,nlc,ncc)
c allocating space in internal stack
      call alloc(1,ia,nla,nca,'i')
      call alloc(2,ib,nlb,ncb,'r')
      call alloc(3,ic,nlc,ncc,'d')
      call alloc(4,ic,nlc,ncc,'d')
      call alloc(5,ic,nlc,ncc,'d')
c call routine
      call bidon(stk(ll(1)),ia,stk(ll(2)),ib,stk(ll(3)),ic,
     +           stk(ll(4)),stk(ll(5)),ic)
c return of output variables
      call back(1)
      call back(2)
      call back(3)
      call back(4)
      return
      endif
c
c --------------------------------------------
c test of long form (test #2 in fort.tst)
c --------------------------------------------
c scilab command :
c
c [a,b,c,d]=fort(...
c      'bidon2',x,1,'i',ix,2,'i',y,3,'d',iy,4,'i',z,5,'d',iz,6,'i',...
c      'out',[mx,nx],1,'i',[my,ny],3,'r',[mz,nz],5,'d',...
c             [mz,nz],7,'d',[1,1],8,'i')
c
c or in brief form :
c
c [a,b,c,d]=fort(...
c      'bidon2',x,1,'i',ix,2,'i',y,3,'d',iy,4,'i',z,5,'d',iz,6,'i',...
c      'out',1,3,5,[mz,nz],7,'d',[1,1],8,'i')
c
      if(nam1.eq.'bidon2') then
         call bidon(x1,x2,x3,x4,x5,x6,x7,x8,x6)
         return
      endif
c
c -------------------------------------
c test  mixed form (test # 3 in fort.tst)
c -------------------------------------
c scilab command:
c
c [a,b,c,d]=fort('bidon3',x,1,'i',y,2,'r',z,3,'d',...
c                'out',1,2,3,4)
c
      if(nam1.eq.'bidon3') then
       ia=size(1,nla,nca)
       ib=size(2,nlb,ncb)
       ic=size(3,nlc,ncc)
       call alloc(4,ic,nlc,ncc,'d')
       call alloc(5,ic,nlc,ncc,'d')
       call bidon(stk(ll(1)),ia,stk(ll(2)),ib,stk(ll(3)),ic,
     +            stk(ll(4)),stk(ll(5)),ic)
       call back(1)
       call back(2)
       call back(3)
       call back(4)
       return
      endif
c
c                   *******************************
c                   *  JPC TDINFO
c                   *******************************
C        competing
      if (nam1.eq.'icomp') then
        call icomp(x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12)
        return
      endif
C         lorentz
      if (nam1.eq.'loset') then
        call loset(x1,x2,x3)
        return
      endif
C        arnold
      if (nam1.eq.'arset') then
        call arset(x1)
        return
      endif
      if (nam1.eq.'int') then
        call inttest(x1)
        return
      endif
c
c                   *******************************
c                   *  ICSE  -  optimal  control*
c                   *******************************
c
      if (nam1.eq.'icse0') then
        call icse0(x1 ,x2 ,x3 ,x4 ,x5 ,x6 ,x7 ,x8 ,x9 ,x10,
     +             x11,x12,x13,x14,x15,x16,x17,x18,x19,x20,
     +             x21,x22,x23,x24)
        return
      endif
      if (nam1.eq.'icse') then
        call icse(x1,x2,x3,x4,x5,x6,x7,x8)
        return
      endif
      if (nam1.eq.'icscof') then
        call icscof(x1,x2,x3,x4,x5,x6,x7)
        return
      endif
c
c ----------------------------------
c  dynamic link
c ----------------------------------
c
c     dynamic link
      call tlink(name,0,it1)
      if(it1.le.0) goto 2000
      call dyncall(it1-1, x1, x2, x3, x4, x5, x6, x7, x8, x9,x10,
     +                   x11,x12,x13,x14,x15,x16,x17,x18,x19,x20,
     +                   x21,x22,x23,x24,x25,x26,x27,x28,x29,x30)
cc fin
      return
c
c ------
c error.....
c ------
c
 2000 buf=name
      call error(50)
      return
      end

C---------------------------------------------------------
C     character strings are transmitted as integers
C     -> fort(.....,'chain','i')
C     both chains 'sort' and 'out' are forbidden!!!
C---------------------------------------------------------
      subroutine fortstring(x0,string)
      integer x0(*)
      character*(*) string
      integer i,i1
      i1=x0(2)-1 
      if ( i1.ge.1 .and. i1.le.512 ) goto 10 
      write(06,*) 'chain transmission problem in fort'
      write(06,*) 'chain is replaced by foo'
      string = 'bug'//char(0)
      return
 10   call sascii(i1,x0(3),1)
      do 20 i=1,i1
         string(i:i)=char(x0(i+2))
 20   continue
      i1 = i1 + 1
      string(i1:i1)=char(0)
      call sascii(i1,x0(3),0)
      return 
      end 


