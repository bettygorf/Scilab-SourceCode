//[]=isoview(xmin,xmax,ymin,ymax)
//isoview(xmin,xmax,ymin,ymax) permet de configurer les parametres du
//traceur de courbes  pour obtenir un graphique isometrique contenant
//contenant au moins le rectangle (xmin,ymin) (xmax,ymax)
//
//A la difference de la macro square, isoview ne modifie ni  la taille
//du graphique  ni les facteurs  de zoom  (dess(69:70)). La macro agit
//uniquement sur les extrema du dessin.
//Les extrema sont imposes.
//!
//origine S Steer INRIA 1988
//modifie jpc 1992
//
xselect();
wdim=xget("wdim");hhx=wdim(1);hhy=wdim(2);
hx=xmax-xmin
hy=ymax-ymin
if hx/hhx <hy/hhy then
   hx1=hhx*hy/hhy
   xmin=xmin-(hx1-hx)/2
   xmax=xmax+(hx1-hx)/2
else
   hy1=hhy*hx/hhx
   ymin=ymin-(hy1-hy)/2
   ymax=ymax+(hy1-hy)/2
end
plot2d(0,0,-1,"010"," ",[xmin,ymin,xmax,ymax]);
//end


