
host("make linktest");

routines=["ext1","ext2","ext2bis","ext2ter","ext3","ext3bis","ext4","ext5","ext6","ext7","ext8"];
lktest=link('show');
if lktest=1 then
	link("externals.o",routines);
else
	for s=routines; link("externals.o",s);end
end

a=[1,2,3];b=[4,5,6];n=3;
c=fort('ext1',n,1,'i',a,2,'d',b,3,'d','out',[1,3],4,'d');
if norm(c-(a+b),1)>1.d-10 then pause,end


a=[1,2,3];b=[4,5,6];n=3;
c=fort('ext2',n,1,'i',a,2,'d',b,3,'d','out',[1,3],4,'d');
if norm(c-(sin(a)+cos(b)),1)>1.d-10 then pause,end


a=[1,2,3];b=[4,5,6];n=3;yes=str2code('yes');
c=fort('ext2bis',yes,1,'c',n,2,'i',a,3,'d',b,4,'d','out',[1,3],5,'d');
if norm(c-(sin(a)+cos(b)),1)>1.d-10 then pause,end


a=[1,2,3];b=[4,5,6];n=3;yes='yes';
c=fort('ext2ter',n,1,'i',a,2,'d',b,3,'d','out',[1,3],4,'d');
if norm(c-(sin(a)+cos(b)),1)> 1.d-10 then pause,end
yes='no';
c=fort('ext2ter',n,1,'i',a,2,'d',b,3,'d','out',[1,3],4,'d');
if norm(c-(a+b),1)> 1.d-10 then pause,end
//clear yes  --> undefined variable : yes


a=[1,2,3];b=[2,3,4];
c=fort('ext3',b,1,'d','out',[1,3],2,'d');
if norm(c-(a+2*b),1)>1.d-10 then pause,end


a=[1,2,3];b=[2,3,4];name=str2code('a');
c=fort('ext3bis',name,1,'c',b,2,'d','out',[1,3],3,'d');
if norm(c-(a+2*b),1)>1.d-10 then pause,end



c=0;a=[1,2,3]; b=[2,3,4];clear c
//c does not exist (c made by the call to matz)
fort('ext4',a,1,'d',b,2,'d','out',1);
//    c now exists
if norm(c-(a+2*b),1)>1.d-10 then pause,end


y0=ode([1;0;0],0,[0.4,4],'ext5');

param=[0.04,10000,3d+7];    
y=ode([1;0;0],0,[0.4,4],list('ext6',param));
if norm(y0-y,1)>1.d-100 then pause,end


param=[0.04,10000,3d+7];
y=ode([1;0;0],0,[0.4,4],'ext7');
if norm(y0-y,1)>1.d-10 then pause,end

param=[0.04,10000,3d+7];
y=ode([1;0;0],0,[0.4,4],'ext8');
if norm(y0-y,1)>1.d-10 then pause,end







