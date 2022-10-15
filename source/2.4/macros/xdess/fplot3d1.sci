function []=fplot3d1(xr,yr,f,teta,alpha,leg,flag,ebox)
// Trace la surface d\'efinie par un external f ( ex macro [z]=f(x,y))
// on calcule d'abord f sur la grille definie par xr.yr
// xr et yr sont des vecteurs implicites donnant les
// abscisses et les ordonn\'ees des points de la grille
// -teta, alpha : sont les angles en coordonn\'ees spheriques du
//      point d'observation
// -flag et ebox (voir plot3d1)
// Exemple : taper fplot3d1() pour voir un exemple
// deff('<z>=surf(x,y)','z=x**2+y**2');
// res=fplot3d1(surf,-1:0.1:1,-1:0.1:1,35,45,"X@Y@Z");
//!
// Copyright INRIA
[lhs,rhs]=argn(0)
if rhs<=0;s_mat=['deff(''[z]=surf(x,y)'',''z=sin(x)*cos(y)'');';
                 't=-%pi:0.3:%pi;';
                 'fplot3d1(t,t,surf,35,45,'"X@Y@Z'");'];
         write(%io(2),s_mat);execstr(s_mat);
         return;end;
if rhs<4,teta=35,end;
if rhs<5,alpha=45,end;
if rhs<6,leg="X@Y@Z",end;
if rhs<7,flag=[2,2,3],end;
if rhs<8,ebox=0*ones(1,6),end;
if type(f)==11 then comp(f),end;
plot3d1(xr,yr,feval(xr,yr,f),teta,alpha,leg,flag,ebox),
