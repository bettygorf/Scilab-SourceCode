function dim=regdim(x,sigma,voices,Nmin,Nmax,kernelReg,mirror,reg,graphs)

// This Software is ( Copyright INRIA . 1998  1 )
// 
// INRIA  holds all the ownership rights on the Software. 
// The scientific community is asked to use the SOFTWARE 
// in order to test and evaluate it.
// 
// INRIA freely grants the right to use modify the Software,
// integrate it in another Software. 
// Any use or reproduction of this Software to obtain profit or
// for commercial ends being subject to obtaining the prior express
// authorization of INRIA.
// 
// INRIA authorizes any reproduction of this Software.
// 
//    - in limits defined in clauses 9 and 10 of the Berne 
//    agreement for the protection of literary and artistic works 
//    respectively specify in their paragraphs 2 and 3 authorizing 
//    only the reproduction and quoting of works on the condition 
//    that :
// 
//    - "this reproduction does not adversely affect the normal 
//    exploitation of the work or cause any unjustified prejudice
//    to the legitimate interests of the author".
// 
//    - that the quotations given by way of illustration and/or 
//    tuition conform to the proper uses and that it mentions 
//    the source and name of the author if this name features 
//    in the source",
// 
//    - under the condition that this file is included with 
//    any reproduction.
//  
// Any commercial use made without obtaining the prior express 
// agreement of INRIA would therefore constitute a fraudulent
// imitation.
// 
// The Software beeing currently developed, INRIA is assuming no 
// liability, and should not be responsible, in any manner or any
// case, for any direct or indirect dammages sustained by the user.
// 
// Any user of the software shall notify at INRIA any comments 
// concerning the use of the Sofware (e-mail : FracLab@inria.fr)
// 
// This file is part of FracLab, a Fractal Analysis Software



[nargout,nargin] = argn();
narg=nargin;

if narg <9
graphs = 0;
end
if narg <8
  reg = 0;
end
if narg <7
  mirror = 0;
end
if narg <6
  kernelReg = 'gauss';
end
if min(size(x))>1 
  N=min(size(x));
  if narg <4
    Nmin= 5;
  end
  if narg <3
    voices= 16;
  end
  if narg <5
    Nmax= min(max(floor(N/3),Nmin+voices+1),N-1);
  end
  if narg <2
    sigma= 0;
  end
  dim=dimR2D(x,sigma,voices,Nmin,Nmax,kernelReg,mirror,reg);
  return
end
  
N=length(x);

if narg <4
  Nmin= 5;
end
if narg <3
  voices= 128;
end
if narg <5
  Nmax= min(max(floor(N/2),Nmin+voices+1),N-1);
end
if narg <2
  sigma= 0;
end

if size(x,2)==1
  x=x';
end
	  
if mirror 
  x=[mtlb_fliplr(x),x,mtlb_fliplr(x)];
  mirror=1;
end

jmax=voices;
iv=round(logspace(log10(Nmin),log10(Nmax),jmax));
imax=round(max(iv));
K=find(mtlb_diff(iv));
iv=[iv(K),imax];
jmax=length(iv);

////////////////////////////////////
//a:scale
//////////////////////////////////
a=[];
L=[];
Lnoisy=[];
R=[];
//////////////////////////////////////////////////////////////////////////
//Plot regularized graphs if wanted ////
//////////////////////////////////////////////////////////////////////////

if graphs
  z=[];
  for j=1:jmax
    execstr(('[z1,aa]='+ kernelReg+ 'conv(x,iv(j));'));
    a(j)=aa;
    z1=z1(floor(iv(j)/2)+1+mirror*N:N+floor(iv(j)/2)+mirror*N);
    z=[z;z1];
  end
  win=newwin();
  xset("window",win);
  xbasc();
  xset("use color",1); 
  xset("font",2,0);
  m=min(jmax+1,254);
  n = fix(3/8*m);
  r = [(1:n)'/n; ones(m-n,1)];
  g = [zeros(n,1); (1:n)'/n; ones(m-2*n,1)];
  b = [zeros(2*n,1); (1:m-2*n)'/(m-2*n)];
  h = [r g b];
  xset('colormap',h);
  xsetech([0,0,0.85,1.0]);
  plot2d(z');
  xsetech([0.85,0,0.15,1.0]);
  tt=[zeros(1,jmax);ones(1,jmax)];
  aa=[a,a]';
  rect=[0,min(log(a)),1,max(log(a))];
  tics=[0,0,5,5];
  plotframe(rect,tics);
  plot2d(tt,log(aa),[1:jmax],'000');
  xtitle('Scale colors','','log(scale)');
end

for j=1:jmax
  i=round(iv(j));
  execstr(('[z1prim,aa]='+ kernelReg+ 'primconv(x,iv(j));'));
  a(j)=aa;
  z1prim=z1prim(i+1+mirror*(N-floor(iv(j)/2)):N+mirror*(N+i-floor(iv(j)/2)));
  dl=abs(z1prim);
  if isempty(dl)
    break;
  end
  if sigma>0
    Lnoisy(j)=mean(dl);
    //////////////////////////
    // signal/noise component rate
    ////////////////////////
    s=sigma/sqrt(sqrt(2*%pi)*a(j)^3);
    dln=2*s/sqrt(%pi).*exp(-(dl.^2)./s^2);
    dlsb=dl-dln;
    R(j)=mean(dln)/Lnoisy(j);
    //////////////////
    //Corrected unbiased lengths
    //////////////////
    c=ones(1,i)./i;
    dlsbm=convol(c,dlsb);
    dlsbm=dlsbm(floor(i/2)+1:floor(i/2)+length(dlsb));
    dlsbc=s*sqrt(2)*invfonc(dlsbm./(s*sqrt(2)));
    L(j)=mean(dlsbc);
  else
    L(j)=mean(dl)+N^(-2);
  end
end

dim=reg_dimR(a,L,Lnoisy,R,reg,sigma);


function [z,a]=gaussconv(x,iv);
//////////////////////////
//convoluate with the L1 normalized gaussian kernel
//////////////////////////
alpha=3.0;
i=round(iv);
y=gauss(i,alpha);
a=(iv-1.0)/(2.0*sqrt(alpha*log(10)));
y=y./(a*sqrt(%pi));
z=convol(y,x);

function [z,a]=rectconv(x,iv);
//////////////////////////
///convoluate with the L1 normalized rectangle kernel
//////////////////////////
i=round(iv);
a=(iv-1.0);
y=ones(1,i);
y=y./iv;
z=convol(y,x);

function [z,a]=gaussprimconv(x,iv);
//////////////////////////
//convoluate with the derivative ofL1 normalized gaussian kernel
//////////////////////////
alpha=3.0;
i=round(iv);
yprim=gauss(i,alpha,1);
a=(i-1.0)/(2.0*sqrt(alpha*log(10)));
yprim=yprim./(a*sqrt(%pi));
z=convol(yprim,x);

function [z,a]=rectprimconv(x,iv);
//////////////////////////
//convoluate with the derivative ofL1 normalized rectangle kernel
//////////////////////////
i=round(iv);
a=(i-1.0);
z=[x,zeros(1,i-1)]-[zeros(1,i-1),x];
z=z/iv;

function dim=reg_dimR(a,L,Lnoisy,R,reg,sigma,d);
//////////////////////////
//compute the regression by hand or automatically.
//////////////////////////

[nargout,nargin] = argn();
narg=nargin;

if narg <7
  d = 1;
end

I=find(L>0);
if length(I)<2
  disp('Choose a wider range or more voices: could not make any regression.')
  dim=%nan;
  newhfig=handlefig;
  return;
end
la=log(a(I));
lL=log(L(I));
  
if sigma>0
  J=find((R(I)>0)&(R(I)<0.5));
  if length(J)<2
    warning('The regression is done in an area where the noise prevalence ratio is upper than 0.5 (log10(NPR) > -0.3)');
    J=[length(I)-1,length(I)];
    [a_hat,b_hat,y_hat]=monolr(la(J),lL(J),'ls');
    Kreg=J;
    dim=d-a_hat;
  else
    [a_hat,b_hat,y_hat]=monolr(la(J),lL(J),'ls');
    Kreg=J;
    dim=d-a_hat;
  end
else
  [a_hat,b_hat,y_hat]=monolr(la,lL,'ls');
  Kreg=[1:length(la)];
  dim=d-a_hat;
end

if reg
  if sigma>0
    J=find(R>0);
    win=newwin();
    xset("window",win);
    xbasc();
    xset("use color",1); 
    xset("font",2,0);
    xsetech([0,0,1,0.5]);
    plot2d(log(a(J)),log10(R(J)),-1)
    xtitle('Noise Prevalence Ratio','Log(scale)','Log10(NPR)');
    xgrid();
    
  else
    win=newwin();
    xset("window",win);
    xbasc();
    xset("use color",1); 
    xset("font",2,0);
    xsetech([0,0,1,0.5]);
    diffL=mtlb_diff(lL);
    diffa=mtlb_diff(la);
    newa=a(2:length(la));
    J=find(diffa);
    dLdarate=diffL(J)./diffa(J);
    newa=newa(J);
    plot2d(log(newa),dLdarate,-1);
    xtitle('Increments \Delta log(L)','Log(scale)');
    xgrid();
  end
  X=[min(la(Kreg)),max(la(Kreg))];
  while length(X)==2
    xsetech([0,0.5,1,0.5]);
    [rect,rect1]=xgetech();
    rtit=1/6;
    xclea(rect1(1),rect1(4)+ (rect1(4)-rect1(2))* rtit ...
        ,rect1(3)-rect1(1),(rect1(4)-rect1(2))* (1.0+rtit));
    if sigma>0
      J=find(R>0);
      plot2d(log(a(J)),log(Lnoisy(J)),-2)
      plot2d(la,lL,-1,"000");
    else
      plot2d(la,lL,-1)
    end
    xgrid();
    Kreg=find((la>=min(X))&(la<=max(X)));
    if length(Kreg)<2
      xtitle('Choose a wider regression range','Log(scale)','Log(L)')
    else
      [slope,ord,y_hat]=monolr(la(Kreg),lL(Kreg),'ls');
      plot2d(la(Kreg),y_hat,2,"000");
      dim=d-slope; 
      xtitle(['Estimated Regularization Dimension = ',string(dim)],'Log(scale)','Log(L)');
    end
    X=input("Enter the regression range by its minimum scale and its maximum [amin,amax]=");
  end
end

function z=invfonc(x)
//////////////////////////
//inverse of function x*erf(x).
//////////////////////////

z=(sign(x).*sqrt(sqrt(%pi)/2*abs(x))+(x.^4).*(x+exp(-x.^2)/sqrt(%pi).*sign(x)))./(x.^4+1);



function win=newwin()
/////////////////////////
//find the next window number
/////////////////////////

w=mtlb_fliplr(sort(winsid()));
i=find(mtlb_diff(w)>1);
if i==[]
  win=max(w)+1;
else
  win=w(min(i))+1;
end

function dim=dimR2D(x,sigma,voices,Nmin,Nmax,kernelReg,mirror,reg)

[N,P]=size(x);
	  
if mirror 
  x=[mtlb_fliplr(x),x,mtlb_fliplr(x)];
  x=[mtlb_flipud(x);x;mtlb_flipud(x)];
  mirror=1;
end

jmax=voices;
iv=round(logspace(log10(Nmin),log10(Nmax),jmax));
imax=round(max(iv));
K=find(mtlb_diff(iv));
iv=[iv(K),imax];
jmax=length(iv);
////////////////////////////////////
//a:scale
//////////////////////////////////
a=[];
L=[];
Lnoisy=[];
R=[];

for j=1:jmax
  ii=round(iv(j));
  execstr(('[dzx,dzy,aa]='+ kernelReg+ '2dprimconv(x,iv(j));'));
  a(j)=aa;
  dzx=dzx(ii+1+mirror*(N-floor(iv(j)/2)) ...
      :N+mirror*(N+ii-floor(iv(j)/2)), ...
      ii+1+mirror*(P-floor(iv(j)/2)) ...
      :P+mirror*(P+ii-floor(iv(j)/2)));
  dzy=dzy(ii+1+mirror*(N-floor(iv(j)/2)) ...
      :N+mirror*(N+ii-floor(iv(j)/2)), ...
      ii+1+mirror*(P-floor(iv(j)/2)) ...
      :P+mirror*(P+ii-floor(iv(j)/2)));
  dlx=abs(dzx);
  dly=abs(dzy);
  dl=dlx+dly;
  if isempty(dl)
    break;
  end
  if sigma >0
    Lnoisy(j)=mean(mean(dl));
    execstr(('[dz,aa]='+ kernelReg+ '2dconv1(dzx,dzy,iv(j));'));
    a(j)=aa;
    dl=abs(dz);
    LRT=mean(mean(dl));
    //////////////////////////
    // signal/noise component rate
    ////////////////////////
    s=sigma/sqrt(sqrt(2*%pi)*a(j)^3);
    dln=2*s/sqrt(%pi).*exp(-(dl.^2)./s^2);
    //dlnx=2*s/sqrt(pi).*exp(-(dlx.^2)./s^2);
    //dlny=2*s/sqrt(pi).*exp(-(dly.^2)./s^2);
    //dln=dlnx+dlny;
    //dlsbx=dlx-dlnx;
    //dlsby=dly-dlny;
    dlsb=dl-dln;
    R(j)=mean(mean(dln))/LRT;
    //////////////////
    //Corrected unbiased lengths
    //////////////////
    //c=ones(1,ii)./ii;
    //dlsbmx=convol2(1,c,dlsbx);
    //dlsbmx=dlsbmx(ii:size(dlsbx,1),ii:size(dlsbx,2));
    //dlsbcx=s*sqrt(2)*invfonc(dlsbmx./(s*sqrt(2)));
    //dlsbmy=convol2(c,1,dlsby);
    //dlsbmy=dlsbmy(ii:size(dlsby,1),ii:size(dlsby,2));
    //dlsbcy=s*sqrt(2)*invfonc(dlsbmy./(s*sqrt(2)));
    //L(j)=mean(mean(dlsbcx))+mean(mean(dlsbcy));
    L(j)=mean(mean(dlsb))*Lnoisy(j)/LRT;
  else
    L(j)=mean(mean(dl))+(max([N,P]))^(-2);
  end
end

dim=reg_dimR(a,L,Lnoisy,R,reg,sigma,2);

function [h]=convol2(x,y,z)
//convoluate the real vector x with the coluns of z
//           the real vector y with the lines of z
//      or
//          if no z in entries, the real matrix x with the real matix y

[nargout,nargin] = argn();
narg=nargin;
if narg==3
  [n,p]=size(z);
  nl=length(x);
  nc=length(y);
  if size(x,2)==1
    x=x'
  end
  x=[x,zeros(1,n-1)];
  if size(y,2)==1
    y=y'
  end
  y=[y,zeros(1,p-1)];
  z=[z,zeros(n,nc-1);zeros(nl-1,p+nc-1)];
  zf=fft(z,-1);
  xf=fft(x',-1);
  yf=fft(y,-1);
  xf=xf(:,ones(1,p+nc-1));
  yf=yf(ones(1,n+nl-1),:);
  h=fft(zf.*xf.*yf,1);
else
  [nx,px]=size(x);
  [ny,py]=size(y);
  x=[x,zeros(nx,py-1);zeros(ny-1,px+py-1)];
  y=[y,zeros(ny,px-1);zeros(nx-1,px+py-1)];
  xf=fft(x,-1);
  yf=fft(y,-1);
  h=fft(xf.*yf,1);
end
h=real(h);

function g = gauss2d(n,a)

// GAUSS2D      GAUSS2D(N,A) returns the NxN-point Gauss 2d-window.
//            a corresponds to an attenuation of 10^(-a) at the end of the 
//            Gauss window
// Input:     -N number of points in one direction
//            -a dB attenuation. Default value is a = 2.
// Output:    -g time samples of the Gauss window
//
// Example:
//
// See also:
//

[nargout,nargin] = argn();
narg=nargin;
if narg==2
  g1=gauss(n,a);
else
  g1=gauss(n);
end

g=g1'*g1;

function [z,a]=gauss2dconv(x,iv);
alpha=3.0;
i=round(iv);
y=gauss2d(i,alpha);
a=(iv-1.0)/(2.0*sqrt(alpha*log(10)));
z=convol2(x,y);
Norm=(a*sqrt(%pi))^2;
z=z/Norm;

function [z,a]=gauss2dconv1(x,y,iv);
alpha=3.0;
ii=round(iv);
g=gauss(ii,alpha);
a=(ii-1.0)/(2.0*sqrt(alpha*log(10)));
zx=convol2(g,1,x);
zx=zx(floor(ii/2)+1:floor(ii/2)+size(x,1),:);
zy=convol2(1,g,y);
zy=zy(:,floor(ii/2)+1:floor(ii/2)+size(x,2));
z=zx+zy;
Norm=a*sqrt(%pi);
z=z/Norm;

function [gx,gy]=gauss2dprim(n,alpha)

// GAUSS2DPRIM      GAUSS2DPRIM(N,A) returns the derivative of
//                  NxN-point Gauss 2d-window.
//            a corresponds to an attenuation of 10^(-a) at the end of the 
//            Gauss window
// Input:     -N number of points in one direction
//            -a dB attenuation. Default value is a = 2.
// Output:    -g time samples of the derivative of Gauss window
//
// Example:
//
// See also:
//

[nargout,nargin] = argn();

if nargin == 1
  alpha = 2 ;
end

g=gauss(n,alpha);
g1=gauss(n,alpha,1);
gx=g'*g1;
gy=g1'*g;

function [zx,zy,a]=gauss2dprimconv(x,iv);
alpha=3.0;
ii=round(iv);
gx=gauss(ii,alpha,1);
a=(ii-1.0)/(2.0*sqrt(alpha*log(10)));
zx=convol2(1,gx,x);
zy=convol2(gx,1,x);
Norm=a*sqrt(%pi);
zx=zx/Norm;
zy=zy/Norm;

  

function [z,a]=rect2dconv(x,iv);
i=round(iv);
a=(iv-1.0);
y=ones(i,i);
y=y;
z=convol2(x,y);
Norm=iv^2;
z=z/Norm;

function [z,a]=rect2dconv1(x,y,iv);
ii=round(iv);
g=ones(1,ii);
a=(iv-1.0);
zx=convol2(g,1,x);
zx=zx(floor(ii/2)+1:floor(ii/2)+size(x,1),:);
zy=convol2(1,g,y);
zy=zy(:,floor(ii/2)+1:floor(ii/2)+size(x,2));
z=zx+zy;
Norm=iv;
z=z/Norm;

function [zx,zy,a]=rect2dprimconv(x,iv);
[n,p]=size(x);
j=round(iv);
a=(iv-1.0);
zx=[x,zeros(n,j-1)]-[zeros(n,j-1),x];

zy=[zeros(j-1,p);x]-[x;zeros(j-1,p)];

Norm=iv;
zx=zx/Norm;
zy=zy/Norm;

