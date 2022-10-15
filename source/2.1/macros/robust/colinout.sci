function [Inn,X,Gbar]=colinout(G)
[Innt,Xt,Gbart]=rowinout(G');
Inn=Innt';X=Xt';Gbar=Gbart';
