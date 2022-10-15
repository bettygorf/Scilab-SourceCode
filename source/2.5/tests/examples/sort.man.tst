clear;lines(0);
[s,p]=sort(rand(1,10));
//p  is a random permutation of 1:10
A=[1,2,5;3,4,2];
[Asorted,q]=sort(A);A(q(:))-Asorted(:)
v=1:10;
sort(v)
sort(v')
sort(v,'r')  //Does nothing for row vectors
sort(v,'c')
