function []=xtitle(xtit,xax,yax,encad)
//[]=xtitle(xtit,[xax,yax,encad])
//Exemple : taper xtitle() pour voir un exemple
//!
[lhs,rhs]=argn(0)
if rhs=0,s_mat=['plot2d([0;5],[0;10]);';
                'titre=[''Titre'';''Principal''];';
                'xtitle(titre,'"x'",'"y'");';];
         write(%io(2),s_mat);execstr(s_mat);
         return;end;
if rhs<=3,encad=0;end
if rhs<=2,yax=' ';end
if rhs<=1,xax=' ';end
[ww,rr]=xgetech();
//bouding rect 
w1=(rr(3)-rr(1))
h1=(rr(4)-rr(2))
rr1=[rr(1)-w1/6,rr(4)+h1/6, (4/3)*w1,(4/3)*h1]
xstringb(rr(1),rr(4),xtit,w1,h1/6,'no');
xstringb(rr(3),rr(2),xax,w1/6,h1/6,'no');
xstringb(rr(1),rr(4),yax,w1/6,h1/12,'no');




