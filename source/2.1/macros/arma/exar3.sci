//<>=exar3(m)
//<>=exar3(m)
// Estimation de la puissance spectrale d'un processus
// ARMA
// Exemple tire de Sawaragi et all
// ou ils utilisent m=18
// test de mese et de arsimul
//!
[lhs,rhs]=argn(0)
if rhs=0,m=18;end
a=[1,-1.3136,1.4401,-1.0919,+0.83527]
b=[0.0,0.13137,0.023543,0.10775,0.03516]
rand('normal');
u=rand(1,1000);
z=arsimul(a,b,[0],0,u);
//----En utilisant mese
//calcul de la puissance spectrale estimee par la methode
//du maximum d'entropie
//macro mese de Scilab corrigee
[sm,fr]=mese(z,m);
//----le resultat theorique
deff('[gx]=gxx(z)',['gx=(abs( a* exp(-%i*2*%pi*z*(0:4))'')**2)';...
      'gx=abs( b* exp(-%i*2*%pi*z*(0:4))'')**2/gx']);
res=[];
for x=fr,res=[ res, gxx(x)];end;
//----En utilisant une estimation arma d'ordre (4,4)
// ce qui est un peu triche car a priori on ne connait pas l'ordre
//
[la,lb,sig,resid]=armax(4,4,z,u);
a=la(1);
b=lb(1);
res1=[];
for x=fr,res1=[ res1, gxx(x)];end;
//
leg="log(p) : estimee macro mese @ valeur theorique@log(p) : arma"
plot2d([fr;fr;fr]',[20*log(sm/sm(1))/log(10);...
  20*log(res/res(1))/log(10);...
  20*log(res1/res1(1))/log(10)]',...
 [-2,-1,1],"111",leg, [0,-70,0.5,60]);
//end

