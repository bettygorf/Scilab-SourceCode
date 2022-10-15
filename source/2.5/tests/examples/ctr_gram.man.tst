clear;lines(0);
A=diag([-1,-2,-3]);B=rand(3,2);
Wc=ctr_gram(A,B)
U=rand(3,3);A1=U*A/U;B1=U*B;
Wc1=ctr_gram(A1,B1)    //Not invariant!
