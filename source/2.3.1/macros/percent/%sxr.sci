function f2=%sxr(n1,f2)
// %sxr(M,r) = (M.*r)   constant .* rational
//!
if size(n1,'*')==0 then 
  f2=[]
else
  f2(2)=n1.*f2(2)
end


