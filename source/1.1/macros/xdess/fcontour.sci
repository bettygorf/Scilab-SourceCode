//[]=fcontour_(xr,yr,f,nz,teta,alpha,legend,flag,bbox,zlev)
//[]=fcontour_(xr,yr,f,nz,[teta,alpha,legend,flag,bbox,zlev])
// Trace des courbes de niveau de la surface
// d\'efinie par un external f  ( ex macro [y]=f(x))
// on calcule d'abord f sur la grille definie par xr.yr
// xr et yr sont des vecteurs implicites donnant les
// abscisses et les ordonn\'ees des points de la grille
// - x est une matrice de taille (1,n1)
// - y est une matrice de taille (1,n2)
// nz : permet de specifier les niveaux cherches 
//    si nz est un nombre c'est le nombre de courbes de niveau demandees
//	regulierement espacees entre zmin et zmax 
//    si est un vecteur, il specifie les valeurs de z pour lesquelles
//      on veut les courbes de niveau
//
// Les arguments suivants sont optionnels et sont identiques a ceux de 
//    plot3d (sauf zlev), il permettent de dessiner des courbes de niveau
//    sur  un graphique 3d. 
//    Seule la signification de flag(1) est differente :
//     flag(1)=0, les courbes de niveaux sont dessinees 
//         sur un graphique 3d, sur la surface definie par (x,y,z)
//     flag(1)=1, les courbes de biveaux sont dessinees 
//         sur un graphique 3d, sur le plan defini par z=zlev
//     flag(1)=2, les courbes de biveaux sont dessinees 
//         sur un graphique 2d.
// Exemple : taper fcontour() pour voir un exemple .
// deff('[z]=surf(x,y)','z=x**2+y**2');
// fcontour(surf,-1:0.1:1,-1:0.1:1,10);
//
//!
[lhs,rhs]=argn(0);
if rhs=0,s_mat=['deff(''[z]=surf(x,y)'',''z=x**2+y**2'');';
                'fcontour(-1:0.1:1,-1:0.1:1,surf,10);'];
         write(%io(2),s_mat);execstr(s_mat);
         return;end;
if rhs<3,write(%io(2),[' I need at least 3 arguments';
                       'or zero to have a demo']);
return;end
if rhs<4,nz=10,end;
if rhs<5,teta=35,end;
if rhs<6,alpha=45,end;
if rhs<7,leg="X@Y@Z",end;
if rhs<8,flag=[2,2,3],end;
if rhs<9,bbox=0*ones(1,6),end;
if rhs<10,zlev=0;end
if type(f)=11 then comp(f),end;
Contour(xr,yr,feval(xr,yr,f),nz,teta,alpha,leg,flag,bbox,zlev);
//end


