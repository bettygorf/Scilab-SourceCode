//[]=fplot2d(xr,f,style,strf,leg,rect,nax)
//[]=fplot2d(xr,f,[style,strf,leg,rect,nax])
// Dessin d'une courbe 2D d\'efinie par un external f 
// on trace un aproximation lin\'eaire par morceaux de la courbe
// y=f(x), passant par les points (xr(i),f(xr(i)))
// xr est donc un vecteur implicite donnant les points ou l'on calcule f.
// pour les autres arguments qui sont optionnels, on se reportera \`a
// plot2d.
// Exemple~: taper fplot2d() pour voir un exemple.
// deff('<y>=f(x)','y=sin(x)+cos(x)');
// fplot2d(f,0:0.1:%pi);
//!
[lhs,rhs]=argn(0)
if rhs<=0,s_mat=['deff(''[y]=f(x)'',''y=sin(x)+cos(x)'');';
                 'fplot2d(0:0.1:%pi,f);'];
         write(%io(2),s_mat);execstr(s_mat);
         return;end;
if rhs < 2 then xx=[' I need at least 2 arguments';
                    ' or zero  a demo'];write(%io(2),xx);
         return;end
if rhs < 3,style=-1,end
if rhs < 4,strf="021",end
if rhs < 5,leg=" ",end
if rhs < 6,rect=[0,0,10,10],end
if rhs < 7,nax=[2,10,2,10],end
[p1,p2]=size(xr);
if p1=1 , xr=xr';[p1,p2]=size(xr);end
plot2d(xr,feval(xr,f),style,strf,leg,rect,nax),
//end
