clear;lines(0);
a=rand(5,2)*rand(2,5);A=sparse(a);
[ptr,rk]=lufact(A);[P,L,U,Q]=luget(ptr);
full(L), P*L*U*Q-A
clean(P*L*U*Q-A)
ludel(ptr)
