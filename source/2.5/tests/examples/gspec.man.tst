clear;lines(0);
A=rand(3,3);
[al,be,Z] = gspec(A,eye(A));al./be
clean(inv(Z)*A*Z)  //displaying the eigenvalues (generic matrix)
A=A+%i*rand(A);E=rand(A);
roots(det(%s*E-A))   //complex case
