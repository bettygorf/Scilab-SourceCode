function r=%l_n_l(l1,l2)
//%l_n_l(l1,l2)  : l1<>l2
//!
// Copyright INRIA
n1=size(l1)
r=n1<>size(l2)
if ~r  then
 for i=1:n1,
   if or(l1(i)<>l2(i)) then
     r(1,i)= %t
   else
     r(1,i)= %f
   end
 end
end


