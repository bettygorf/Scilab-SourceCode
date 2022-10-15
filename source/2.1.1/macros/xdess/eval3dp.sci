function [x,y,z]=eval3dp(fun,p1,p2)
// eval3d - retourne une representation par facettes d'une fonction z=f(u,v)
//%Syntaxe
//  [x,y,z]=eval3dp(fun,p1,p2)
//%Parametres
//  fun    : macro (de syntaxe : [x,y,z]=fun(p1,p2) ) definissant la 
//           fonction f .
//           Attention lors de l'appel de fun p1 et p2 sont des vecteurs
//           et la macro doit retourner x,y,z tels que :
//           [x(i),y(i),z(i)]=f(p1(i),p2(i))
//
//  p1     : vecteur reel donnant la discretisation des valeurs du 
//           parametre u
//  p2     : vecteur reel donnant la discretisation des valeurs du 
//           parametre v
//  x      : matrice 4xn dont chaque colonne contient les abscisses
//           d'une facette
//  y      : matrice 4xn dont chaque colonne contient les ordonnees
//           d'une facette
//  z      : matrice 4xn dont chaque colonne contient les cotes
//           d'une facette
//%Exemple
//  deff('[x,y,z]=scp(p1,p2)',['x=p1.*sin(p1).*cos(p2)';
//                             'y=p1.*cos(p1).*cos(p2)';
//                             'z=p1.*sin(p2)'])
//  [x,y,z]=eval3dp(scp,0:0.3:2*%pi,-%pi:0.3:%pi);
//  fac3d(x,y,z,35,45,'x@y@z')
//%Voir aussi
// plot3d eval3d fac3d
//!
//origine S Steer INRIA 1990
//
n1=prod(size(p1))
n2=prod(size(p2))
//on calcule la valeur de la fonction en tous le couples (p1(i),p2(j))
[vx,vy,vz]=fun(ones(1,n2).*.matrix(p1,1,n1),matrix(p2,1,n2).*.ones(1,n1))
p1=[];p2=[];
 
//on genere les facettes
ind=ones(1,n1-1).*.[0 1 n1+1 n1]+ (1:n1-1).*.[1 1 1 1]
// ind=[1,2,n1+2,n1+1 , 2,3,n1+3,n1+2, ....  ,n1-1,n1,2n1,2n1-1
 
x=[];y=[];z=[];n=n1*n2
for l=1:n2-1
  x=[x vx(ind)];vx=vx(n1+1:n)
  y=[y vy(ind)];vy=vy(n1+1:n)
  z=[z vz(ind)];vz=vz(n1+1:n)
  n=n-n1
end
nx=prod(size(x))
x=matrix(x,4,nx/4)
y=matrix(y,4,nx/4)
z=matrix(z,4,nx/4)
//end


