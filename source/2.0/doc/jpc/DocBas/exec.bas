if posok=1,driver("Pos");end;

//<>=xgrid(nax)
//<>=xgrid(nax)
// Rajoute une grille sur un graphique 2D 
//  ( champ plot2d)
// nax=<n1,n2>, ou n1 et n2 sont respectivement le nombre 
// d'intervalles demand\'es pour l'axe des x et l'axe des y 
// 
// Exemple : taper xgrid() pour voir un exemple.
//           plot2d(<0;5>,<0;10>);xgrid(<5,10>)
//!
if posok=1,xinit('xgrid.');end
xgrid();halt();xclear();xend();

//<>=xtitle(xtit,xax,yax,encad)
//<>=xtitle(xtit,xax,yax,encad)
// Rajoute un titre sur un graphique 2D 
// xtit,xax,yax : 3 cha\i{i}nes de caract\`eres donnant respectivement 
// le titre g\'en\'eral, le titre pour l'axe des x et le titre pour 
// l'axe des y.
// Exemple : taper xtitle() pour voir un exemple 
//         plot2d(<0;5>,<0;10>);xtitle("Titre","x","y",0);
//!
if posok=1,xinit('xtitle.');end
xtitle();halt();xclear();xend();

//<>=contour(x,y,z,nz)
//<>=contour(x,y,z,nz)
// Trace nz courbes de niveau de la surface 
// z=f(x,y) d\'efinie par une matrice de  points : 
// - z est une matrice de taille (n1,n2)
// - x est une matrice de taille (1,n1)
// - y est une matrice de taille (1,n2)
// z(i,j) donne la valeur de f au point (x(i),y(j))
// Exemple : taper contour() pour voir un exemple .
//         Contour(1:5,1:10,rand(5,10),5);
//!
if posok=1,xinit('contour.');end
contour();halt();xclear();xend();

//<x>=fcontour(f,xr,yr,nz)
//<x>=fcontour(f,xr,yr,nz)
// Trace nz courbes de niveau de la surface d\'efinie 
// par une macro <z>=f(x,y)
// on calcule d'abord f sur une grille qui est renvoy\'ee
// dans la valeur de retour
// xr et yr sont des vecteurs implicites donnant les 
// abscisses et les ordonn\'ees des points de la grille
// Exemple : taper fcontour() pour voir un exemple .
// deff('<z>=surf(x,y)','z=x**2+y**2');
// fcontour(surf,-1:0.1:1,-1:0.1:1,10);
// 
//!
if posok=1,xinit('fcontour.');end
fcontour();halt();xclear();xend();

//<>=fplot2d(f,xr,style,strf,leg,rect,nax)
//<>=fplot2d(f,xr,[style,strf,leg,rect,nax])
// Dessin d'une courbe 2D d\'efinie par une macro <y>=f(x) 
// on trace un aproximation lin\'eaire par morceaux de la courbe
// y=f(x), passant par les points (xr(i),f(xr(i)))
// xr est donc un vecteur implicite donnant les points ou l'on calcule f.
// pour les autres arguments qui sont optionnels, on se reportera \`a 
// plot2d.
// Exemple~: taper fplot2d() pour voir un exemple.
// deff('<y>=f(x)','y=sin(x)+cos(x)');
// fplot2d(f,0:0.1:%pi);
//!
if posok=1,xinit('fplot2d.');end
fplot2d();halt();xclear();xend();

//<z>=fplot3d(f,xr,yr,teta,alpha,leg,flag)
//<z>=fplot3d(f,xr,yr,teta,alpha,leg,[flag])
// Trace la surface d\'efinie par une macro <z>=f(x,y)
// on calcule d'abord f sur une grille qui est renvoy\'ee
// dans la valeur de retour (z).
// xr et yr sont des vecteurs implicites donnant les 
// abscisses et les ordonn\'ees des points de la grille
// -teta, alpha : sont les angles en coordonn\'ees spheriques du
//      point d'observation 
// -flag (voir plot3d)
// Exemple : taper fplot3d() pour voir un exemple
// deff('<z>=surf(x,y)','z=x**2+y**2');
// res=fplot3d(surf,-1:0.1:1,-1:0.1:1,35,45,"X@Y@Z",<2,1>);
//!
if posok=1,xinit('fplot3d.');end
fplot3d();halt();xclear();xend();

//<>=plot3d(x,y,z,teta,alpha,leg,flag)
//<>=plot3d(x,y,z,teta,alpha,leg,[flag])
// Trace la surface f(x,y) d'efinie par une matrice de point
// - z est une matrice de taille (n1,n2)
// - x est une matrice de taille (1,n1)
// - y est une matrice de taille (1,n2)
// z(i,j) donne la valeur de f au point (x(i),y(j))
// -teta, alpha : sont les angles en coordonn\'ees spheriques du
// point d'observation.
// -leg : la legende pour chaque axe. C'est une chaine de caracteres 
//      avec @ comme s\'eparateur de champ, par exemple : "X@Y@Z"
// flag=<mode,type>
//   mode >=2 -> elimination parties cachees mode 
//               (surface plus ou moins grisee en fonction du nombre choisi)
//   mode = 1 trace en mode filaire (avec parties cachees)
// type =0 on superpose (les echelles utilis\'ees sont les m\^eme que lors de 
//         l'appel precedent).
// Exemple : taper plot3d() pour voir un exemple.
// plot3d(1:10,1:20,10*rand(10,20),35,45,"X@Y@Z",<2,1>)
//!
if posok=1,xinit('plot3d.');end
plot3d();halt();xclear();xend();

//<>=plot3d1(x,y,z,teta,alpha,leg,flag)
//<>=plot3d1(x,y,z,teta,alpha,leg,[flag])
// m\^eme chose que plot3d mais le niveau de gris utilise est fonction 
// de la valeur de z sur la surface.
// Exemple :
// plot3d1(1:10,1:20,(1:10)'.*.(1:20),35,45,"X@Y@Z",<2,1>)
//!
if posok=1,xinit('plot3d1.');end
plot3d1();halt();xclear();xend();

//<>=param3d(x,y,z,teta,alpha,leg,flag)
//<>=param3d(x,y,z,teta,alpha,leg,[flag])
//
// Trace un courbe param\'etrique 3D d\'efinie par 
// une suite de points (x(i),y(i),z(i)),i=1,n
// -x,y,z sont trois vecteurs de taille (1,n)
// 
// -teta, alpha : sont les angles en coordonn\'ees spheriques du
// point d'observation.
//
// -leg : la legende pour chaque axe. C'est une chaine de caracteres 
//      avec @ comme s\'eparateur de champ, par exemple : "X@Y@Z"
//
// -flag : si flag vaut 0 les echelles utilis\'ees sont les m\^eme
//       que lors de  l'appel precedent).
// Exemple : taper param3() pour voir un exemple
// t=0:0.1:5*%pi;
// param3d(sin(t),cos(t),t/10,35,45,"X@Y@Z",1)
//!
if posok=1,xinit('param3d.');end
param3d();halt();xclear();xend();


//<>=fchamp(macr_f,fch_t,fch_xr,fch_yr,arfact,flag)
//<>=fchamp(f,t,xr,yr,fax,arfact)
//   Visualisation de champ de vecteur dans R^2,
//   Les champs de vecteur que l'on visualise seront d\'efinis sous
//   la forme <y>=f(x,t,[u]), pour \^etre compatible avec la macro ode
//    f : le champ de vecteur . Peut etre soit :
//	 une macro donnant la valeur d'un champ en un point x,<y>=f(t,x,[u])
//       un object de type liste list(f1,u1) ou f1 est une macro de type
//        <y>=f1(t,x,u) et u1 est la valeur que l'on veut donner a u 
//    t : est la date \`a laquelle on veut le champ de vecteur.
//    xr,yr: deux vecteurs implicites donnant les points de la grille
//      ou on veut visualiser le champ de vecteur.
//    arfact : un argument optionnel qui permet de controler la taille
//      de la tete des fleches qui indique la valeur du champ (1.0 par defaut)
//    flag : chaine de caractere 
//          "0" pas d'indication sous les axes 
//          "1" les valeur de xr et yr son rajoutees en indications 
//              sous les axes 
//          "2" on utilise le cadre et les indications sous les axes
//              en utilisant les valeurs d'un appel 
//  	       precedent  ou d'un appel a  xsetech 
//Exemple : taper fchamp pour voir un exemple 
//     deff('<xdot> = derpol(t,x)',<'xd1 = x(2)';
//     'xd2 = -x(1) + (1 - x(1)**2)*x(2)';
//     'xdot = < xd1 ; xd2 >'>);
//      fchamp(derpol,0,-1:0.1:1,-1:0.1:1,1);
//!
if posok=1,xinit('fchamp.');end
fchamp();halt();xclear();xend();

//<>=champ(fx,fy,arfact,rect,flag)
//<>=champ(fx,fy,[arfact=1.0,rect=<xmin,ymin,xmax,ymax>,last])
// Draw a vector field of dimension 2
//  -fx and fy are (p,q) matrix which give the vector field 
//     fx and fy values on a regular grid 
//     Warning fx(i,j) is the value of the field along the x-axis
//     for the point X=(i,j)
//  -if rect is present then it gives the range to use on xaxis
//      and yaxis rect= <xmin,ymin,xmax,ymax>
//  -arfact : optional argument to control the size of arrow head 
//            the arrow head size is multiplied by arfact 
//  -flag : "0" No axis 
//          "1" axis using the value of rect
//          "2" axis and rectangle using previous call.
// Ex : taper champ pour voir un exemple
//   champ(rand(10,10),rand(10,10),1,<0,0,10,10>)
//!
if posok=1,xinit('champ.');end
champ();halt();xclear();xend();

//<>=plot2d(x,y,style,strf,leg,rect,nax)
//<>=plot2d(x,y,[style,strf,leg,rect,nax])
//
// plot2d dessine simultanement un ensemble de courbes 2D.
// Arguments minimaux : x et y 
// 
// x et y sont deux matrices de taille <nl,nc>.
//   nc : est le nombre de courbes nl : le nombre de points de
//   chaque courbe.
// par exemple : x=< 1:10;1:10>',y= < sin(1:10);cos(1:10)>' 
// 
// Arguments optionnels :
//
//   -style : est un vecteur de taille nc ( le nombre de courbes )
//       il definit le style de chaque courbe.
//       si style[i] est positif la ieme courbe est tracee avec la 
//           marque de numero style[i]
//       si style[i] est < 0 un trace ligne est utilise le type de la ligne
//           est alors donne par abs(style[i])
//       Dans le cas particulier ou l'on ne dessine qu'une courbe 
//       style sera donne sous la forme <style,pos> ou style est le style
//         a utiliser et pos donne la position a utiliser pour
//         la legende de la courbe ( 6 positions posibles)
//   -strf="xyz" : chaine de caracteres de longueur 3.
//     x : controle le display des legendes si x=1 on ajoute des legendes
//        qui sont donnees dans l'argument leg="leg1@leg2@...."
//     y : controle l'echelle du graphique 
//        si y=1 les valeurs stockees dans l'argument rect sont utilisees
//           pour definir le cadre  rect=<xmin,ymin,xmax,ymax>
//        si y=2 le cadre est calcule en fonction des donnees.
//        sinon le cadre qui a ete utilise lors d'un appel precedent 
//           est a nouveau utilise 
//     z : controle du cadre 
//        si z=1 : un axe gradue est rajoute le nombre d'intervalle est 
//        donne par l'argument nax. nax est un vecteur de dimension 4.
//        par exemple si nax=<3,7,2,8>, l'axe des x sera subdivise en 7 
//        intervalles pour lequels une valeur numerique sera ecrite 
//        chacun des 7 intervalles sera divise en 3 sous intervalles 
//        (resp. 8,2 pour l'axe des y)
//        si z=2 : on rajoute juste un boite autour du graphique
//        sinon  : rien n'est rajoute 
// 
//Exemple : taper plot2d() pour voir un exemple
//          x=0:0.1:2*%pi;
//  [1]    plot2d(<x;x;x>',<sin(x);sin(2*x);sin(3*x)>');
//  [2]    plot2d(<x;x;x>',<sin(x);sin(2*x);sin(3*x)>',...
//           <-1,-2,3>,"111","L1@L2@L3",<0,-2,2*%pi,2>,<2,10,2,10>);
//!
if posok=1,xinit('plot2d.');end
plot2d();halt();xclear();xend();

//<>=plot2d1(str,x,y,style,strf,leg,rect,nax)
//<>=plot2d1(str,x,y,[style,strf,leg,rect,nax])
// Same as plot2d but with one more argument 
// str ="abc"
//   str[1]= e | o | g 
//      if w = e  , e stands for empty the value of x is not used and can 
//                    be omited  plot2d1("enn",1,...)   
//      if w = o  , o stands for one : if there are many curves they all 
//                    have the same x-values ( x is of size x(n,1) and y 
//                    of size y(n,n1);
//		      plot2d1("onn",(1:10)',<sin(1:10);cos(1:10)>')
//	if w = g  , g stands for general x is of size (n,n1)
//   str[2] and str[3] = n | l 
//                  if str[2]=l : logarithmic axes are used on the X-axis
//                  if str[3]=l : logarithmic axes are used on the Y-axis
//	
//   See plot2d for the other arguments
// 
//!
if posok=1,xinit('plot2d1.');end
plot2d1();halt();xclear();xend();

//<>=plot2d2(str,x,y,style,strf,leg,rect,nax)
//<>=plot2d2(str,x,y,[style,strf,leg,rect,nax])
// Same as plot2d1 but with piece-wise constant style
//!
if posok=1,xinit('plot2d2.');end
plot2d2();halt();xclear();xend();


//<>=plot2d3(str,x,y,style,strf,leg,rect,nax)
//<>=plot2d3(str,x,y,[style,strf,leg,rect,nax])
// Same as plot2d1 but curves are plotted using vertical bars 
// style are dashed-line styles
//!
if posok=1,xinit('plot2d3.');end
plot2d3();halt();xclear();xend();

//<>=plot2d4(str,x,y,style,strf,leg,rect,nax)
//<>=plot2d4(str,x,y,[style,strf,leg,rect,nax])
// Same as plot2d1 but curves are plotted using arrows 
// style are dashed-line styles
//!
if posok=1,xinit('plot2d4.');end
plot2d4();halt();xclear();xend();


//<>=errbar(x,y,em,ep)
//<>=errbar(x,y,em,ep)
// Rajoute des barres d'erreur sur un graphique 2D
// x et y decrivent les courbes (voir plot2d)
// em et ep sont deux matrices la barre d'erreur au point 
// <x(i,j),y(i,j)> va de <x(i,j),y(i,j)-em(i,j)> a <x(i,j),y(i,j)+em(i,j)>
// x,y,em et ep sont donc des matrices (p,q), q courbes contenant chacunes 
// p points. 
// Exemple : taper errbar()
//      x=0:0.1:2*%pi;
//   y=<sin(x);cos(x)>';x=<x;x>';plot2d(x,y);
//   errbar(x,y,0.05*ones(x),0.03*ones(x));
if posok=1,xinit('errbar.');end
errbar();halt();xclear();xend();

//<x1,y1,rect>=xchange(x,y,dir)
//<x1,y1,rect>=xchange(x,y,dir)
// Apres avoir utilise une fonction graphique ou la fonction 
// xsetech cette fonction permet de passer de coordonn\'ees 
// r\'eelles en coordonn\'ees pixel et inversement suivant 
// la valeur du param\`etre dir 
// dir = 'f2i' ou 'i2f' ( float to int ou int to float)
// le troisi\`eme argument de retour est rect qui indique 
// le rectangle en pixel dans lequel l'echelle a \'et\'e fix\'ee 
// voir xsetech.
//!


//<>=xsetech(frect,irect)
//<>=xsetech(frect,irect)
// Si apr\`es avoir utilis\'e cette fonction 
// on appelle plot2d avec l'option y=0 (strf="xyz")
// les echelles seront fix\'ees de la facon suivante :
//   le graphique sera effectue dans le rectangle 
//      irect=<x,y,width,height> en pixel. 
//   Et ce rectangle correspondra aux intervalles r\'eels 
//   d\'efinis par frect=<xmin,ymin,xmax,ymax>
//!


//<frect,irect>=xgetech()
//<frect,irect>=xgetech()
// cette fonction permet de connaitre les echelles qui ont \'et\'ees
// fix\'ees par xsetech ou par un appel \`a une fonction graphique
//!

//<>=xtape(str)
//<>=xtape(str)
// str='on' or 'replay' or 'clear'
//!

quit
