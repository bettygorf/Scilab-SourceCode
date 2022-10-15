function []=chart(attenu,angl)
titre='amplitude and phase contours of y/(1+y)'
l10=log(10);
ratio=%pi/180;
//
[lhs,rhs]=argn(0)
select rhs
case 2 then,
  angl=-angl*ratio
case 1 then
  angl=-[1:10,20:10:160]*ratio;
else
  attenu=[-12 -8 -6 -5 -4 -3 -2 -1.4 -1 -.5 ,..
                       0.25 0.5 0.7 1 1.4 2 2.3 3 4 5 6 8 12];
  angl=-[1:10,20:10:160]*ratio
end
//
//
rect=[-360,-50,0,40];
//
plot2d(0,0,[-1],"011"," ",rect,[2,6,3,9]);
xtitle(titre,'phase(y) - degree','magnitude(y) - db')
llrect=xstringl(0,0,'1')
//contours de gain constant
lambda=exp(l10*attenu/20)
rayon=lambda./(lambda.*lambda-ones(lambda))
centre=-lambda.*rayon
//
for i = 1:prod(size(attenu)),
  if attenu(i)<0 then 
    w=%eps:0.03:%pi;
  else 
    w=-%pi:0.03:0;
  end;
  n=prod(size(w))
  rf=centre(i)*ones(w)+rayon(i)*exp(%i*w);
  phi=atan(imag(rf),real(rf))/ratio;
  module=20*log(abs(rf))/l10;
  plot2d([-360*ones(phi)-phi(n:-1:1) phi]',...
     [module(n:-1:1) module]',[-1,1],"000"," ",rect);
  att=attenu(i);
  if att<0 then 
    xstring(phi(n)+llrect(3),module(n),string(att),0,0);
  else 
    xstring(phi(1),module(1)+llrect(4)/4,string(att),0,0);
  end
end;
//
//phase

eps=100*%eps
for teta=angl,
  if teta<-%pi/2 then
    last=teta-eps,
  else
    last=teta+eps,
  end;
  w=[-170*ratio:0.03:last last]'
  n=prod(size(w));
  k=sin(teta)/cos(teta)
  module=real(20*log((sin(w)-k*cos(w))/k)/l10)
  w=w/ratio
  plot2d([w,-360*ones(w)-w(n:-1:1)],[module,module(n:-1:1)],[-1,-1],"000");
end;
