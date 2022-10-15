clear;lines(0);
A=rand(5,5);
[Ro,Theta]=polar(A);
norm(A-Ro*expm(%i*Theta),1)
