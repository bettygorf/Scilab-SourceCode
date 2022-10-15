clear;lines(0);
A=rand(5,3)*rand(3,8);
b=A*ones(8,1);[x,kerA]=linsolve(A,b);A*x+b   //compatible b
b=ones(5,1);[x,kerA]=linsolve(A,b);A*x+b   //uncompatible b
A=rand(5,5);[x,kerA]=linsolve(A,b), -inv(A)*b  //x is unique
