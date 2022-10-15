function [Sl]=syslin(domain,a,b,c,d,x0)
[lhs,rhs]=argn(0)
//
select type(domain)
  case 1 then  //sampled system
    if domain=[] then 
      tp=[]
    else
      if prod(size(domain))<>1 then
        if rhs==3 then
        [m1,n1]=size(domain);
        if m1<>n1 then error('syslin: A must be square');end
        [n2,m2]=size(A);
if n2<>n1 then error('syslin: invalid column dimension of B matrix');end
        [n3,m3]=size(B);
if m3<>n1 then error('syslin: invalid row dimension of C matrix');end
        Sl=list('lss',domain,A,B,zeros(B*A),zeros(n1,1),[]);
        return
        end
        if rhs==4 then
        [m1,n1]=size(domain);
        if m1<>n1 then error('syslin: A must be square');end
        [n2,m2]=size(A);
if n2<>n1 then error('syslin: invalid column dimension of B matrix');end
        [n3,m3]=size(B);
if m3<>n1 then error('syslin: invalid row dimension of C matrix');end
        [n4,m4]=size(C);
if n4<>n3 then error('syslin: invalid column dimension of D matrix');end
if m4<>m2 then error('syslin: invalid row dimension of D matrix');end
        Sl=list('lss',domain,A,B,C,zeros(n1,1),[]);
        return
        end
        if rhs==5 then
        [m1,n1]=size(domain);
        if m1<>n1 then error('syslin: A must be square');end
        [n2,m2]=size(A);
if n2<>n1 then error('syslin: invalid column dimension of B matrix');end
        [n3,m3]=size(B);
if m3<>n1 then error('syslin: invalid row dimension of C matrix');end
        [n4,m4]=size(C);
if n4<>n3 then error('syslin: invalid column dimension of D matrix');end
if m4<>m2 then error('syslin: invalid row dimension of D matrix');end
        [n5,m5]=size(D);
if n5<>n1 then error('syslin: invalid x0');end
if m5<>1 then error('syslin: invalid x0 (column vector)');end
        Sl=list('lss',domain,A,B,C,D,[]);
        return
        end
        error('domain (1rst argument of syslin) must be a scalar')
      end;
      if domain<=0 then
        error('domain must be a >0 scalar'),
      end;
      tp=domain(1,1)
    end;
  case 10 //continuous or discrete
    if prod(size(domain))<>1 then
       error('domain (1rst argument of syslin) must be a single string')
    end;
    select part(domain,1)
      case 'c' then tp='c';
      case 'd' then tp='d';
      else error(domain+' : unknown time domain')
    end;
  else error('1rst argument of syslin should be a string, a scalar or a [] matrix')
end;
//
select type(a)
case 1 then // (a,b,c,d...)
//-------------------------
if rhs <4 then
     error('syslin : (domain,a,b,c [d [x0]])');
end;
if type(b)*type(c)<>1 then
       error('syslin : a,b and c scalar matrices')
end;
//
[ma,na]=size(a);[mb,nb]=size(b);[mc,nc]=size(c);
if ma<>na then error('syslin : a must be square'),end
//
if nb==0 then
// warning('syslin: no inputs'),
mb=na; end;
if mc=0 then
// warning('syslin: no outputs'),
nc=na;end
if 2*na-mb-nc<>0 then
       error('syslin : dimension of b or c is incorrect')
end;
//
if rhs <6 then x0=0*ones(na,1),
          else [mx,nx]=size(x0),
               if nx<>0 & (mx-na+1)*nx<>1 then
                  error('syslin : x0 is incorrect'),
               end;
end;
//
if rhs < 5 then 
  d=0*ones(mc,nb),
else 
  [md,nd]=size(d),
if md=0 then md=mc;end
if nd=0 then nd=nb;end
  if (a<>[])&((md-mc+1)*(nb-nd+1)<>1) then
     error('syslin : d has invalid dimension'),
  end;
end;
//
sl=list('lss',a,b,c,d,x0,tp)
case 2 then //(n,d,...)
//---------------------
if rhs==2 then s=list('lss',[],[],[],a,[],tp);return;end
if rhs >3 then error('syslin : (domain,n,d )');end
if type(b)>2 then error('syslin : n and d polynomial matrices');end
//
if size(a)<>size(b) then
    error('syslin : n and d have inconsistent dimensions'),
end;
z='z';if tp='c' then z='s',end
//
if type(a)=2 then a=varn(a,z),end
sl=list('r',a,varn(b,z),tp)
case 15 then //(n,d,...)
//---------------------
if a(1)<>'r' then error(90,1),end
if rhs >2 then  error('syslin : (domain,h )');end
if a(4)<>[] then error('syslin:time domain already defined');end
//
z='z';if tp='c' then z='s',end
sl=list('r',varn(a(2),z),varn(a(3),z),tp)
else error(44,2)
end;



