//[s]=%lssfs(s1,d2)
//operation  s=[s1;d2]
//!
// origine s. steer inria 1987
[a1,b1,c1,d1,x1,dom1]=s1(2:7)
[n1,m1]=size(c1);[p2,m2]=size(d2);
s=list('lss',a1,b1,[c1;0*ones(p2,m1)],[d1;d2],x1,dom1)
//end


