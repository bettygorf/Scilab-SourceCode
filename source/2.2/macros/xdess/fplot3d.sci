//[]=fplot3d(xr,yr,f,teta,alpha,leg,flag,ebox)
//[]=fplot3d(xr,yr,f,teta,alpha,leg,[flag,ebox])
// Trace la surface d\'efinie par un external f ( ex macro [z]=f(x,y))
// on calcule d'abord f sur la grille definie par xr.yr
// xr et yr sont des vecteurs implicites donnant les
// abscisses et les ordonn\'ees des points de la grille
// -teta, alpha : sont les angles en coordonn\'ees spheriques du
//      point d'observation
// -flag et ebox (voir plot3d)
// Exemple : taper fplot3d() pour voir un exemple
//!
[lhs,rhs]=argn(0)
if rhs<=0;s_mat=['deff(''[z]=surf(x,y)'',''z=sin(x)*cos(y)'');';
                 't=-%pi:0.3:%pi;';
                 'fplot3d(t,t,surf,35,45,'"X@Y@Z'");'];
         write(%io(2),s_mat);execstr(s_mat);
         return;end;
if rhs<3,write(%io(2),[' I need at least 3 arguments';...
                       ' or zero to have a demo']);
return;
end;
if rhs<4,teta=35,end;
if rhs<5,alpha=45,end;
if rhs<6,leg="X@Y@Z",end;
if rhs<7,flag=[2,2,3],end;
if rhs<8,ebox=0*ones(1,6),end;
if type(f)=11 then comp(f),end;
plot3d(xr,yr,feval(xr,yr,f),teta,alpha,leg,flag,ebox),
//end


