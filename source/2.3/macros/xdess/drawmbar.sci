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
pat =xget('pattern') 
realblack=xget('lastpattern')+1;
colInc=0
colored=xget('use color')==1
[r1,r2]=xgetech();
thick=xget('thickness');
if ~colored then 
  xset('thickness',2),
  back=xget('lastpattern')
  butt=back
else
  cmap=xget('colormap')
  ncol=size(cmap,'r')
  ncolkp = ncol
  cbutt=[255 255 0]/255
  k2=find(abs(cmap-ones(ncol,1)*cbutt)*ones(3,1)<=1.d-5)
  if k2==[] then 
    cmap=[cmap;cbutt],
    ncol=ncol+1
    butt=ncol
    colInc = 1
  else
    butt=k2
  end
  cback=[173 216 230]/255
  k1=find(abs(cmap-ones(ncol,1)*cback)*ones(3,1)<=1.d-5)
  if k1==[] then 
    cmap=[cmap;cback];
    ncol=ncol+1;
    back=ncol;
    colInc = colInc + 1
  else
    back=k1
  end
  if k1==[]|k2==[] then
    xset('colormap',cmap)
    realblack=xget('lastpattern')+1;
    // This is a bit tricky. 
    // xset('colormap',cmap) will change  the default color 
    // we want to reset it to its entry value (pat ) 
    // except if the pat value was lastpattern+1 (black)
    if pat == ncolkp+1 then 
	pat = pat + colInc
    end
  end
end
alu=xget('alufunction')
xset('alufunction',3)
xclip()
win=xget('window')
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
  cliprect=[r2(1)-xshift,r2(4)+yshift-(hm+7/3*dym),..
      r2(3)-r2(1)+2*xshift,r2(4)-r2(2)+2*yshift-(hm+7/3*dym)]
  mrect=[r2(1)-xshift,r2(4)+yshift,r2(3)-r2(1)+2*xshift,hm+7/3*dym]
  xrects(mrect',back)
  xrects(mrect',-1)
  for km=0:nm-1
    x=xm+km*(lm+dxm)
    xrects([x;ym;lm;hm],butt)
    xrects([x;ym;lm;hm],-1)
    xset('pattern',realblack);
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
      xm-dxm*4/3-(r2(1)-xshift),r2(4)-r2(2)+2*yshift]
  mrect=[xm-dxm*4/3,r2(4)+yshift,lm+dxm*7/3,r2(4)-r2(2)+2*yshift]
  xrects(mrect',back)
  xrects(mrect',-1)
  for km=0:nm-1
    y=ym-km*(hm+dym);
    xrects([xm;y;lm;hm],butt);
    xrects([xm;y;lm;hm],-1);
    xset('pattern',realblack);
    xstringb(xm,y-hm+(b(4)-b(2))/2,menus(km+1),lm,hm);
    datas=[datas;[xm,xm+lm,y,y-hm]];
  end
end
xset('thickness',thick)
datas=[datas;cliprect;mrect;[win 0 0 0]]
wdp=xget('pixmap')
if wdp=1,xset('wshow');end
xclip(cliprect)
//if colored then 
//  xset('colormap',cmap(1:ncol,:))
//end
xset('alufunction',alu)
xset('pattern',pat)


