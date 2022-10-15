function [m,pt,btn]=getmenu(datas,pt)
// getmenu - teste si un point designe correspond a un menu
//%Syntaxe
// n=getmenu(datas)
//%Parametres
// pt    : coordonnees du point designe
// datas : informations sur les menus generees par drawmbar
// m     : numero du menu designe ou 0
//!
// origine S Steer INRIA 1993
[lhs,rhs]=argn(0)
n=size(datas,1)-3
if rhs<2 then
  [btn,xc,yc]=xclick()
  pt=[xc,yc]   
end
test1=datas(1:n,:)-ones(n,1)*[xc xc yc yc]
m=find(test1(:,1).*test1(:,2)<0&test1(:,3).*test1(:,4)<0 )
if m==[],m=0,end

function hilitemenu(m,datas)
xclip()
c=datas(m,:)
xm=c(1),ym=c(3),lm=c(2)-c(1);hm=c(3)-c(4)
thick=xget('thickness');xset('thickness',6)
xrect(xm,ym,lm,hm)
xset('thickness',thick)
xclip(datas(size(datas,1)-2,:))

function unhilitemenu(m,datas)
xclip()
c=datas(m,:)
xm=c(1),ym=c(3),lm=c(2)-c(1);hm=c(3)-c(4)
thick=xget('thickness');xset('thickness',6)
xrect(xm,ym,lm,hm)
xset('thickness',thick)
xclip(datas(size(datas,1)-2,:))

function setmenubar(datas,menus)
xclip()
wid=xget("white")
alu=xget('alufunction')
xset('alufunction',6)
nm=prod(size(menus))
[w,klm]=maxi(length(menus));
b=xstringl(0,0,menus(klm));
for km=1:nm
  x=datas(km,1);lm=datas(km,2)-x;ym=datas(km,3);hm=-datas(km,4)+ym
  xrects([x;ym;lm;hm],wid+1)
  xstringb(x,ym-hm+(b(4)-b(2))/2,menus(km),lm,hm)
end
xset('alufunction',alu)
xclip(datas(nm+1,:))

function erasemenubar(datas)
nm=size(datas,1)-3
xclip()
mrect=datas(nm+2,:)
xclea(mrect(1),mrect(2),mrect(3),mrect(4))
xclip(datas(nm+1,:))
