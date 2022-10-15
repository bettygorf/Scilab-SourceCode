//[]=portr3d(fch,odem,xdim,npts,pinit)
//[]=portr3d(f,odem,[xdim,npts,pinit])
//
// permet de tracer le portrait de phase du syst\`eme dynamique
// dx/dt=f(t,x,[u]) ( u est un param\`etre contant )
// dans le cadre xdim=[xmin,xmax,ymin,ymax,zmin,zmax]
// Arguments:
//    f : le  champ du syst\`eme dynamique
//       est soit un nom de macro qui calcule la valeur du champ en un point x
//	     [y]=f(t,x,[u])
//       soit un object de type liste list(f1,u1) ou f1 est une macro de type
//        [y]=f1(t,x,u) et u1 est la valeur que l'on veut donner a u
//       soit une chaine de caract\`ere si le champ de vecteur
//       est donne par un programme fortran (voir  ode)
//
// Dans la forme d'appel par d\'efaut : portrait(fch) les valeurs
// du cadre  et les pas d'int\'egration sont demand\'es interactivement.
//
// Param\`etres optionnels :
//
// odem= is the type argument of ode it can be one
//       of the following character strings
//                'default' 
//                'adams'
//                'stiff'
//                'rgk'
//                'discrete'
//                'roots'
// npts=[nombre-de-points,pas] ->  sert \`a donner le nombre de points et
//          le pas pour l'int\'egration num\'erique.
//
// xdim=[xmin,xmax,ymin,ymax,zmin,zmax]  -> sert \`a donner le cadre du dessin
//
// enfin on peut donner les points de d\'epart des int\'egrations num\'eriques
// dans un vecteur : ils ne seront alors pas demand\'ees interactivement
// pinit -> sert \`a donner des points de d\'epart pour l'int\'egration
//          ex: pinit = [x0(1), x1(1); x0(2), x1(2);x0(3), x1(3)].
//!
ncnl=lines();
lines(0);
xselect();
[lhs,rhs]=argn(0);
// appel minimal
if rhs<=1,odem='default';end
//Version interactive
if rhs <= 2,
  xdim=x_mdialog('Graphic boundaries',...
            ['xmin';'xmax';'ymin';'ymax';'zmin';'zmax'],...
            ['0';'1';'0';'1';'0';'1']);
  xdim=evstr(xdim);xdim=xdim';
  // Test sur le cadre
  if xdim(2) <= xdim(1),
  write(%io(2),'Erreur:  xmin < xmax '),lines(ncnl(1));return,end
  if xdim(4) <= xdim(3),
  write(%io(2),'Erreur:  ymin < ymax '),lines(ncnl(1));return,end
  if xdim(6) <= xdim(5),
  write(%io(2),'Erreur:  zmin < zmax '),lines(ncnl(1));return,end
end
if rhs<=3,
  npts=x_mdialog('Requested points and step ',...
            ['n points';'step'],...
            ['100';'0.1']);
  npts=evstr(npts);npts=npts';
end
ylast=(1/2)*[xdim(2)+xdim(1),xdim(4)+xdim(3),xdim(6)+xdim(5)]';
if rhs<=4
// Boucle sur les points de depart
  go_on=1
  while go_on=1,
       ftest=1;
       while ftest=1,
	  n=x_choose(['New initial point';'Continue ode';'Quit'],"Choose ");
	  n=n-1;
          if n=-1,go_on=0;lines(ncnl(1));return;end
          if n=2,go_on=0;lines(ncnl(1));return;end
          if n=0;x0=x_mdialog(['Initial value inside the boundaries ';...
                               '['+ strcat(string(xdim)," ")+']'],...
                              ['x0';'y0';'z0'],...
                     [string(ylast(1));string(ylast(2));string(ylast(3))]);
                     x0=evstr(x0);end
          if n=1,x0=ylast;end
          ftest=desorb3d(odem,x0,npts,fch,xdim);
          if ftest=1;x_message('Initial value out of boundaris'),end
       end
  end
else
// Version sans poser de question
res=desorb3d(odem,pinit,npts,fch,xdim);
if res=1,write(%io(2),'Points hors du cadre elimines ');end;
end
lines(ncnl(1));
//end


//[res]=desorb3d(odem,x0,n1,fch,xdim);
//[res]=desorb3d(odem,x0,n1,fch,xdim);
// Calcule des orbites pour des points de
// depart donn\'es dans x0 et les dessine
// v\'erifie que les points de d\'epart sont a l'int\'erieur du
// cadre. Si l'un des points est a l'exterieur la valeur renvoy\'ee
// est 1
// renvoit aussi une valeur dans xlast ( le dernier point de la derniere
//  trajectoire)
//!
res=0
[nn1,n2]=size(x0);
if odem='discret', style=[0], else style=-1;end
//pause;
for i=1:n2,
    ftest=1;
    if x0(1,i) > xdim(2), ftest=0;end
    if x0(1,i) < xdim(1), ftest=0;end
    if x0(2,i) > xdim(4), ftest=0;end
    if x0(2,i) < xdim(3), ftest=0;end
    if x0(3,i) > xdim(6), ftest=0;end
    if x0(3,i) < xdim(5), ftest=0;end
    if ftest=0;res=1,ylast=x0,else
       write(%io(2),'Running ode ')
       if odem='default' then 
        y=ode([x0(1,i);x0(2,i);x0(3,i)],0,n1(2)*(0:n1(1)),fch);
       else
        y=ode(odem,[x0(1,i);x0(2,i);x0(3,i)],0,n1(2)*(0:n1(1)),fch);
       end;
       [nn1,n11]=size(y);
       // on coupe la trajectoire au temps d'arret T
       // T d'atteinte du bord du cadre
       [mi1,ki1]=mini(y(1,:),xdim(2)*ones(1,n11));
       [ma1,ka1]=maxi(y(1,:),xdim(1)*ones(1,n11));
       k1=maxi(ki1,ka1);
 
       [mi2,ki2]=mini(y(2,:),xdim(4)*ones(1,n11));
       [ma2,ka2]=maxi(y(2,:),xdim(3)*ones(1,n11));
       k2=maxi(ki2,ka2);

       [mi3,ki3]=mini(y(3,:),xdim(6)*ones(1,n11));
       [ma3,ka3]=maxi(y(3,:),xdim(5)*ones(1,n11));
       k3=maxi(ki3,ka3);
 
       [m11,k11]=maxi(k1);
       [m22,k22]=maxi(k2);
       [m33,k33]=maxi(k3)
       if k11=1,k11=n1(1);end
       if k22=1,k22=n1(1);end
       if k33=1,k33=n1(1);end
       kf=mini(k11,k22,k33);
       if kf=1, kf=n1(1),end
       param3d(y(1,1:kf),y(2,1:kf),y(3,1:kf),60,45,"X@Y@Z",[1,3],xdim);
       ylast=y(:,kf);
    end
end
[ylast]=resume(ylast)
//end


