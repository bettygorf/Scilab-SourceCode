function [nt,dt,rk]=trzeros(Sl)
//Transmission zeros of Sl = nt./dt
// Syntax : [nt,dt]=trzeros(Sl)
//!
[LHS,RHS]=argn(0);
if type(Sl)=2 then 
   D=Sl;
   [m,n]=size(D);
if m<>n then error('Trzeros: Polynomial matrix--> must be square');return;end
   chis=determ(D);nt=roots(chis);dt=ones(nt);
   if LHS==1 then nt=nt./dt;dt=[];rk=[];end
   return;
end
if Sl(1)<>'lss'&Sl(1)<>'r' then 
error('Input to trzeros must be a linear system or polynomial matrix');
end
if Sl(1)='r' then 
   if size(Sl)==1 then nt=roots(Sl(2));dt=[];rk=1;return;end
   Sl=tf2ss(Sl);
end
//Sl=minss(Sl);
[A,B,C,D]=Sl(2:5);
if type(D)=2 then 
  [m,n]=size(D);
if m<>n then error('Trzeros: Polynomial D matrix -->must be square');return;end
   chis=determ(systmat(Sl));nt=roots(chis);dt=ones(nt);
   if LHS==1 then nt=nt./dt;dt=[];rk=[];end
   return;
end
if prod(size(A))=0 then 
    if type(D)=1 then nt=[];dt=[];return;end;
    if type(D)=2 then 
       [m,n]=size(D);
       if m<>n then error('D(s) must be square');return;end
       chis=determ(D);nt=roots(chis);dt=ones(nt);
       if LHS==1 then nt=nt./dt;dt=[];rk=[];end
    return;
    end;
end;
[ld,kd]=size(D);
if norm(D,1)<sqrt(%eps)|ld==kd then
 [nt,dt,rk]=tr_zer(A,B,C,D);
 if LHS=1 then nt=nt./dt;dt=[];rk=[];end
 return;
end
if ld < kd & norm(D*pinv(D)-eye,1)< 1.d-10
 //nt=spec(A-B*pinv(D)*C);dt=ones(nt);
 [nt,dt]=tr_zer(A,B,C,D);
 rk=ld;
 if LHS==1 then nt=nt./dt;end;
 return;
end
if ld > kd & norm(pinv(D)*D-eye,1)< 1.d-10
 //nt=spec(A-B*pinv(D)*C);dt=ones(nt);
 [nt,dt]=tr_zer(A,B,C,D);
 rk=kd;
 if LHS==1 then nt=nt./dt;dt=[];rk=[];end;return;
end
warning('Trzeros:non-square system with D non zero and not full')
nt=[];dt=[];rk=[];
