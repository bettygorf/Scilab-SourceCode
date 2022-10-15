function x=g_inv(a)
// only to be called by function inv
//!
// Copyright INRIA
typ=type(a)

//-compat next row added for list/tlist compatibility
if typ==15 then typ=16,end
select typ
case 2 then 
  x=invr(a);return
case 5 then //sparse matrix
  [ma,na]=size(a)
  if ma<>na then error(20,1),end
  [hand,rk]=lufact(a)
  if rk<na then ludel(hand);error(19),end
  x=[]
  for k=1:ma
    b=0*ones(ma,1);b(k)=1;
    x=[x,sparse(lusolve(hand,b))]
  end
  ludel(hand);
  return
case 16 then
  a1=a(1);
  if a1(1)=='r' then
    x=invr(a);return
  end
  if a1(1)=='lss' then
    d=a(5);
    [m,n]=size(d);
    polyn=(type(d)==2);constant=(type(d)==1);
    if constant&(m==n) then 
      minsv=mini(svd(d));rcd=rcond(d);s=poly(0,'s');
    end
    if constant&(m<>n) then 
      minsv=mini(svd(d));s=poly(0,'s');
    end

    if polyn then rcd=0;minsv=0;s=poly(0,varn(d));end
    if m==n then 
      if rcd > 1.d-6 then
        x=invsyslin(a)
      else
        h=systmat(a);
        se=rand('seed');
        valfa=rand(1,10,'normal')/100;
	rand('seed',se);
        www=[];
	for k=1:10
          www=[www,rcond(horner(h,valfa(k)))];end
          [w,k1]=maxi(www);alfa=valfa(k1);
          x=invrs(a,alfa);
        end
        return
      end
      if m<n then
        warning('non square system! --> right inverse')
        if minsv > 1.d-6 then
          x=invsyslin(a)
        else
          [stmp,ws]=rowregul(a,0,0);
          if mini(svd(stmp(5))) > 1.d-6 then
            x=invsyslin(stmp)*ws
          else
            error(19)
          end
        end
        return
      end

      if m>n then
        warning('non square system! --> left inverse')
        if minsv > 1.d-6 then
          x=invsyslin(a)
        else
          [stmp,ws]=rowregul(a,0,0);
          if mini(svd(stmp(5))) > 1.d-6 then
            x=invsyslin(stmp)*ws
          else
            error(19)
          end
        end
        return
      end
    end
  end
