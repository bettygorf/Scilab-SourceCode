//[hinfnorm,frequency]=H_norm(Sl,rerr)
// produces the infinitynorm  of a state-space system 
// (the maximum over all frequencies of the maximum singular value).
//%Syntaxe et description des parametres
//      [hinfnorm [,frequency]]=H_norm(Sl,rerr)
//      [hinfnorm [,frequency]]=H_norm(Sl)
//
//  sl        : the state space system (see syslin)
//  Rerr      : max. relative error, default value 1e-8
//
//  hinfnorm  : the infinitynorm of sl
//  frequency : frequency at which hinfnorm is achieved
//  see also: linfn, linf
//!
//  Version 3.2, 09-27-1990
//  N.A. Bruinsma       T.U.Delft/Philips Research Eindhoven, see also
// Systems & Control Letters, vol. 14 pp. 287-293.

[lhs,rhs]=argn(0);
eps=1.d-8;
flag='ss';if Sl(1)='r' then Sl=tf2ss(Sl);end
[A,B,C,D]=sl(2:5);
eiga=spec(a);
if maxi(real(eiga)) >= -1e-12 then  ...
  write(%io(2),'Warning : system is not stable ! '),end
if rhs=1 then rerr=1e-8; end;
[no,ns] = size(c); [ns,ni] = size(b);
if mini(ni,no) = 1 then isiso = 2; else isiso = 1; end;
[p,a] = hess(a); [u,d,v] = svd(d); b = p' * b * v; c = u' * c * p;
dtd = diag(d'*d); ddt = diag(d*d'); dtc = d' * c;
aj = sqrt(-1)*eye(ns); R1 = ones(ni,1); S1 = ones(no,1);
l = [];
// compute starting value
q = ((imag(eiga) + 0.01 * ones(eiga)) ./ real(eiga)) ./ abs(eiga);
[q,i] = maxi(q); w = abs(eiga(i));
svw = norm( c * ((w*aj*eye-a)\b) + d );
sv0 = norm( -c * (a\b) + d );
svdd = norm(d);
[lb,i] = maxi([svdd sv0 svw]);l=lb;
w = [1.d30 0 w ]; M = w(i);
// to avoid numerical problems with Rinv and Sinv if lb = norm(d), lb must be
// enlarged to at least (1+1e-3)*lb;
if lb = svdd then lb=1.001*lb+eps;end;
for it = 1:15,
  gam = (1 + 2 * rerr) * lb; gam2 = gam * gam;
  Rinv = diag(R1./(dtd - gam2 * R1));
  Sinv = diag(S1./(ddt - gam2 * S1));
  H11 = a-b*Rinv*dtc;
  evH = spec([H11 -gam*b*Rinv*b'; gam*c'*Sinv*c  -H11']);
 
//  idx1=ceil(abs(real(evh)),1.e-3);
//  idx2=ceil(-imag(evh(idx1)),0);
//  idx=idx1(idx2);
  idx = find(abs(real(evH)) < 1e-8 & imag(evH) >= 0);
  imev= imag(evH(idx));
  [imev] = sort(imev);
  q = maxi(size(imev));
  if q <= 1 then
  // q=1 can only happen in the first step if H-norm=maxsv(D) or H-norm=maxsv(0)
  // due to inaccurate eigenvalue computation (so gam must be an upper bound).
    ub = gam;
//    pause;
  else
    M =  0.5 * (imev(1:q-1) + imev(2:q)); M = M(1:isiso:q-1);
    sv=[];
    for j = 1:maxi(size(M)),
      sv = [sv maxi(svd(d + c*((M(j)*aj*eye - a)\b)))];
    end;
    lb = maxi(sv);l=[l;lb];
  end;
end;
if M = 1.d30 then
  lb=svdd;
write(%io(2),"Warning:norm cannot be computed rel. accuracy smaller than 1e-3")
write(%io(2),'Hinfnorm is probably exactly max sv(D)')
write(%io(2),'The system might be all-pass')
end;
if exists('ub')=0 then ub=lb;end
hinfnorm = 0.5 * (ub+lb); frequency = M;
//end;


