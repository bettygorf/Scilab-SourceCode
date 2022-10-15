function []=ssprint(sl,out)
//ssprint(sl [,out])  pretty print of a linear system in state-space form
// sl=(A,B,C,D) syslin list.
// out=output (default out=%io(2))
// See also texprint.
//Examples:
// a=[1 1;0 1];b=[0 1;1 0];c=[1,1];d=[3,2];
// ssprint(syslin('c',a,b,c,d))
// ssprint(syslin('d',a,b,c,d))
//!
[lhs,rhs]=argn(0)
mess='systeme non representable dans la page'
if rhs=1 then out=%io(2),end
deff('[ta]=%cv(x)',['[m,n]=size(x);';
                    'fmt=format();fmt=10**fmt(2)/maxi([1,norm(x)]);';
                    'x=round(fmt*x)/fmt;';
                    't=[];for k=1:m,t=[t;''|''],end;';
                    'ta=t;for k=1:n,';
                    '        aa=string(x(:,k)),';
                    '        for l=1:m,';
                    '           if part(aa(l),1)<>''-'' then ';
                    '               aa(l)='' ''+aa(l),';
                    '           end,';
                    '        end,';
                    '        n=maxi(length(aa)),';
                    '        aa=part(aa+blank,1:n),';
                    '        ta=ta+aa+part(blank,1),';
                    'end;ta=ta+t;'])
comp(%cv)
//
// d(x)=ax + bu
//-------------
write(out,' ')
sgn='.';if sl(7)<>'c' then sgn='+',end
ll=lines();ll=ll(1)
[a,b,c,d]=sl(2:5)
[na,nb]=size(b)
[nc,na]=size(c)
blank=[];for k=1:na,blank=[blank;'           '],end
ta=%cv(a);tb=%cv(b)
//
blank=part(blank,1:4)
blank([na/2,na/2+1])=[sgn+'   ';'x = ']
t=blank+ta;
blank([na/2,na/2+1])=['    ';'x + ']
n1=maxi(length(t))+1
t=t+blank+tb
blank(na/2+1)=        'u   '
t=t+blank
//
n2=maxi(length(t))
if n2<ll then
         write(out,t)
         else
         if n1<ll,if n2-n1<ll then
                       write(out,part(t,1:n1)),
                       write(out,' ')
                       write(out,part(t,n1+1:n2),'(3x,a)')
         else          error(mess)
         end;
              else error(mess)
         end;
end;
//
//y = cx + du
//-----------
write(out,' ')
blank=[];for k=1:nc,blank=[blank;'           '],end
tc=%cv(c);td=%cv(d)
blank=part(blank,1:4)
blank([nc/2,nc/2+1])=['    ';'y = ']
t=blank+tc;
if norm(d,1)>0 then
  blank([nc/2,nc/2+1])=['    ';'x + ']
  n1=maxi(length(t))+1
  t=t+blank+td
  blank(nc/2+1)=        'u   '
  t=t+blank
               else
  blank([nc/2,nc/2+1])=['    ';'x   ']
  t=t+blank
end;
n2=maxi(length(t))
if n2<ll then
         write(out,t)
         else
         if n1<ll,if n2-n1<ll then
                    write(out,part(t,1:n1)),
                    write(out,' ')
                    write(out,part(t,n1+1:n2),'(3x,a)')
                    else error(mess)
                   end;
         else error(mess)
         end;
end;
