clear;lines(0);
F=randpencil([1,1,2],[2,3],[-1,3,1],[0,3]);
Q=rand(17,17);Z=rand(18,18);F=Q*F*Z;
//random pencil with eps1=1,eps2=1,eps3=1; 2 J-blocks @ infty 
//with dimensions 2 and 3
//3 finite eigenvalues at -1,3,1 and eta1=0,eta2=3
[Q,Z,Qd,Zd,numbeps,numbeta]=kroneck(F);
[Qd(1),Zd(1)]    //eps. part is sum(epsi) x (sum(epsi) + number of epsi) 
[Qd(2),Zd(2)]    //infinity part
[Qd(3),Zd(3)]    //finite part
[Qd(4),Zd(4)]    //eta part is (sum(etai) + number(eta1)) x sum(etai)
numbeps
numbeta
