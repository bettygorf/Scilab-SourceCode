function xgrid(nax,style,strlog)
//xgrid - Rajoute une grille sur un graphique 2D
//%Syntax
// xgrid(nax,[style])
//%Parameter
// nax=[n1,n2], ou n1 et n2 sont respectivement le nombre
//              d'intervalles demand\'es pour l'axe des x 
//              et l'axe des y
// style      : style du trait utilise pour le quadrillage
//              voir xset('dashes',style);
//              valeur par defaut 0
//%Exemple 
//  taper xgrid() pour voir un exemple.
//  plot2d(<0;5>,<0;10>);xgrid(<5,10>)
//!
[lhs,rhs]=argn(0)
if rhs=0 then
  write(%io(2),'plot2d1(''oll'',[0.1,1,10,100,1000]'',...');
  write(%io(2),'  [0.1,1,10,100,1000]'');xgrid([4,4],0,''ll'')');
  plot2d1('oll',[0.1,1,10,100,1000]',[0.1,1,10,100,1000]');
  xgrid([4,4],0,'ll');
  return;
end
if rhs<3;strlog='nn';end
if rhs<2;style=0;end
xxx=xget('dashes');
xset('dashes',style);
[irect,frect]=xgetech();nx=nax(1);ny=nax(2);
xmin=frect(1);xmax=frect(3);ymin=frect(2);ymax=frect(4);
if nx>=1 then
  xx=(1/nx)*(1:nx-1);
  xsegs([ xmin*xx+xmax*(ones(xx)-xx); xmin*xx+xmax*(ones(xx)-xx)],...
      [ ymin*ones(xx);ymax*ones(xx)]);
end
if ny>=1 then
  xx=(1/ny)*(1:ny-1);
  xsegs([ xmin*ones(xx);xmax*ones(xx)],...
      [ ymin*xx+ymax*(ones(xx)-xx); ymin*xx+ymax*(ones(xx)-xx)]);
end
// x-axis
if part(strlog,1)='l' then 
  if prod(size(xmin:(xmax-1))) > 20 then 
    write(%io(2),'Well are you sure you have log scale on x-axis');
    xset('dashes',xxx);
    return
  end
  zz=(1:9)',zz=exp(log(10)*(xmin:(xmax-1))).*.zz;
  n=prod(size(zz));zz=matrix(zz,n,1)';
  xsegs([ log(zz)/log(10);log(zz)/log(10)],[ ymin*ones(zz);ymax*ones(zz)]);
end
// y-axis
if part(strlog,2)='l' then 
  if prod(size(ymin:(ymax-1))) > 20 then 
    write(%io(2),'Well are you sure you have log scale on y-axis');
    xset('dashes',xxx);
    return
  end
  zz=(1:1:9)',zz=exp(log(10)*(ymin:(ymax-1))).*.zz;
  n=prod(size(zz));zz=matrix(zz,n,1)';
  xsegs([xmin*ones(zz);xmax*ones(zz)],[log(zz)/log(10);log(zz)/log(10)]);
end
xset('dashes',xxx);
