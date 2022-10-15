function armap(ar,out)
//Imprime dans un ficher out ou a l'ecran les equations d'un ARMAX
//!
[lhs,rhs]=argn(0)
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

// D(x)=Ax + Bu
//-------------
write(out,' ')
if ar(1)<>'ar' then write(%io(2)," This is not an ARMAX");return;end;
//
[ny,vid]=size(ar(2));
write(out,"  A(z^-1)y=B(z^-1)u + D(z^-1) e(t)");
write(out,"  ");
M=['A','B','D'];
for i=1:3;
  [a]=ar(i+1)
  [na,lna]=size(a)
  nli=int((lna/na));
  if i=2,nli=int((lna/ar(6)));end;
  blank=[];for k=1:na,blank=[blank;'           '],end
  blank1=part(blank,1:8)
//  blank1([na/2,na/2+1])=['  '+M(i)+'(s)= ']
  blank1([int(na/2)+1])=['  '+M(i)+'(s)= ']
  t=blank1;
  nna=na;
  if i=2;nna=ar(6);end
  for j=1:nli;
    ta=a(:,1+(j-1)*nna:j*nna);
    if t=[],t=blank+%cv(ta);else t=t+%cv(ta);end;
    str='s**'+string(j-1)
    if length(str)=4,str=str+' ';end
    if j<>nli;str=str+' + ';else str=str+'   ';end
//    blank1([na/2,na/2+1])=['        ';str];
    blank1([int(na/2)+1])=[str];
    t=t+blank1
    if length(t(1))>=50,write(out,t),write(out," ");t=[];end
  end
write(out,t);
write(out," ");
end
write(%io(2),'  e(t)=Sig*w(t); w(t) '+string(ny)+'-dim white noise');
write(out," ");
  [a]=ar(7)
  [na,lna]=size(a)
  blank=[];for k=1:na,blank=[blank;'           '],end
  blank1=part(blank,1:8)
//  blank1([na/2,na/2+1])=['        ';'  Sig=  ']
  blank1([int(na/2)+1])=['  Sig=  ']
  t=blank1;
  ta=a;
  t=t+%cv(ta);
write(out,t);
write(out," ");



