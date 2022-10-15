//<s>=%smlss(d1,s2)
// s=d1*s2
//!
// origine s. steer inria 1987
//
[a2,b2,c2,d2,x2,dom2]=s2(2:7);
if prod(size(s2))==1 then 
    s=%lssms(s2,d1);return;  //transpose
end
d=d1*d2;
[a2;d1*c2];
s=list('lss',a2,b2,d1*c2,d,x2,dom2)
//end

