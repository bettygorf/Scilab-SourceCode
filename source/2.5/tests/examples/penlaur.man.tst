clear;lines(0);
F=randpencil([],[1,2],[1,2,3],[]);
F=rand(6,6)*F*rand(6,6);[E,A]=pen2ea(F);
[Si,Pi,Di]=penlaur(F);
[Bfs,Bis,chis]=glever(F);
norm(coeff(Bis,1)-Di,1)
