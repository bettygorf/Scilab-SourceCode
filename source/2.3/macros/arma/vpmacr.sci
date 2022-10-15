function [dx,du,resid]=vpmacr(sys,sysn,pas,Tmax,uequ,umac)
// sys  : systeme dynamique
// sysn : nom du systeme donne sous forme de chaine de caratere
// pas  : pas d'integration
// Tmax : temps d'integration
// uequ : valeurs de u pour lesquelles on veut faire le calcul
// umac : chaine de caractere donnant en code Scilab
//        la maniere de calculer le signal d'entree
//        Ex umac="0.1*sin(t)" ou "0.1*bruit(t)"
//
[uequ,xequ]=equi(sys,Tmax,uequ);
[n1,n2]=size(uequ);
for i=1:n2,
    deff('[xdot]=sysd(t,x)',...
        'xdot='+sysn+'(t,x+'+string(xequ(i))+...
        ','+umac+'+'+string(uequ(i))+')');
    deff('[u]=umac_m(t)','u='+umac);
    dxe=0.001;
    dx=ode(dxe,0,0:0.1:Tmax,sysd);
    du=[];
    for t=0:0.1:Tmax,du=[du,umac_m(t)],end
    [la,lb,sig,resid]=narmax(1,1,dx,du,1,1);
end


function [xdot]=sys1(t,x,u)
xdot=-(1+u)*(1/2*x**2-u)

function [xdot]=sys2(t,x,u)
xdot=-(1+u)*(1/3*x**3-u)

function [xdot]=sys3(t,x,u)
xdot=-( (2)**(1/2)*x-2*u)




