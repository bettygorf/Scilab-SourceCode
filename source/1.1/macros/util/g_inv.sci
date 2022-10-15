function x=g_inv(a)
// only to be called by function inv
//!
select type(a)
case 2 then 
  x=invr(a);return
case 15 then
  if a(1)=='r' then
    x=invr(a);return
  end
  if a(1)='lss' then
  D=a(5);
  [m,n]=size(D);
polyn=(type(D)==2);constant=(type(D)==1);
if constant then rcd=rcond(D);minsv=mini(svd(D));s=poly(0,'s');end
if polyn then rcd=0;minsv=10000;s=poly(0,varn(D));end
   if m==n then 
        if rcd > 1.d-6 then
               x=invsysli(a)
                       else
        H=systmat(A);
        rand('normal');
        valfa=rand(1,10)/100;
        www=[];for k=1:10
               www=[www,rcond(horner(h,valfa(k)))];end
        [w,k1]=maxi(www);alfa=valfa(k1);
        rand('uniform');
        x=invrs(a,alfa);
        end
    return
    end
   if m<n then
           warning('non square system! --> right inverse')
        if minsv > 1.d-6 then
               x=invsysli(a)
                       else
        [stmp,ws]=rowregul(A,0,0);
              if mini(svd(stmp(5))) > 1.d-6 then
        x=invsysli(stmp)*Ws
                                         else
        error('not full rank! --> error ')
              end
        end
    return
    end

   if m>n then
             warning('non square system! --> left inverse')
        if minsv > 1.d-6 then
               x=invsysli(a)
                       else
        [stmp,ws]=rowregul(A,0,0);
              if mini(svd(stmp(5))) > 1.d-6 then
        x=invsyslin(stmp)*Ws
                                         else
        error('not full rank! --> error ')
              end
        end
    return
    end
  end
end
