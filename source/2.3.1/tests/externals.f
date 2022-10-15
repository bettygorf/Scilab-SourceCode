      subroutine ext1(n,a,b,c)
c     (very) simple example 1
c     -->link('ext1.o','ext1');
c     -->a=[1,2,3];b=[4,5,6];n=3;
c     -->c=fort('ext1',n,1,'i',a,2,'d',b,3,'d','out',[1,3],4,'d')
c     c=a+b
      double precision a(*),b(*),c(*)
      do 1 k=1,n
   1  c(k)=a(k)+b(k)
      end

      subroutine ext2(n,a,b,c)
c     simple example 2 (using sin and cos)
c     -->link('ext2.o','ext2');
c     -->a=[1,2,3];b=[4,5,6];n=3;
c     -->c=fort('ext2',n,1,'i',a,2,'d',b,3,'d','out',[1,3],4,'d')
c     -->c=sin(a)+cos(b)
      double precision a(*),b(*),c(*)
      do 1 k=1,n
   1  c(k)=sin(a(k))+cos(b(k))
      end

      subroutine ext2bis(ch,n,a,b,c)
c     simple example 2bis (passing a chain)
c     -->link('ext2bis.o','ext2bis');
c     -->a=[1,2,3];b=[4,5,6];n=3;yes=str2code('yes')
c     -->c=fort('ext2bis',yes,1,'c',n,2,'i',a,3,'d',b,4,'d','out',[1,3],5,'d')
c     -->c=sin(a)+cos(b)
      double precision a(*),b(*),c(*)
      character*(*) ch
      if(ch(1:3).eq.'yes') then
      do 1 k=1,n
   1  c(k)=sin(a(k))+cos(b(k))
	else
      do 2 k=1,n
   2  c(k)=a(k)+b(k)
      endif
      end

      subroutine ext2ter(n,a,b,c)
c     simple example 2ter (reading a chain)
c     -->link('ext2ter.o','ext2ter');
c     -->a=[1,2,3];b=[4,5,6];n=3;yes='yes'
c     -->c=fort('ext2ter',n,1,'i',a,2,'d',b,3,'d','out',[1,3],4,'d')
c     -->c=sin(a)+cos(b)
c     -->yes='no'
c     -->c=a+b
c     -->clear yes  --> undefined variable : yes
      double precision a(*),b(*),c(*)
      character*(10) ch
      call readchain('yes',lch,ch)
c     ****************************      
      if(ch(1:lch).eq.'yes') then
      do 1 k=1,n
   1  c(k)=sin(a(k))+cos(b(k))
	else
      do 2 k=1,n
   2  c(k)=a(k)+b(k)
      endif
      end

      subroutine ext3(b,c)
c     example 3
c     reading a vector in scilab internal stack using readmat
c     (see SCIDIR/system2/readmat.f)
c     -->link('ext3.o','ext3')
c     -->a=[1,2,3];b=[2,3,4];
c     -->c=fort('ext3',b,1,'d','out',[1,3],2,'d')
c     -->c=a+2*b
      double precision a(3),b(*),c(*)
      call readmat('a',m,n,a)	
c     ***********************
c  same as
c      call matz(a,w,m,m,n,'a',0)
c
c     [m,n]=size(a)  here m=1 n=3
      do 1 k=1,n
   1  c(k)=a(k)+2.0d0*b(k)
      end

      subroutine ext3bis(aname,b,c)
c     example 3
c     reading a vector in scilab internal stack using readmat interface
c     -->link('ext3bis.o','ext3bis')
c     -->a=[1,2,3];b=[2,3,4];name=str2code('a');
c     -->c=fort('ext3bis',name,1,'c',b,2,'d','out',[1,3],3,'d')
c     -->c=a+2*b
      double precision a(3),b(*),c(*)
      character*(*) aname
      call readmat(aname,m,n,a)
c     [m,n]=size(a)  here m=1 n=3
      do 1 k=1,n
   1  c(k)=a(k)+2.0d0*b(k)
      end

      subroutine ext4(a,b)
c     example 4
c     creating vector c in scilab internal stack
c     -->link('ext4.o','ext4')
c     -->a=[1,2,3]; b=[2,3,4];
c     c does not exist (c made by the call to matz)
c     -->fort('ext4',a,1,'d',b,2,'d','out',1);
c     c now exists
c     -->c=a+2*b
      double precision a(3),b(3),c(3),w
      do 1 k=1,3
   1  c(k)=a(k)+2.0d0*b(k)
      call matz(c,w,1,1,3,'c',1)
c     [m,n]=size(a)  here m=1 n=3
      end


      subroutine ext5(n, t, y, ydot)
c     argument function for ode
c     input variables n, t, y
c     n = dimension of state vector y
c     t = time
c     y = state variable 
c     output variable = ydot
c
c     external routine must 
c     load ydot(1) with d/dt ( y(1)(t) )
c          ydot(2) with d/dt ( y(2)(t) )
c          ...
c     i.e. ydot vector of derivative of state y
c
c     Example:
c     call this ext5 routine: 
c     ode([1;0;0],0,[0.4,4],'ext5')
c
c     With dynamic link: 
c     -->link('ext5.o','ext5')
c     -->ode([1;0;0],0,[0.4,4],'ext5')
c
      double precision t, y, ydot
      dimension y(3), ydot(3)
      ydot(1) = -.0400d+0*y(1) + 1.0d+4*y(2)*y(3)
      ydot(3) = 3.0d+7*y(2)*y(2)
      ydot(2) = -ydot(1) - ydot(3)
      end

      subroutine ext6(n, t, y, ydot)
c     external fonction for ode
c     input variables n, t, y
c     n = dimension of state vector y
c     t = time
c     y = state variable 
c     output variable = ydot
c
c     external routine must 
c     load ydot(1) with d/dt ( y(1)(t) )
c          ydot(2) with d/dt ( y(2)(t) )
c          ...
c     i.e. ydot vector of derivative of state y
c
c     With dynamic link: 
c     link('ext6.o','ext6')
c
c     passing a parameter to ext6 routine by a list:
c     -->param=[0.04,10000,3d+7];    
c     -->y=ode([1;0;0],0,[0.4,4],list('ext6',param))
c     param is retrieved in ext6 by:
c     param(1)=y(n+1) , param(2)=y(n+2) etc 
c     with this calling sequence y is a n+np vector
c     where np=dimension of scilab variable param
c
      double precision t, y, ydot, param
      dimension y(3), ydot(3),param(3)
      param(1)=y(n+1)
      param(2)=y(n+2)
      param(3)=y(n+3)
      ydot(1) = -param(1)*y(1) + param(2)*y(2)*y(3)
      ydot(3) = param(3)*y(2)*y(2)
      ydot(2) = -ydot(1) - ydot(3)
      end


      subroutine ext7(neq, t, y, ydot)
c     -------------------------------------------
c     exemple with a call to readmat routine
c     -->param=[0.04,10000,3d+7];
c     -->y=ode([1;0;0],0,[0.4,4],'ext7')
c     param must be defined as a scilab variable
      double precision t, y, ydot, param
      dimension y(3), ydot(3), param(3)

      call readmat('param',m,n,param)
c     *******************************
      ydot(1) = -param(1)*y(1) + param(2)*y(2)*y(3)
      ydot(3) = param(3)*y(2)*y(2)
      ydot(2) = -ydot(1) - ydot(3)
      return
      end


      subroutine ext8(neq, t, y, ydot)
c     -------------------------------------------
c     same example with call to matptr
c     param must be defined as a scilab variable
c     exemple with a call to matptr routine
c     -->param=[0.04,10000,3d+7];
c     -->y=ode([1;0;0],0,[0.4,4],'ext8')
      double precision t, y, ydot, param
      dimension y(3), ydot(3)
c
      include '../routines/stack.h'
c
      call matptr('param',m,n,lp)
c     ***************************
c     param entries are in stk(lp),stk(lp+1),stk(lp+2)
c     m,n = dimensions of param = 3,1 (or 1,3 if row v.)
c     (note that vector param not used in this example)
      ydot(1) = -stk(lp)*y(1) + stk(lp+1)*y(2)*y(3)
      ydot(3) = stk(lp+2)*y(2)*y(2)
      ydot(2) = -ydot(1) - ydot(3)
      return
      end



