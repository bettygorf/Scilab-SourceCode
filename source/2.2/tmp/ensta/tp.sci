// Initialisations ...
s = poly(0,'s'); s = syslin('c',s*s/s);
// approx(G,ll) returns approximation of G by elts in ll
deff('res=approx(G,ll)',...
['res=0';
 'n=length(ll)';
 'for k=1:n,res=res+ll(k);end';
 'res=res+horner(clean(G-res),0)'])

// W3dg1(p) returns p(0)   (p degree one)
deff('res=w3dg1(p)','res=horner(p,0)+0*poly(0,''s'')');

// W3dg2(p) returns p1 with damping(p1) = k damping(p)
deff('p1=w3dg2(p,k)',...
['damp=coeff(p,1)';
 'p1=poly([coeff(p,0),k*damp,coeff(p,2)],''s'',''coeff'')';])


Gr=(s+1)*(s-1)*(s+2)*(s^2+0.3*s+1)/((s+0.5)*(s^2*(s^2-0.1*s+2)*(s^2+0.1*s+1)));
G=Gr/s;
r=size(G);
fmin=0.01;fmax=10;
frq=calfrq(G,fmin,fmax);
W=pfss(G,'c');

W(1)=clean(w(1));


appr=[];yesno=[];
for k=1:size(w);
  appr=[appr;'G'+string(k-1);];yesno=[yesno;'yes'];
end
yesno=x_mdialog("Choose elements",appr,yesno)

appr=' ';
for k=1:size(w)-1;
   if yesno(k)=='yes' then appr=appr+'W('+string(k)+'),';end
end 
k=size(w);
   if yesno(k)=='yes' then appr=appr+'W('+string(k)+')';end

execstr('bode([G;approx(G,list('+appr+'))],frq)')

[lnum,dcgain]=factors(G,'c');
nb=length(lnum);

denominators=[];
numerators=[];

for k=1:nb,
lnumk=lnum(k); 
 denominators=[denominators;pol2str(lnumk)];
   if degree(lnumk)==1 then 
     numerators=[numerators;pol2str(w3dg1(lnumk))];end
   if degree(lnumk)==2 then 
     numerators=[numerators;pol2str(w3dg2(lnumk,2))];end
end

Numerators=x_mdialog('Denominators     Numerators',Denominators,Numerators);

// J(s)
Js=1;
for k=1:nb,
    Js=Js*evstr(numerators(k))/evstr(denominators(k));
end

sp=poly(0,'s');
Ms=sp+1;Ns=(sp+1);

mnns=x_mdialog("Choose Ms and Ns",[pol2str(Ms);'1/'+pol2str(sp+1)],...
 [pol2str(Ms);'1/'+pol2str(sp+1)]);
Ms=evstr(Mnns(1));
Ns=evstr(Mnns(2));

Sys1=sysdiag(1,1,1,1,Ms);Sys2=sysdiag(1,Ns);

W5is=[];
for k=1:nb
   W5is=[W5is;'W5'+string(k)];
end

w5=x_mdialog('Choose W5i s',W5is,string(ones(nb,1)));

ww5=[];
for k=1:nb;ww5(k)=evstr(w5(k));end

Rg=[diag(ww5');ones(ww5')]*[W(1)+W(2);W(2);W(3);W(4)];
U=[0,-1;1,-1];

amin = 0; amax = 2;
while (amax -amin)/amax > 1e-2,
a = (amin + amax)/2; write(%io(2),a,'(f6.4)')
w3=(1/2)*horner((1+s^3),s/a)*w3coeff;
P=sysdiag(tf2ss(w3),Rg)*U;
Ptmp=Sys1*P*Sys2;
[sk,mu]=H_inf(Ptmp,r,0.8,1.2,1);
if mu == [] then amin = a; else amax = a; end
end

w3=(1/ab)*horner((1+s^3),s/amin)*w3coeff;
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

