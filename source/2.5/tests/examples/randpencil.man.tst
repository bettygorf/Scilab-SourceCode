clear;lines(0);
F=randpencil([0,1],[2],[-1,0,1],[3]);
[Q,Z,Qd,Zd,numbeps,numbeta]=kroneck(F);
Qd, Zd
s=poly(0,'s');
F=randpencil([],[1,2],s^3-2,[]); //regular pencil
det(F)
