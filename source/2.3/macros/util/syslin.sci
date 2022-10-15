function [sl]=syslin(domain,a,b,c,d,x0)
[lhs,rhs]=argn(0)
//
lss_t=['lss','A','B','C','D','X0','dt']
select type(domain)
case 1 then  //sampled system
  if domain=[] then 
    tp=[]
  else
    if size(domain,'*')<>1 then
      if rhs==3 then
        [m1,n1]=size(domain);
        if m1<>n1 then error('syslin: a must be square');end
        [n2,m2]=size(a);
        if n2~=0&n2<>n1 then error('syslin: invalid column dimension of b matrix');end
        [n3,m3]=size(b);
        if m3~=0&m3<>n1 then error('syslin: invalid row dimension of c matrix');end
        sl=tlist(lss_t,domain,a,b,zeros(b*a),zeros(n1,1),[ ]);
        return
      end
      if rhs==4 then
        [m1,n1]=size(domain);
        if m1<>n1 then error('syslin: a must be square');end
        [n2,m2]=size(a);
        if n2<>n1 then error('syslin: invalid column dimension of b matrix');end
        [n3,m3]=size(b);
        if m3<>n1 then error('syslin: invalid row dimension of c matrix');end
        [n4,m4]=size(c);
        if n4<>n3 then error('syslin: invalid column dimension of d matrix');end
        if m4<>m2 then error('syslin: invalid row dimension of d matrix');end
        sl=tlist(lss_t,domain,a,b,c,zeros(n1,1),[]);
        return
      end
      if rhs==5 then
        [m1,n1]=size(domain);
        if m1<>n1 then error('syslin: a must be square');end
        [n2,m2]=size(a);
        if n2<>n1 then error('syslin: invalid column dimension of b matrix');end
        [n3,m3]=size(b);
        if m3<>n1 then error('syslin: invalid row dimension of c matrix');end
        [n4,m4]=size(c);
        if n4<>n3 then error('syslin: invalid column dimension of d matrix');end
        if m4<>m2 then error('syslin: invalid row dimension of d matrix');end
        [n5,m5]=size(d);
        if n5<>n1 then error('syslin: invalid x0');end
        if m5<>1 then error('syslin: invalid x0 (column vector)');end
        sl=tlist(lss_t,domain,a,b,c,d,[]);
        return
      end
      error('domain (1rst argument of syslin) must be a scalar')
    end
    if domain<=0 then
      error('domain must be a >0 scalar'),
    end
    tp=domain(1,1)
  end
case 10 //continuous or discrete
  if size(domain,'*')<>1 then
    error('domain (1rst argument of syslin) must be a single string')
  end
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
  if type(b)==2 then 
    a=a+0*poly(0,varn(b));
    sl=tlist(['r','num','den','dt'],a,b,tp);
    return;
  end
  if rhs <4 then
    error('syslin : (domain,a,b,c [d [x0]])');
  end
  if type(b)*type(c)<>1 then
    error('syslin : a,b and c scalar matrices')
  end
  //
  [ma,na]=size(a);[mb,nb]=size(b);[mc,nc]=size(c);
  if ma<>na then error('syslin : a must be square'),end
  //
  if nb==0 then
    // warning('syslin: no inputs'),
    mb=na;
  end
  if mc=0 then
    // warning('syslin: no outputs'),
    nc=na;
  end
  if 2*na-mb-nc<>0 then
    error('syslin : dimension of b or c is incorrect')
  end
  //
  if rhs <6 then 
    x0=0*ones(na,1),
  else 
    [mx,nx]=size(x0),
    if nx<>0 & (mx-na+1)*nx<>1 then
      error('syslin : x0 is incorrect'),
    end
  end
  //
  if rhs < 5 then 
    d=0*ones(mc,nb),
  else 
    [md,nd]=size(d),
    if md=0 then md=mc;end
    if nd=0 then nd=nb;end
    if (a<>[])&((md-mc+1)*(nb-nd+1)<>1) then
      error('syslin : d has invalid dimension'),
    end
  end
  //
  sl=tlist('lss',a,b,c,d,x0,tp)
case 2 then //(n,d,...)
  //---------------------
  if rhs==2 then sl=tlist(['r','num','den','dt'],a,1,tp);return;end
  if rhs >3 then error('syslin : (domain,n,d )');end
  if type(b)>2 then error('syslin : n and d polynomial matrices');end
  //
  if size(a)<>size(b) then
    error('syslin : n and d have inconsistent dimensions'),
  end;
  z='z';
  if tp=[] then z=varn(a);end
  if tp='c' then z='s',end
  //
  if type(a)=2 then a=varn(a,z),end
  sl=tlist(['r','num','den','dt'],a,varn(b,z),tp)
  //-compat next case retained for list -> tlist compatibility
case 15 then //(n/d,...)
  //---------------------
  error('Obsolete feature, please use tlist to define rational fractions')
case 16 then //(n/d,...)
  //---------------------
  typ=a(1)
  if typ(1)<>'r' then error(90,1),end
  if rhs >2 then  error('syslin : (domain,h )');end
  sl=a;sl(4)=tp
else 
  error(44,2)
end



