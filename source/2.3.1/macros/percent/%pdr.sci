function r=%pdr(p,r)
// r=%pdr(p,r) <=> r= p./r   polynomial./rational
[n,d]=r(2:3)
r(2)=d.*p;r(3)=n.*ones(p);



