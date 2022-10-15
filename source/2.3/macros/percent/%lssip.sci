function [s]=%lssip(i,j,s1,s2)
//%lssip(i,j,s1,s2) <=> s2(i,j)=s1
//!
// origine s. steer inria 1992
//
if type(i)==10|type(j)==10 then 
  error(21)
end
[a1,b1,c1,d1,x1,dom1]=s1(2:7)
d2=s2;
[n1,n1]=size(a1);

b2(1:n1,j)=b1
c2(i,1:n1)=c1
d2(i,j)=d1;
s=tlist(['lss','A','B','C','D','X0','dt'],a1,b2,c2,d2,x1,dom1)



