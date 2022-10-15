function f1=%plr(p1,f1)
// f1= %plr(p1,f1) <=> f1=p1\f1
//!
[l,c]=size(p1),
if l*c<>1 then f1=invr(p1)*f1,return,end,
[n1,d1]=f1(2:3),
[n1,d1]=simp(n1,p1*d1),
f1(2)=n1;f1(3)=d1;



