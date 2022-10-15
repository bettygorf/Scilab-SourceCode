clear;lines(0);
F=randpencil([],[2],[1,2,3],[]);
F=rand(5,5)*F*rand(5,5);   // 5 x 5 regular pencil with 3 evals at 1,2,3
[Ws,F1]=rowshuff(F,-1);
[E1,A1]=pen2ea(F1);
svd(E1)           //E1 non singular
roots(det(Ws))
clean(inv(F)-inv(F1)*Ws,1.d-7)
