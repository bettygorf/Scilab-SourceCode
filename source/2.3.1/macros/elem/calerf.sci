function result=calerf(x,jint)
// calerf - core of erf,erfc,erfcx computation
//%SYNTAX
// result=calerf(x,jint)
//%PARAMETERS
// x : real vector
// result : real vector of same size
// jint   : 
//         =0 : y=erf(x)
//         =1 :  y=erfc(x)
//         =2 :  y=erfcx(x)
//%DESCRIPTION
// cal erf computes the error function:
//
//                      /x
//      y = 2/sqrt(pi) *|  exp(-t^2) dt
//                      /0
// or the complementary error function:
//
//                      /inf
//      y = 2/sqrt(pi) *|  exp(-t^2) dt
//                      /x
//      y = 1 - erf(x)
// or the scaled complementary error function:
//
//      y = exp(x^2) * erfc(x) ~ (1/sqrt(pi)) * 1/x for large x.
//%ORIGIN
//   The main computation evaluates near-minimax approximations
//   from "Rational Chebyshev approximations for the error function"
//   by W. J. Cody, Math. Comp., 1969, PP. 631-638.  
//!
//                 XMIN        XINF        XNEG     XSMALL
//  --------------------------------------------------------------
//  IEEE           2.23D-308   1.79D+308   -26.628  1.11D-16
//  IBM 195        5.40D-79    7.23E+75    -13.190  1.39D-17
//  UNIVAC 1108    2.78D-309   8.98D+307   -26.615  1.73D-18
//  VAX D-Format   2.94D-39    1.70D+38     -9.345  1.39D-17
//  VAX G-Format   5.56D-309   8.98D+307   -26.615  1.11D-16
//
//                 XBIG       XHUGE       XMAX
//   ------------------------------------------------------
//  IEEE           26.543      6.71D+7     2.53D+307
//  IBM 195        13.306      1.90D+8     7.23E+75
//  UNIVAC 1108    26.582      5.37D+8     8.98D+307
//  VAX D-Format    9.269      1.90D+8     1.70D+38
//  VAX G-Format   26.569      6.71D+7     8.98D+307
[mx,nx]=size(x);x=matrix(x,1,mx*nx);
thresh=0.46875; //
sqrpi=5.6418958354775628695d-1;
xmin=2.23D-308;xinf=1.79D+308;xneg=-26.628;
xsmall=%eps //argument below which erf(x) may be represented by
//            2*x/sqrt(pi)  and above which  x*x  will not underflow.
xbig=26.543;xhuge=6.71D+7;xmax=2.53D+307



//------------------------------------------------------------------
//  evaluate  erf  for  |x| <= 0.46875
//------------------------------------------------------------------
y = abs(x)
k = find(abs(x) <= thresh);
if k<>[] then
  a=poly([3.20937758913846947d03;3.77485237685302021d02;
          1.13864154151050156d02;3.16112374387056560d00;
          1.85777706184603153d-1],'x','c')
  b=poly([2.84423683343917062d03;1.28261652607737228d03;
          2.44024637934444173d02;2.36012909523441209d01;1],'x','c')
  y=abs(x(k))
  ysq = 0*y
  k1=find(y>xsmall);ysq(k1)=y(k1).*y(k1)
  result(k) = x(k).*freq(a,b,ysq)
  if jint<>0 then result = 1 - result;end
  if jint==2 then result = exp(ysq).*result;end
end

//------------------------------------------------------------------
//  evaluate  erfc  for 0.46875 <= |x| <= 4.0
//------------------------------------------------------------------
k = find((abs(x) > thresh) &  (abs(x) <= 4.));
if k<>[] then
  c=poly([1.23033935479799725d03;2.05107837782607147d03;
          1.71204761263407058d03; 8.81952221241769090d02;
          2.98635138197400131d02;6.61191906371416295d01;
          8.88314979438837594d0;5.64188496988670089d-1;
          2.15311535474403846d-8],'x','c')
  d=poly([1.23033935480374942d03;3.43936767414372164d03;
          4.36261909014324716d03;3.29079923573345963d03;
          1.62138957456669019d03;5.37181101862009858d02;
          1.17693950891312499d02;1.57449261107098347d01;1],'x','c')
  y=abs(x(k))
  result(k) = freq(c,d,y)
  if (jint<>2) then
    ysq = int(y*16)/16
    del = (y-ysq).*(y+ysq)
    result(k) = exp(-ysq.*ysq).* exp(-del).*result(k)
  end 
end
//------------------------------------------------------------------
//  evaluate  erfc  for |x| > 4.0
//------------------------------------------------------------------
k = find(abs(x) > 4.0);
if k<>[] then
  p=poly([6.58749161529837803d-4;1.60837851487422766d-2;
          1.25781726111229246d-1;3.60344899949804439d-1;
          3.05326634961232344d-1;1.63153871373020978d-2],'x','c')
  q=poly([2.33520497626869185d-3;6.05183413124413191d-2;
          5.27905102951428412d-1;1.87295284992346047d00;
          2.56852019228982242d00;1],'x','c')

  y=abs(x(k))
  result(k) = 0*y
    skip(size(k,'*'))=%f
  k1=find(y>=xbig)
  if k1<>[] then
    k2=find(jint<>2|y>=xmax)
    t=%t;
    skip(k2)=t(ones(size(k2,'*'),1))
    k2=find(y>=xhuge)
    if k2<>[] then
      result(k2)=sqrpi/y(k2);skip(k2)=t(ones(size(k2,'*'),1))
    end
  end
  kskip=find(~skip)
  if kskip<>[] then
    ysq = ones(y(kskip))./(y(kskip).*y(kskip))
    result(k(kskip)) = (sqrpi-ysq.*freq(p,q,ysq))./y(kskip)
    if jint<>2 then
      ysq = int(y(kskip)*16)/16
      del = (y(kskip)-ysq).*(y(kskip)+ysq)
      result(k(kskip)) = exp(-ysq.*ysq).*exp(-del).*result(k(kskip))
    end
  end
end
//------------------------------------------------------------------
//  fix up for negative argument, erf, etc.
//------------------------------------------------------------------
kneg=find(x<0) 
if jint==0 then
  k = find(x > thresh);
  if k<>[] then result(k) = (0.5 - result(k)) + 0.5;end
  k = find(x < -thresh);
  if k<>[] then result(k) = (-0.5 + result(k)) - 0.5;end
elseif jint==1 then
  if kneg<>[] then result(kneg)=2-result(kneg),end
else
  if kneg<>[] then
    k2=find(x<xneg)
    if k2<>[] then
      result(k2) = xinf(ones(k2))
    else
      ysq = int(x(kneg)*16)/16
      del = (x(kneg)-ysq).*(x(kneg)+ysq)
      y = exp(ysq*ysq).*exp(del)
      result(kneg) = (y+y) - result(kneg)
    end 
  end
end 
result=matrix(result,mx,nx);
