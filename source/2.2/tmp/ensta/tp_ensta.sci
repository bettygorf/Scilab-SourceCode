// Initialisations ...
s = poly(0,'s'); s = syslin('c',s*s/s);
r=[1,1];
load('proc');
frq=0.1:0.001:1;
rep1 = repfreq(proc,frq);
rep3 = repfreq(s/s,frq);

vproc=pfss(tf2ss(proc));
vproc(5)=clean(ss2tf(vproc(5)));
gr=ss2tf(vproc(3)+vproc(5)+vproc(7)+vproc(8));
gr=gr+horner(clean(proc-gr,1e-8),0);

xbasc();xset("window",0);xselect();bode([proc;gr],0.1,1,0.005);
errmul=proc/gr-1;

vigr=pfss(tf2ss(1/gr));   //on recupere les numerateurs-->w3

vigr(1)=ss2tf(vigr(1));
vigr(2)=ss2tf(vigr(2));
vigr(3)=ss2tf(vigr(3));
vigr(4)=ss2tf(vigr(4));
vigr(5)=ss2tf(vigr(5));
vigr(6)=ss2tf(vigr(6));  

w31=vigr(1);w31=w31/horner(w31,0);
w32=vigr(2);w32=w32/horner(w32,0);
w33=vigr(3);w33=w33/horner(w33,0);
w33=trfmod(w33);// prendre le pole reflechi (changer - par +)
w341=trfmod(vigr(4));  // prendre le pole reflechi (changer - par +)
w34=w341/trfmod(w341); // multiplier l'amortissement par 3

w35=vigr(5);

w35=w35/trfmod(w35);  //multiplier l'amortissement par 3

g=gr/s;
vg=pfss(tf2ss(g));    //nouvelle dec. en elmts simple-->syst. augm.
vg1=ss2tf(vg(1));
vg2=clean(ss2tf(vg(2)));
vg3=ss2tf(vg(3));
vg4=ss2tf(vg(4));
vg0=vg1+vg2;

Ms=s+1;Ns=1/(s+1);
Sys1=sysdiag(1,1,1,1,Ms);Sys2=sysdiag(1,Ns);
w50=0.4; w51= 8; w52 = 29;
Rg=[diag([w50,w51,w52]);[1,1,1]]*[vg(1)+vg(2);vg(3);vg(4)];
U=[0,-1;1,-1];


amin = 0; amax = 2;
while (amax -amin)/amax > 1e-2,
a = (amin + amax)/2; write(%io(2),a,'(f6.4)')
w3=(1/ab)*horner((1+s^3),s/a)*w31*w33*w34*w35;
P=sysdiag(tf2ss(w3),Rg)*U;
Ptmp=Sys1*P*Sys2;
[sk,mu]=H_inf(Ptmp,r,0.8,1.2,1);
if mu == [] then amin = a; else amax = a; end
end

w3=(1/ab)*horner((1+s^3),s/amin)*w31*w33*w34*w35;
P=sysdiag(tf2ss(w3),Rg)*U;

//xbasc();
xset("window",1);gainplot([w3;errmul],.1,1,0.005);

Ptmp=Sys1*P*Sys2;
[Ktmp,mu]=H_inf(Ptmp,r,0.9,1.1,30);

K=ss2tf(Ktmp)/s;
ks=trfmod(K);
 
olp=ks*proc;
rep2 = repfreq(ks,frq);

xbasc(2);
xset("window",2);xselect();nyquist(olp,0.03,0.8,0.00015);
m_circle(20*log(2.05)/log(10));xset("dashes",0);

sensit = rep1 ./(rep3 + rep1.*rep2);
xbasc(3);
xset("window",3);xselect();gainplot(frq,[sensit;rep1;rep2],['G/(1+KG)';'G';'K']);

www=lft(Ptmp,Ktmp);
xbasc(5);xset("window",5);xselect();
gainplot(www,0.01,10);

www1=lft(ss2tf(P),r,ks);
xbasc(6);xset("window",6);xselect();
gainplot(www1,0.01,10,['W3G/(1+KG)';'W50G0/(1+KG)';'W51G1/(1+KG)';'W52G2/(1+KG)']);

