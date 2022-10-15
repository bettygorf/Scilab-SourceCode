clear;lines(0);
F=randpencil([],[1,2],[1,2,3],[]);
F=rand(6,6)*F*rand(6,6);
[Q,M,i1]=pencan(F);
W=clean(M*F*Q)
roots(det(W(1:i1,1:i1)))
det(W($-2:$,$-2:$))
