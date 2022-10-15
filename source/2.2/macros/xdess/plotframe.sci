function plotframe(rect,axisdata,flags,legs) 
// plotframe - trace les echelles et le quadrillage d'un  graphique
//%Syntaxe
//  plotframe(rect,axisdata,flags,legs) 
//%Parametres
//  rect    : vecteur [xmin,ymin,xmax,ymax] contenant bornes minimales 
//            du graphique souhaite
//  axisdata: vecteur [nx,mx,ny,my] ou mx, my  sont respectivement  le 
//            nombre d'intervalles decoupant l'axe des abscisse et des
//            ordonnees, nx,ny sont les nombres de sous-intervalles 
//            correspondant.
//  flags   : vecteur [quad,bounds] ou quad est un boolean qui indique
//            si l'on souhaite des quadrillages et bounds un booleen qui
//            indique si l'on autorise la modification des bornes donnees
//            dans rect pour obtenir des graduation plus simple. (dans ce
//            cas axisdata est ignore
//!
[lhs,rhs]=argn(0)
if rhs<=2 then
  flags=[%f %f]
  nleg=0
elseif rhs==3 then
  if type(flags)==1 then
    nleg=0
  else
    legs=flags
    nleg=prod(size(legs))
    flags=[%f %f]
  end
else
  nleg=prod(size(legs))
end
if nleg <3 then 
  for i=nleg+1:3,legs(i)=' ',end
end
if type(flags)==1 then flags=flags<>0,end
if prod(size(flags))==1 then flags(2)=%f;end
// -- trace du cadre et des echelles
if flags(2) then
  [xmn,xmx,npx]=graduate(rect(1),rect(3),2,axisdata(2))
  [ymn,ymx,npy]=graduate(rect(2),rect(4),2,axisdata(4))
  rect=[xmn,ymn,xmx,ymx]
  axisdata(2)=npx;axisdata(4)=npy
end
plot2d(0,0,-1,'011',' ',rect,axisdata)
if nleg>0 then 
// -- trace des legendes d'axes et du titre
  xtitle(legs(1),legs(2),legs(3)),
end

if flags(1) then
// -- trace du quadrillage
  ix=axisdata(2)
  iy=axisdata(4)
  xgrid();
end
