clear;lines(0);
G=ssrand(1,1,3);K=ssrand(1,1,3);
[Se,Re,Te]=sensi(G,K);
Se1=inv(eye()+G*K);  //Other way to compute
ss2tf(Se)    //Se seen in transfer form
ss2tf(Se1)
ss2tf(Te)
ss2tf(G*K*Se1)
[Si,Ri,Ti]=sensi(G,K,'i');
w1=[ss2tf(Si);ss2tf(Ri);ss2tf(Ti)]
w2=[ss2tf(inv(eye()+K*G));ss2tf(G*inv(eye()+K*G));ss2tf(K*G*inv(eye()+K*G))];
clean(w1-w2)
