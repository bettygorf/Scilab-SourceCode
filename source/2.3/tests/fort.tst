// Testing interface of programs put in SCIDIR/routines/default/Ex-fort.f
//
//                  Test 1
// Corresponding to the following Fortran code inserted in 
// SCIDIR/routines/default/Ex-fort.f.
//
//      subroutine foobar1()
//      include '../stack.h'
//c retrieving dimensions of variables # 1,2,3,4 (ch,x,y,z) sent by fort
//      lch= msize(1,nrch,ncch)
//      ix= msize(2,nrx,ncx)
//      iy= msize(3,nry,ncy)
//      iz= msize(4,nrz,ncz)
//c lch=3 (length of 'mul')   ix=iy=iz=3
//c nrch=3, nlch=1;  nrx=nry=nrz=1; ncx=ncy=ncz=3;
//c    
//c allocating place in the internal stack and defining type
//      call alloc(1,lch,nrch,ncch,'c')
//      call alloc(2,ix,nrx,ncx,'i')
//      call alloc(3,iy,nry,ncy,'r')
//      call alloc(4,iz,nrz,ncz,'d')
//      call alloc(5,iz,nrz,ncz,'d')
//      call alloc(6,iz,nrz,ncz,'d')
//c ladr(1),ladr(2),ladr(3),ladr(4),ladr(5),ladr(6) are pointers
//c in stk() to (ch,x,y,z,d,w) resp. 
//c calling the routine
//      call foubare(stk(ladr(1)),stk(ladr(2)),ix,stk(ladr(3)),iy,
//     +            stk(ladr(4)),nrz,ncz,stk(ladr(5)),stk(ladr(6)),junk)
//c return of output variables (in increasing order) located
//c at (ladr(2),ladr(3),ladr(4),ladr(5)) resp. i.e (a,b,c,d) resp.
//      call back(2)
//      call back(3)
//      call back(4)
//      call back(5)
//      end
//
//Routine call in Scilab
x =[1,2,3];y =[1,2,3;4,5,6];z=[10,11;12,13];
mul=str2code('mul');
[a,b,c,d]=fort('foobar1',mul, x, y, z);
norm(a-2*x,1)
norm(b-2*y,1)
norm(c-2*z,1)
[mc,nc]=size(c);
w=zeros(c);
for i=1:mc;for j=1:nc, w(i,j)=i+j;end;end
norm(d-(2*z.*w),1)
add=str2code('add');
[a,b,c,d]=fort('foobar1',add, x, y, z);
norm(a-(2+x),1)
norm(b-(2+y),1)
norm(c-(2+z),1)
w=zeros(c);
for i=1:mc;for j=1:nc, w(i,j)=i+j;end;end
norm(d-(2+z+w),1)
//
//
//             Test 2
// Routine foobar is in SCIDIR/default/Ex-fort.f
// and "foobar" appears in SCIDIR/default/Flist
// This is equivalent to -->link("foobar.o","foubare");
// Routine call from scilab:

a =[1,2,3];b =[1,2,3;4,5,6];c =[10,11;12,13];
[ma,na]=size(a);ia=ma*na;
[mb,nb]=size(b);ib=mb*nb;
[mc,nc]=size(c);ic=mc*nc;
md=mc;nd=nc;
mul=str2code('mul');
[as,bs,cs,ds]=fort('foubare',mul,1,'c',a,2,'i',ia,3,'i',b,4,'r',ib,5,'i',...
                            c,6,'d',mc,7,'i',nc,8,'i',...
                   'out',[ma,na],2,'i',[mb,nb],4,'r',[mc,nc],6,'d',...
                          [md,nd],9,'d',[mc,nc],9,'d');
norm(as-2*a,1)
norm(bs-2*b,1)
norm(cs-2*c,1)
[mc,nc]=size(c);
w=zeros(c);
for i=1:mc;for j=1:nc, w(i,j)=i+j;end;end
norm(ds-(2*c.*w),1)

md=mc;nd=nc;
add=str2code('add');
[as,bs,cs,ds]=fort('foubare',add,1,'c',a,2,'i',ia,3,'i',b,4,'r',ib,5,'i',...
                            c,6,'d',mc,7,'i',nc,8,'i',...
                   'out',[ma,na],2,'i',[mb,nb],4,'r',[mc,nc],6,'d',...
                          [md,nd],9,'d',[mc,nc],w,'d');
norm(as-(2+a),1)
norm(bs-(2+b),1)
norm(cs-(2+c),1)
[mc,nc]=size(c);
w=zeros(c);
for i=1:mc;for j=1:nc, w(i,j)=i+j;end;end
norm(ds-(2+c+w),1)

//other valid call (output parameters 1 3 and 5 are also inputs)
a =[1,2,3];b =[1,2,3;4,5,6];c =[10,11;12,13];md=mc;nd=nc;mul=str2code('mul');
[as,bs,cs,ds]=fort('foubare',mul,1,'c',a,2,'i',ia,3,'i',b,4,'r',ib,5,'i',...
                            c,6,'d',mc,7,'i',nc,8,'i',...
                   'out',2,4,6,...
                          [md,nd],9,'d',[mc,nc],10,'d');
norm(as-2*a,1)
norm(bs-2*b,1)
norm(cs-2*c,1)
[mc,nc]=size(c);
w=zeros(c);
for i=1:mc;for j=1:nc, w(i,j)=i+j;end;end
norm(ds-(2*c.*w),1)

//-------------------Test no 3---------------------------
//
// corresponding to following code inserted in SCIDIR/default/Ex-fort.f
//
//      subroutine foobar3()
//      include '../stack.h'
//c   retrieving dimensions of input variables 1,2,3 (x,y,z)
//      ix=msize(1,nrx,ncx)
//      iy=msize(2,nry,ncy)
//      iz=msize(3,nrz,ncz)
//c   defining variables 4 and 5 (d and w in foubare)
//      call alloc(4,iz,nrz,ncz,'d')
//      call alloc(5,iz,nrz,ncz,'d')
//      call foubare('mul',stk(ladr(1)),ix,stk(ladr(2)),iy,
//     +              stk(ladr(3)),nrz,ncz,stk(ladr(4)),stk(ladr(5)),junk)
//      return
//      end
//
// Call from scilab:
a =[1,2,3];b =[1,2,3;4,5,6];c =[10,11;12,13];
[as,bs,cs,ds]=fort('foobar3',a,1,'i',b,2,'r',c,3,'d','out',1,2,3,4);
norm(as-2*a,1)
norm(bs-2*b,1)
norm(cs-2*c,1)
[mc,nc]=size(c);
w=zeros(c);
for i=1:mc;for j=1:nc, w(i,j)=i+j;end;end
norm(ds-(2*c.*w),1)
