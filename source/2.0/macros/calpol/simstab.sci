//<punst,lambda>=simstab(p0,p,moeb)
//<punst,lambda>=simstab(p0,p,moeb)  teste la stabilite  d'une famille
//de polynomes  p0+sum(li*p(i)) pour 0<=li<1
//Si pour tout li la famille est stable, alors punst=[];lambda=[].
//Sinon  punst  est un  polynome  instable de la famille et  lambda le
//vecteur des li tels que punst=p0+sum(li*p(i))
//
//entrees : p0   polynome stable
//          p    vecteur colonne de polynomes
//          moeb matrice de  scalaires 2x2  permettant de specifier le
//               type de stabilite desiree.
//               moeb=eye(2)     pour la stabilite  au sens continu et
//               moeb=[1 1;1 -1] au sens discret
//!
//origine
//
//definition de la macro angle
deff('[teta]=angle(z)',['teta=atan(imag(z),real(z));';
                        'n=prod(size(z));';
                        'for k=1:n,';
                        'if abs(teta(k)+%pi)<%eps then';
                        'teta(k)=teta(k)+2*%pi,end,';
                        'end'])
comp(angle)
//
plt=0;  //pas de graphique (pour obtenir les graphiques plt=1)
//
punst=[];lambda=[];
[m,W]=size(p)
lp=maxi(degree(p))+1
n=degree(p0)
rts=roots(p0);
zp0=(moeb(2,2)*rts-moeb(1,2)*ones(rts))...
     ./(-moeb(2,1)*rts+moeb(1,1)*ones(rts));
if maxi(real(zp0))>=0 then
    error("le polynome p0 n''est pas stable"),
end;
//--------
if plt=1 then
    dess(2)=0;dess(56)=1;plot(0,0);
    dess(54)=1;dess(56)=0;
end;
//--------
wstp=mini(abs(zp0))
k=0;aw=0;waw=[0;0];
for j=2:n
 while aw<=maxi([j-1, 2*j-n-0.5])*%pi/2
  k=k+1
  aw=sum(angle((%i*k*wstp*ones(1,n))-zp0'));
 end;
waw(:,j)=[k*wstp;aw]
end;
for j=2:n
 while j*%pi/2-waw(2,j)<0
  nw=(waw(1,j-1)+waw(1,j))/2
  naw=sum(angle((%i*nw*ones(1,n))-zp0'))
  waw(:,mini([j,ent(naw*2/%pi)+1]))=[nw;naw]
 end;
end;
//--------
w=waw(1,:)
nn=n;p0w=0;scale=0;
opiw=moeb(2,2)**n*horner(p0,moeb(1,2)/moeb(2,2));
olo=angle(opiw);j=0; //
extra=%i*ones(2*m+1,1);
while 1=1,
   j=j+1;
   numer=moeb(1,:)*[%i*w(j);1];
   denom=moeb(2,:)*[%i*w(j);1];
   p0wn=denom**n*horner(p0,numer/denom);
   p0w(j)=p0wn;
   pw=0;pwc=0;piwc=0;piw=0;lda0=0*ones(1,m)
   for k=1:m
     pw(k)=denom**n*horner(p(k),numer/denom);
     if abs(pw(k))<=%eps then pwc(k)=%i;
                         else pwc(k)=pw(k);
     end;
     if angle(pwc(k))<0
        p0wn=p0wn+pw(k)
        pw(k)=-pw(k);pwc(k)=-pwc(k);lda0(k)=1-lda0(k);
     end;
   end;
   [ang,ii]=sort(angle(pwc));ang=ang(m:-1:1);ii=ii(m:-1:1);
   piw(1)=p0wn+pw(ii(1));
   for k=2:m, piw(1,k)=piw(k-1)+pw(ii(k));end
   piw=[piw, (2*p0wn+sum(pw))*ones(piw)-piw];
for k=1:2*m ,
   if abs(piw(k))<=%eps then piwc(1,k)=%i;
                        else piwc(1,k)=piw(k);
   end;
end;
scale(j)=maxi(abs(piw))
xpiw=conj([piw, piw(1)]')/scale(j)
//
if plt=1 then
            plot2d(real(xpiw)',imag(xpiw)',[3,1])
            plot2d(real(p0w(j))'/scale(j),imag(p0w(j))'/scale(j),...
            [2,2],"000");
end;
//
[hi,ihi]=maxi(angle(piwc/p0w(j)))
[lo,ilo]=mini(angle(piwc/p0w(j)))
if hi-lo>=%pi
  tri=[real([p0w(j) piw(ihi) piw(ilo)]);
       imag([p0w(j) piw(ihi) piw(ilo)])];
nl=ker(tri);
nl=nl(:,1)
ldhi=lda0;ldlo=lda0;
if ihi>m then ihi=ihi-m;ldhi=ones(ldhi)-ldhi;end
if ilo>m then  ilo=ilo-m;ldlo=ones(ldlo)-ldlo;end
ldhi(ii(1:ihi))=ones(1,ihi)-ldhi(ii(1:ihi));
ldlo(ii(1:ilo))=ones(1,ilo)-ldlo(ii(1:ilo));
lambda=nl'*[0*ones(1,m);ldhi;ldlo]/sum(nl)
punst=p0
punst=punst+lambda*p
if plt=1 then
  plot2d(real(p0w./scale)',imag(p0w./scale)',[4,3],"100",...
      'Le parametre lambda donne un polynome instable punst');
end;
return,
end;
if hi+angle(p0w(j)/opiw)-olo >%pi
w(j+1:nn+1)=w(j:nn);
w(j)=(w(j+1)+w(j-1))/2
j=j-1
nn=nn+1
else
  opiw=p0w(j)
  olo=lo;
end;
if j=nn
  if hi-lo>=%pi/4
    nn=nn+1
    w(nn)=w(nn-1)*2-w(nn-2)
    else
  if plt=1 then plot2d(real(p0w)./scale',imag(p0w)./scale',[5,3],...
                   "100", 'The family is stable'),end
  return
end;
end;
end;
//end


