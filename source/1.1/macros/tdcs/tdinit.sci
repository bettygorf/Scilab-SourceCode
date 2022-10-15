
//[]=tdinit()
tit=["bioreactor model initialisation";
 "competition model initialisation";
 "system with limit cycle ";
 "linear system ";
 "quadratic model ";
 "linear system with a feedback ";
 "pray predator model initialisation"]
ii=x_choose(tit," Systems Initialisation ");
k=0;
debit=0;
x2in=0;
ppr=0;
ppa=0;
pps=0;
ppb=0;
ppk=0;
ppl=0;
qeps=0;
q1linper=0;
q2linper=0;
rlinper=0;
ppm=0;
alin=0;
select ii,
case 1 then [k,debit,x2in]=ibio();
case 2 then [ppr,ppa,pps,ppb,ppk,ppl]=icompet();
case 3 then [qeps]=icycl();
case 4 then [alin]=ilinear();[alin]=resume(alin);
case 5 then [alin,qeps,q1linper,q2linper,rlinper]=ilinp();
case 6 then [a,b]=ilic();[a,b]=resume(a,b);
case 7 then [ppr,ppa,ppm,ppb]=ip_p();
end
[k,debit,x2in,ppr,ppa,pps,ppb,ppk,ppl,qeps,q1linper,q2linper,...
rlinper,ppm,alin]= resume(k,debit,x2in,ppr,ppa,pps,ppb,ppk,ppl,qeps,...
q1linper,q2linper,rlinper,ppm,alin)
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
x=x_mdialog(tit,['k';'debit';'x2in'],['2.0';'1.0';'3.0']);
k=evstr(x(1));
debit=evstr(x(2));
x2in=evstr(x(3));
//end

//[ppr,ppa,pps,ppb,ppk,ppl]=icompet()
tit=["  competition model initialisation";
     "xdot(1) = ppr*x(1)*(1-x(1)/ppk) - u*ppa*x(1)*x(2)";
     "xdot(2) = pps*x(2)*(1-x(2)/ppl) - u*ppb*x(1)*x(2)"];

x=x_mdialog(tit,['ppr';'ppa';'pps';'ppb';'ppk';'ppl'],...
	['1/100';'1/20000';'1/200';'1/10000';'1000';'500']);
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
     " xdot=a*x+qeps(1-||x||**2)x"];
qeps=x_matrix(tit,[1 0 ; 0 1]);
//end


//[alin]=ilinear()
alin=x_matrix(['xdot=a*x';'Matrice 2x2 du systeme lineaire'],[1 0 ; 0 1]);
//end

//[alin,qeps,q1linper,q2linper,rlinper]=ilinp()
tit=[" quadratic model ";
     "xdot= a*x+(1/2)*qeps*[(x'')*q1*x;(x'')*q2*x]+r"];

x=x_mdialog(tit,['a';'qeps';'q1';'q2';'r'],...
	['[1 0 ; 0 1]';'[ 0 0;0 0]';
	 '[ 0 0;0 0]';'[ 0 0;0 0]';'[ 1 ; -1]']);
alin=evstr(x(1));
qeps=evstr(x(2));
q1linper=evstr(x(3));
q2linper=evstr(x(4));
rlinper=evstr(x(5));
//end

//[a,b]=ilic()
tit=[" linear system with a feedback ";
	"xdot= a*x +b*(-k*x);"];
x=x_mdialog(tit,['a';'b'],...
	['[1 0 ; 0 1]';'[ 1;1]']);
a=evstr(x(1));
b=evstr(x(2));
//end

//[ppr,ppa,ppm,ppb]=ip_p()
tit=["  pray predator model initialisation";
     "xdot(1) = ppr*x(1)*(1-x(1)/ppk) - ppa*x(1)*x(2) - u*x(1);"
     "xdot(2) = -ppm*x(2)             + ppb*x(1)*x(2) - u*x(2);"];
x=x_mdialog(tit,['ppr';'ppa';'ppm';'ppb'],...
	['1/100';'1/20000';'1/100';'1/10000']);
ppr=evstr(x(1));
ppa=evstr(x(2));
ppm=evstr(x(3));
ppb=evstr(x(4));
//end
