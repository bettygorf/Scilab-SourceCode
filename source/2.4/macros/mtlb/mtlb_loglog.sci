function h=mtlb_loglog(X1,X2,X3,X4,X5,X6,X7,X8,X9)
// Copyright INRIA
h=[]
[lhs,rhs]=argn(0)

if rhs==1 then
  strf='021'
  mtlb_pltl1(X1,'k-',strf)
elseif rhs==2 then
  strf='021'
  if type(X2)==10 then
    mtlb_pltl1(X1,X2,strf)
  else   
    mtlb_pltl2(X1,X2,'k-',strf)
  end
elseif rhs==3&type(X3)==10 then
  strf='021'
  mtlb_pltl2(X1,X2,X3,strf)
else
  k=1
  kc=[],cstyl=[]
  while k<=rhs-1 
    kc=[kc;[k k+1]]
    if k+2>rhs then
      cstyl=[cstyl,'k-']
    else
      execstr('tp=type(X'+string(k+2)+')')
      if tp==10 then
        execstr('st=X'+string(k+2))
        cstyl=[cstyl,st]
        k=k+3
      else
        cstyl=[cstyl,'k-']
        k=k+2
      end
    end
  end
  nc=size(cstyl,'*')
  xmx=-10^20
  xmn=10^20
  ymx=-10^20
  ymn=10^20
  for k=1:nc
    kx=kc(k,1)
    ky=kc(k,2)
    execstr('xmx=max(xmx,max(X'+string(kx)+'))')
    execstr('xmn=min(xmn,min(X'+string(kx)+'))')
    execstr('ymx=max(ymx,max(X'+string(ky)+'))')
    execstr('ymn=min(ymn,min(X'+string(ky)+'))')
  end
  xsetech([0,0,1.0,1.0],[xmn,ymn,xmx,ymx])
  strf='001'
  for k=1:nc
    kx=kc(k,1)
    ky=kc(k,2)
    execstr('mtlb_pltl2(X'+string(kx)+',X'+string(ky)+',cstyl(k))')
  end
end


function mtlb_pltl1(X1,mtlb_style,strf)
[lhs,rhs]=argn(0)
p=xget('pattern')
mclrs=['y','m','c','r','g','b','w','k']
sclrs=[33 ,22 ,17 ,5  ,11 ,12 ,33 ,1  ]
mltyp=['.','o','x','+','-','*',':','-.','--']
sltyp=[0  ,9  ,2,   1,  -1  3   -1  -1   -1]
clr=sclrs(find(part(mtlb_style,1)==mclrs))
ltyp=linetype(part(mtlb_style,2:length(mtlb_style)))
if ltyp>0 then
  xset('pattern',clr)
  style=-ltyp
else
  style=clr
end
if norm(imag(X1),1)==0 then
  if min(size(X1))==1 then
    plot2d1('ell',0,X1(:),style,strf)
  else
    plot2d1('ell',0,X1,style*ones(1,size(X1,2)),strf)
  end
else
  if min(size(X1))==1 then
    plot2d1('gll',real(X1(:)),imag(X1(:)),style,strf)
  else
    plot2d1('gll',real(X1),imag(X1),style*ones(1,size(X1,2)),strf)
  end
end
xset('pattern',p)

function mtlb_pltl2(X1,Y1,mtlb_style,strf)
[lhs,rhs]=argn(0)
p=xget('pattern')
mclrs=['y','m','c','r','g','b','w','k']
sclrs=[33 ,22 ,17 ,5  ,11 ,12 ,33 ,1  ]
mltyp=['.','o','x','+','-','*',':','-.','--']
sltyp=[0  ,9  ,2,   1,  -1  3   -1  -1   -1]
clr=sclrs(find(part(mtlb_style,1)==mclrs))
ltyp=sltyp(find(part(mtlb_style,2:length(mtlb_style))==mltyp))
if ltyp>0 then
  xset('pattern',clr)
  style=-ltyp
else
  style=clr
end
[mx1,nx1]=size(X1)
[my1,ny1]=size(Y1)
//if min(size(X1))==1|min(size(Y1))==1 then
//  X1=X1(:);Y1=Y1(:)
//  n=min(size(X1,1),size(Y1,1))
//  plot2d1('gll',X1(1:n),Y1(1:n),style,strf)

if min(size(X1))==1 then
  plot2d1('oll',X1(:),Y1,style*ones(1,size(Y1,2)),strf)  
elseif min(size(Y1))==1 then
  plot2d1('gll',X1(:),Y1,style*ones(1,size(Y1,2)),strf)  
else
  plot2d1('gll',X1,Y1,style*ones(1,size(Y1,2)),strf)
end
xset('pattern',p)
