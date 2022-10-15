function objs=drawpal(objs)
// drawpal - dessine une palette de blocks
//%Syntaxe
// datas=drawpal(objs)
//%Parametres
// objs   : liste dont le premier champ est le nom de la palette et les champs
//          suivant la description des blocks
// win    : numero de la fenetre
//!
//origine S Steer INRIA 1993
[lhs,rhs]=argn(0)
win_height=300
text_height=30
//compute blocks position
nm=size(objs)
lm=20
hm=20
dym=hm/6
dxm=lm/3
xm=lm
ym=hm
hmx=0
lmargin=hm
ym=lmargin

for km=1:nm-1
  o=objs(km+1);
  geom=o(2);sz=geom(2)
  if o(1)=='Text' then
    graphics=o(2);label=graphics(4);
    r=xstringl(0,0,label)
    sz=r(3:4)
    if ym+sz(2)*(1+2/7)>win_height-text_height then
      ym=lmargin
      xm=xm+hmx+dxm
      hmx=0
    end
    geom(2)=sz
    geom(1)=[xm+r(1),ym+r(2)]
    hmx=maxi(hmx,sz(1)*(1+2/7))
    ym=ym+sz(2)*(1+2/7)+dym
  elseif o(1)=='Block' then
    if ym+hm*sz(2)*(1+2/7)>win_height-text_height then
      ym=lmargin
      xm=xm+hmx+dxm
      hmx=0
    end
    geom(1)=[xm,ym];geom(2)=[lm,hm].*sz;
    hmx=maxi(hmx,lm*sz(1)*(1+2/7))
    ym=ym+hm*sz(2)*(1+2/7)+dym
  else
    pause
  end
  o(2)=geom;
  objs(km+1)=o
  ym=ym+hm*sz(2)*(1+2/7)+dym
end
wd=[maxi(400,xm+hmx+hmx/2),maxi(300,win_height)]
curwin=xget('window')
unsetmenu(curwin,'File',1) //clear
unsetmenu(curwin,'File',6) //close
unsetmenu(curwin,'File',5) //load
unsetmenu(curwin,'3D Rot.')
xset('wdim',wd(1),wd(2))
xsetech([-1 -1 8 8]/6,[0 0 wd(1) wd(2)])
for km=1:nm-1
  drawobj(objs(km+1));
end
wpar=objs(1)
rect=xstringl(0,wd(1),wpar(2))    
w=rect(3);h=rect(4)
x=(wd(1)-rect(3))/2
y=wd(2)-h

xstring(x,y,wpar(2))
