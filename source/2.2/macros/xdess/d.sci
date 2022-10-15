function datas=drawmbar(menus,flag,shift)
// drawmbar - dessine une barre de menu dans une fenetre graphique
//%Syntaxe
// datas=drawmbar(menus [,flag])
//%Parametres
// menus  : vecteur contenant le texte associe a chacun des boutons
// flag   : definit le positionnement de la barre de menus:
//          'h' : horizontal en  haut
//          'r' : vertical a droite
// datas  : contient les information necessaires a getmenu
//!
//origine S Steer INRIA 1993
[lhs,rhs]=argn(0)
if rhs==1 then flag='r',end
if rhs<3 then  shift=0,end
//
colored=xget('use color')==1
[r1,r2]=xgetech();
wid=xget("white")
thick=xget('thickness');
if ~colored then 
  xset('thickness',2),
  back=0
  butt=0
else
  back=3
  butt=13
end
alu=xget('alufunction')
xset('alufunction',3)
xclip()


//Dessin des Menus et definition de datas
nm=prod(size(menus))
datas=[]

[w,klm]=maxi(length(menus));
b=xstringl(0,0,menus(klm));
if shift<>0 then
  xshift=(r2(3)-r2(1))*shift
  yshift=(r2(4)-r2(2))*shift
else
  xshift=0
  yshift=0
end
if flag=='h' then //menus horizontaux
  lm=b(3);
  hm=b(4);
  dxm=(r2(3)-r2(1))/140;
  xm=-xshift+r2(1)+dxm;
  dym=(r2(4)-r2(2))/120;
  ym=yshift+r2(4)-dym;
  cliprect=[r2(1)-xshift,r2(4)+yshift-hm+7/3*dym,..
      r2(3)-r2(1)+2*xshift,r2(4)-r2(2)+2*yshift-hm+7/3*dym]
  xrects([r2(1)-xshift;r2(4)+yshift;r2(3)-r2(1)+2*xshift;hm+7/3*dym],back)
  xrects([r2(1)-xshift;r2(4)+yshift;r2(3)-r2(1)+2*xshift;hm+7/3*dym],wid+1)
  for km=0:nm-1
    x=xm+km*(lm+dxm)
    xrects([x;ym;lm;hm],butt)
    xrects([x;ym;lm;hm],wid+1)
    xstringb(x,ym-hm+(b(4)-b(2))/2,menus(km+1),lm,hm)
    datas=[datas;[x,x+lm,ym,ym-hm]];
  end
else //menus verticaux
  lm=b(3);
  hm=b(4);
  dxm=(r2(3)-r2(1))/140;
  xm=xshift+r2(3)-lm-dxm;
  dym=(r2(4)-r2(2))/120;
  ym=yshift+r2(4)-dym;
  cliprect=[r2(1)-xshift,r2(4)-yshift,..
      r2(3)-r2(1)+2*xshift-lm+dxm*7/3,r2(4)-r2(2)+2*yshift]
  xrects([xm-dxm*4/3;r2(4)+yshift;lm+dxm*7/3;r2(4)-r2(2)+2*yshift],back)
  xrects([xm-dxm*4/3;r2(4)+yshift;lm+dxm*7/3;r2(4)-r2(2)+2*yshift],wid+1)
  for km=0:nm-1
    y=ym-km*(hm+dym);
    xrects([xm;y;lm;hm],butt);
    xrects([xm;y;lm;hm],wid+1);
    xstringb(xm,y-hm+(b(4)-b(2))/2,menus(km+1),lm,hm);
    datas=[datas;[xm,xm+lm,y,y-hm]];
  end
end
xset('thickness',thick)
xset('alufunction',alu)
datas=[datas;cliprect]
pause
xclip(cliprect(1),clirect(2),cliprect(3),cliprect(4))
