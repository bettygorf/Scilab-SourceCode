clear;lines(0);
A=[1,2;3,4]
sinm(asinm(A))
asinm(A)+%i*logm(%i*A+sqrtm(eye()-A*A))
