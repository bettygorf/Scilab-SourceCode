function []=fchamp(macr_f,fch_t,fch_xr,fch_yr,arfact,brect,flag)
//   Draw vector field in R^2,
//   Vector field defined by:
//   y=f(x,t,[u]), for compatibility with ode function
//    f : vector field. CAn be either :
//	 a function y=f(t,x,[u])
//       a list such as  list(f1,u1) with f1 a function
//       y=f1(t,x,u) and u1=current value of u
//    t : instants vector
//    xr,yr: two vectors defining the gridding
//    arfact : optional arg to control size of arrow heads,
//    flag : string ( same as  plot2d )
//Example : enter fchamp()
//!
// Copyright INRIA
[lhs,rhs]=argn(0);
if rhs <=0,s_mat=['deff(''[xdot] = derpol(t,x)'',[''xd1 = x(2)'';';
                 '''xd2 = -x(1) + (1 - x(1)**2)*x(2)'';';
                 '''xdot = [ xd1 ; xd2 ]'']);';
                 'fchamp(derpol,0,-1:0.1:1,-1:0.1:1,1);']
         write(%io(2),s_mat);execstr(s_mat);
         return;end;
if rhs <= 2,fch_xr=-1:0.1:1;end
if rhs <= 3,fch_yr=-1:0.1:1;end
if rhs <= 4,arfact=1.0;end
if rhs <= 5,brect=[-1,-1,1,1];end
if rhs <= 6,flag="061";end
[p1,q1]=size(fch_xr);
[p2,q2]=size(fch_yr);
if type(macr_f)==11 then comp(macr_f),end;
fch_rect=[fch_xr(1),fch_yr(1),fch_xr(q1),fch_yr(q2)];
if type(macr_f) <> 15,
  deff('[yy]=mmm(x1,x2)',['xx=macr_f(fch_t,[x1;x2])';'yy=xx(1)+%i*xx(2);']);
  fch_v=feval(fch_xr,fch_yr,mmm);
else
  mmm1=macr_f(1)
  deff('[yy]=mmm(x1,x2)',['xx=mmm1(fch_t,[x1;x2],macr_f(2));';
                          'yy=xx(1)+%i*xx(2);']);
  fch_v=feval(fch_xr,fch_yr,mmm);
end
  fch_vx=real(fch_v)
  fch_vy=imag(fch_v)
  champ(fch_xr,fch_yr,fch_vx,fch_vy,arfact,brect,flag);




