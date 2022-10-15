function f1=%rxs(f1,n2)
// %rxs(r,M)=r.*M      rational .* constant
//!
if size(n2,'*')==0
  f1=[]
else
  f1(2)=f1(2).*n2
end



