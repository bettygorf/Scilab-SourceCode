x0=[1. 1. 0.8750714 0.4772780 2.0975887 2.636041 1.6018558 1.0620259 10.]';
x0=[x0 0*ones(x0)];
binf=[0;-2*%pi].*.ones(4,1);
binf=[binf;0];
bsup=[1;2*%pi].*.ones(4,1);
bsup=[bsup;10];
binf=[binf 0*ones(binf)];
bsup=[bsup 0*ones(bsup)]; 
x=x0;
[cout,x,grad,to]=optim(iirmod,'b',binf,bsup,x);