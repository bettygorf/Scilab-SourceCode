str_l=list();

str_l(1)=['t=(0:0.1:6*%pi);';
      'plot2d(t'',sin(t)'');'
      'xtitle(''plot2d and xgrid '',''t'',''sin(t)'');';
      'xgrid([10,10],2);'];


str_l(2)='histplot()';


str_l(3)=['t=-50*%pi:0.1:50*%pi;';
      'x=t.*sin(t);y=t.*cos(t);z=t.*abs(t)/(50*%pi);';
      'param3d(x,y,z,45,60);';
      'title=[''param3d : parametric curves in R3'',';
      ''' (t.sin(t),t.cos(t),t.|t|/50.%pi)''];';
      'xtitle(title,'' '','' '');'];


str_l(4)=['plot3d1();';
      'title=[''plot3d1 : z=sin(x)*cos(y)''];';
      'xtitle(title,'' '','' '');'];


str_l(5)=['contour();';
      'title=[''contour ''];';
      'xtitle(title,'' '','' '');'];


str_l(6)=['champ();';
      'title=[''champ ''];';
      'xtitle(title,'' '','' '');'];

str_l(7)=['t=%pi*(-10:10)/10;';
          'deff(''[z]=surf(x,y)'',''z=sin(x)*cos(y)'');';
          'rect=[-%pi,%pi,-%pi,%pi,-5,1];';
          'z=feval(t,t,surf);';
          'contour(t,t,z,10,35,45,''X@Y@Z'',[1,1,0],rect,-5);';
          'plot3d(t,t,z,35,45,''X@Y@Z'',[2,1,3],rect);';
          'title=[''plot3d and contour ''];';
          'xtitle(title,'' '','' '');'];

for i=1:7,xinit('d7.11.ps'+string(i)');
          execstr(str_l(i)),xend();end



