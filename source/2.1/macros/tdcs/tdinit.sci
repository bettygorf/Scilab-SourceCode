
//[]=tdinit()
tit=["bioreactor model initialisation";
 "competition model initialisation";
 "system with limit cycle ";
 "linear system ";
 "quadratic model ";
 "linear system with a feedback ";
 "pray predator model initialisation"]
ii=x_choose(tit," Systems Initialisation ");
// bioreactor
if ~isdef('k');k=2.0;end
if ~isdef('debit');debit=1.0;end
if ~isdef('x2in');x2in=3.0;end
// competition 
if ~isdef('ppr');ppr=1/100 ;end
if ~isdef('ppa');ppa=1/20000;end
if ~isdef('pps');pps=1/200 ;end
if ~isdef('ppb');ppb=1/10000 ;end
if ~isdef('ppk');ppk=1000 ;end
if ~isdef('ppl'); ppl=500;end
if ~isdef('ppm'); ppm=1/100;end
// linear 
if ~isdef('alin'); alin=eye(2,2);end;
// limit cycle 
if ~isdef('qeps'); qeps=0.1;end;
// quadratic  
if ~isdef('q1linper'); q1linper=eye(2,2);end;
if ~isdef('q2linper'); q2linper=eye(2,2);end;
if ~isdef('rlinper'); rlinper=0.0;end;
// linear and feedback
if ~isdef('lic_a'); lic_a=eye(2,2);end;
if ~isdef('lic_b'); lic_b=[1;1];end;
// pray predator 
if ~isdef('p_ppr');p_ppr=1/100 ;end
if ~isdef('p_ppa');p_ppa=1/20000;end
if ~isdef('p_ppm');p_ppm=1/100 ;end
if ~isdef('p_ppb');p_ppb=1/10000 ;end
select ii,
case 1 then [k,debit,x2in]=ibio();
case 2 then [ppr,ppa,pps,ppb,ppk,ppl]=icompet();
case 3 then [qeps]=icycl();
case 4 then [alin]=ilinear();
case 5 then [alin,qeps,q1linper,q2linper,rlinper]=ilinp();
case 6 then [lic_a,lic_b]=ilic();
case 7 then [p_ppr,p_ppa,p_ppm,p_ppb]=ip_p();
end
if ~isdef('p_ppr');p_ppr=1/100 ;end
if ~isdef('p_ppa');p_ppa=1/20000;end
if ~isdef('p_ppm');p_ppm=1/100 ;end
if ~isdef('p_ppb');p_ppb=1/10000 ;end
[k,debit,x2in,ppr,ppa,pps,ppb,ppk,ppl,qeps,q1linper,q2linper,...
rlinper,ppm,alin,p_ppr,p_ppa,p_ppm,p_ppb,lic_a,lic_b]= resume(k,debit,x2in,...
ppr,ppa,pps,ppb,ppk,ppl,qeps,...
q1linper,q2linper,rlinper,ppm,alin,p_ppr,p_ppa,p_ppm,p_ppb,lic_a,lic_b)
//end

//[k,debit,x2in]=ibio()
// initialisation du bioreactur
tit=["  bioreactor model initialisation";
   "x(1): biomass concentration ";
   "x(2): sugar concntration"; 
   " ";
   "xdot(1)=mu(x(2))*x(1)- debit*x(1)";
   "xdot(2)=-k*mu_td(x(2))*x(1)-debit*x(2)+debit*x2in";
   "mu(x):= x/(1+x)"];
x=x_mdialog(tit,['k';'debit';'x2in'],[string(k);string(debit);string(x2in)]);
k=evstr(x(1));
debit=evstr(x(2));
x2in=evstr(x(3));
//end

//[ppr,ppa,pps,ppb,ppk,ppl]=icompet()
tit=["  competition model initialisation";
     "xdot(1) = ppr*x(1)*(1-x(1)/ppk) - u*ppa*x(1)*x(2)";
     "xdot(2) = pps*x(2)*(1-x(2)/ppl) - u*ppb*x(1)*x(2)"];

x=x_mdialog(tit,['ppr';'ppa';'pps';'ppb';'ppk';'ppl'],...
	string([ppr;ppa;pps;ppb;ppk;ppl]));
//	['1/100';'1/20000';'1/200';'1/10000';'1000';'500']);
ppr=evstr(x(1));
ppa=evstr(x(2));
pps=evstr(x(3));
ppb=evstr(x(4));
ppk=evstr(x(5));
ppl=evstr(x(6));
//end

//[qeps]=icycl()
//[qeps]=icycl()
tit=["  system with limit cycle ";
     " xdot=a*x+qeps(1-||x||**2)x";" Enter qeps"];
qeps=x_matrix(tit,qeps);
//end


//[alin]=ilinear()
alin=x_matrix(['xdot=a*x';'Matrice 2x2 du systeme lineaire'],alin);
//end

//[alin,qeps,q1linper,q2linper,rlinper]=ilinp()
tit=[" quadratic model ";
     "xdot= a*x+(1/2)*qeps*[(x'')*q1*x;(x'')*q2*x]+r"];
x=x_mdialog(tit,['qeps';'r'],...
	[string(qeps);string(rlinper)]);
qeps=evstr(x(1));
rlinper=evstr(x(2));
alin=x_matrix([tit;'Enter a'],alin);
q1linper=x_matrix([tit;'Enter q1linper'],q1linper);
q2linper=x_matrix([tit;'Enter q2linper'],q2linper);
qeps=evstr(x(1));
rlinper=evstr(x(2));
//end

//[lic_a,lic_b]=ilic()
tit=[" linear system with a feedback ";
	"xdot= a*x +b*(-k*x);"];
lic_a=x_matrix([tit;"Enter a"],lic_a)
lic_b=x_matrix([tit;"Enter b"],lic_b)
//end

//[p_ppr,p_ppa,p_ppm,p_ppb]=ip_p()
tit=["  pray predator model initialisation";
     "xdot(1) = p_ppr*x(1)*(1-x(1)/p_ppk) - p_ppa*x(1)*x(2) - u*x(1);"
     "xdot(2) = -p_ppm*x(2)             + p_ppb*x(1)*x(2) - u*x(2);"];
x=x_mdialog(tit,['p_ppr';'p_ppa';'p_ppm';'p_ppb'],...
	string([p_ppr;p_ppa;p_ppm;p_ppb]));
p_ppr=evstr(x(1));
p_ppa=evstr(x(2));
p_ppm=evstr(x(3));
p_ppb=evstr(x(4));
//end
