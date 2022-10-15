u=-prbs(300,1,ent(<2.5,5,10,17.5,20,22,27,35>*100/12));
rand('seed');
zd=narsimul(ar,u);
driver('Pos')
xinit('armas.ps');
plot2d1("enn",1,<zd>',<-1,-2,-3>,"121","zd(1)@zd(2)",<1,-7000,300,7000>);
plot2d2("enn",1,1000*u',<-1,3>,"100","ux1000");
rand('seed');
// on verifie que arsimul et narsimul donnent le meme resultat.
zd1=arsimul(ar,u);
maxi(abs(zd-zd1))
xend();
