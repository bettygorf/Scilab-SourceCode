clear;lines(0);
s=%s;F=[-1,s,0,0;0,-1,0,0;0,0,s-2,0;0,0,0,s-1];
[Bfs,Bis,chis]=glever(F)
inv(F)-((Bfs/chis) - Bis)
