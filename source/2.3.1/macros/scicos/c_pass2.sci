function cpr=c_pass2(bllst,connectmat,clkconnect,cor,corinv)
// cor    ; correspondance table with initial block ordering
//
// bllst: list with nblk elts where nblk denotes number of blocks.
//        Each element must be a list with 12 elements:
//          1- function name (in string form if fortran routine) 
//          2- vector of number of inputs
//          3- vector of number of ouputs
//          4- vector of number of clock inputs 
//          5- vector of number of clock outputs
//          6- vector (column) of continuous initial condition
//          7- vector (column) of discrete initial condition
//          8- vector (column) of real parameters
//          9- vector (column) of integer parameters
//          10- string: 'z' if zero-crossing, 'c' if continuous, 
//                      'd' discrete, 'l' logical
//          11- vector of size <number of clock outputs> including
//              preprogrammed event firing times (<0 if no firing) 
//              or [for backward compatibility]
//              boolean vector: i-th entry %t if initially output is fired
//          12- boolean vector (1x2): 1st entry for dependence on u, 2nd on t 
//
// connectmat: nx4 matrix. Each row contains, in order, the block
//             number and the port number of an outgoing scicopath,
//             and the block number and the port number of the target
//             ingoing scicopath.
//
// clkconnect: same as connectmat but for clock scicopaths.
//
// define some constants

//timer()


if bllst==list() then
  message(['No block can be activated'])
  cpr=list()
  ok=%f;
  return
end


done=%f
clkptr=1,cliptr=1,typl=[],dep_ut=[],ddep_ut=[]
nblk=size(bllst)
while ~done
  //replace all logical blocks recursively
  [clkptr,cliptr,typl,dep_ut,ddep_ut]=make_ptr(bllst,clkptr,cliptr,typl,..
      dep_ut,ddep_ut)
  [ok,done,bllst,connectmat,clkconnect,typl,corinv]=paksazi(bllst,..
      connectmat,clkconnect,..
      corinv,clkptr,cliptr,typl,dep_ut,ddep_ut)
  if ~ok then
    cpr=list()
    return
  end
end

//
//sort blocks by their types
// 1- blocks with continuous states
// 2- blocks with no states
// 3- logical blocks
// 4- blocks with discrete states
// 5- zero crossing blocks

[ind,nxblk,ncxblk,ndblk,ndcblk]=find_order_blocks(bllst)

if nxblk==0 & ndcblk<>0 then
  message(['For using treshold, you need to have'
      'a continuous system with state in your diagram.';
      'You can include DUMMY CLSS block (linear palette)'
      'in your diagram.']);
  cpr=list()
  ok=%f;
  return
end

ncblk=nxblk+ncxblk;
nb=ncblk+ndblk;
nblk=nb+ndcblk;

[bllst,connectmat,clkconnect,cor,corinv]=..
    re_order_blocks(bllst,connectmat,clkconnect,cor,corinv,ind)

//extract various info from bllst
[lnkptr,inplnk,outlnk,clkptr,cliptr,inpptr,outptr,..
    xptr,zptr,rpptr,ipptr,xc0,xd0,rpar,ipar,dep_ut,ddep_ut,..
    typl,typ_r,typ_c,funs,funtyp,initexe,labels,ok]=extract_info(bllst,..
    connectmat,clkconnect)

if ~ok then 
  cpr=list()
  return,
end

//form a matrix which gives destinations of each block
[outoin,outoinptr]=conn_mat(inpptr,outptr,inplnk,outlnk)
//
// discard duplicate calls to the same block port
// and group calls to different ports of the same block
// to compute execution table and its pointer.
[ordptr1,execlk]=discard(clkptr,cliptr,clkconnect)

// Set execution scheduling tables 
[ordptr,ordclk,cord,iord,oord,zord,critev,ok]=scheduler(inpptr,..
    outptr,clkptr,execlk,ordptr1,outoin,outoinptr);

if ~ok then 
  cpr=list()
  return,
end

//form scicos arguments
izptr=ones(nblk+1,1)

simtp=['scs','funs','xptr','zptr','izptr','inpptr','outptr','inplnk',..
    'outlnk','lnkptr','rpar','rpptr',..
    'ipar','ipptr','clkptr','ordptr','execlk','ordclk','cord','oord',..
    'zord','critev','ncblk','nxblk','ndblk','ndcblk','subscr','funtyp',..
    'iord','labels']

subscr=[]
sim=tlist(simtp,funs,xptr,zptr,izptr,..
          inpptr,outptr,inplnk,outlnk,..
	  lnkptr,rpar,rpptr,ipar,ipptr,clkptr,..
          ordptr,execlk,ordclk,cord(:),oord(:),zord(:),..
	  critev(:),ncblk,nxblk,ndblk,ndcblk,subscr,funtyp,iord(:),labels);

//initialize agenda
[tevts,evtspt,pointi]=init_agenda(initexe,clkptr)


statetp=['xcs','x','z','iz','tevts','evtspt','pointi','outtb']
outtb=0*ones(lnkptr($)-1,1)
iz0=[]
state=tlist(statetp,xc0,xd0,iz0,tevts,evtspt,pointi,outtb);
cpr=list(state,sim,cor,corinv)



function [ordptr,ordclk,cord,iord,oord,zord,critev,ok]=..
    scheduler(inpptr,outptr,clkptr,execlk,ordptr1,outoin,outoinptr);
//
t_var_blk=find(dep_ut(:,2));
//
//compute cord
vec=-ones(1,nblk)
vec(1:nxblk)=0*ones(1,nxblk)  // continuous system with state
vec(t_var_blk)=0*t_var_blk // time varying blocks

[cord,ok]=tree2(vec,outoin,outoinptr,dep_ut)
//discard blocks  with no outputs and insensitive to t and u.
cord=cord(:,1)
if cord<>[] then
  cord(outptr(cord+1)-outptr(cord)==0)=[]
end
//
if cord<>[] then
  cord(funtyp(cord)>99)=[]
end
//
//compute iord
vec=-ones(1,nblk)
vec(1:nxblk)=0*ones(1,nxblk)  // continuous system with state
vec(t_var_blk)=0*t_var_blk // time varying blocks
no_tu_dep=find((~dep_ut(:,1))&(~dep_ut(:,2)));
vec(no_tu_dep)=0*no_tu_dep


[iord,ok]=tree2(vec,outoin,outoinptr,dep_ut)
//discard blocks  with no outputs 
iord=iord(:,1)
if iord<>[] then
  iord(outptr(iord+1)-outptr(iord)==0)=[]
end
if iord<>[] then
  iord(funtyp(iord)>99)=[]
end
//
if ~ok then 
  message('Algebraic loop detected; cannot be compiled.');
  ordptr=[],ordclk=[],cord=[],iord=[],oord=[],zord=[],critev=[]
  return,
end

ordclk=[]
ordptr2=ordptr1
for o=1:clkptr(nblk+1)-1
  p_ut=dep_ut
  p_ut(execlk(ordptr1(o):ordptr1(o+1)-1,1),:)=..
      ddep_ut(execlk(ordptr1(o):ordptr1(o+1)-1,1),:)
  t_varb=find(p_ut(:,2))
//  
  vec=-ones(1,nblk);
  wec=zeros(1,nblk);
  vec(execlk(ordptr1(o):ordptr1(o+1)-1,1)')=..
      zeros(execlk(ordptr1(o):ordptr1(o+1)-1,1))';
  wec(execlk(ordptr1(o):ordptr1(o+1)-1,1)')=..
      execlk(ordptr1(o):ordptr1(o+1)-1,2)';  
  vec(t_varb)=0*t_varb
  [r,ok]=tree2(vec,outoin,outoinptr,p_ut)

  if ~ok then 
    message('Algebraic loop detected; cannot be compiled.');
    ordptr=[],ordclk=[],cord=[],iord=[],oord=[],zord=[],critev=[]
    return,
  end
  tt=find(wec(r(:,1))<>0)
  r(tt,2)=wec(r(tt,1))'
  if r<>[] then
    sel=outptr(r(:,1)+1)-outptr(r(:,1))==0 //block without output
    sel=sel&(~p_ut(r(:,1),1)) //block without u dependancy
    r(sel,:)=[] 
//    r(outptr(r(:,1)+1)-outptr(r(:,1))==0,:)=[]
  end
  if r<>[] then
    r((funtyp(r(:,1))>99),:)=[]
  end
  //

  ordptr2(1+o)=size(r,1)+ordptr2(o)
  ordclk=[ordclk;r]
end

ordptr=[ordptr1,ordptr2];

zord=cord
oord=cord
n=size(cord,1)
for iii=n:-1:1
  i=cord(iii)
  fl=%f
  fz=%f
  for ii=outoin(outoinptr(i):outoinptr(i+1)-1,1)'
    //ii est un block affecte par changement de sortie du 
    //i-eme block de oord
//    if ii<=nxblk | ii>nb then fz=%t;end
    if ii>nb then fz=%t;end
    if ii<=nxblk then fl=%t;end
    if fl&fz then break,end
    //si ii est un block integre (continu avec etat) 
    //il faut garder i
    for l=iii+1:n
      //si ii est un block qu'on a decide de garder 
      //il faut garder i
      if ii==zord(l) then fz=%t; end
      if ii==oord(l) then fl=%t; end
      if fl&fz then break,end
    end
    if fl&fz then break; end
  end
  //mettre a zero si block doit etre supprimer
  if ~fl then oord(iii)=0; end
  if ~fz then zord(iii)=0; end
end

//supprimer les blocks a supprimer
oord=oord(oord<>zeros(oord))
zord=zord(zord<>zeros(zord))

//critev: vecteur indiquant si evenement est important pour tcrit
//ordclk_fut et ordptr3 sont l'analogue de ordclk et ordptr2 sauf
//pour le fait que la dependance en temps n'est pas pris en compte.
//Donc les blocks indiques sont des blocks susceptibles de produire
//des discontinuites quand l'evenement se produit

ordclk_fut=[]
ordptr3=ordptr1

for o=1:clkptr(nblk+1)-1
  p_ut=dep_ut
  p_ut(execlk(ordptr1(o):ordptr1(o+1)-1,1),:)=..
      ddep_ut(execlk(ordptr1(o):ordptr1(o+1)-1,1),:)
  vec=-ones(1,nblk);
  vec(execlk(ordptr1(o):ordptr1(o+1)-1,1)')=..
      zeros(execlk(ordptr1(o):ordptr1(o+1)-1,1))';
  [r,ok]=tree2(vec,outoin,outoinptr,p_ut)
  r=r(:,1)
  
  if ~ok then 
    message('Algebraic loop detected; cannot be compiled.');
    ordptr=[],ordclk=[],cord=[],iord=[],oord=[],zord=[],critev=[]
    return,
  end
  ordptr3(1+o)=size(r,1)+ordptr3(o)
  ordclk_fut=[ordclk_fut;r]
end

// 1: important; 0:non
n=clkptr(nblk+1)-1 //nb d'evenement
//a priori tous les evenemets sont non-importants
critev=zeros(n,1)
for i=1:n
  fl=%f
  for jj= ordclk_fut(ordptr3(i):ordptr3(i+1)-1)' //block excite par evenement i
    for ii=outoin(outoinptr(jj):outoinptr(jj+1)-1,1)'//block excite par block excite par evenement i
      //si il est integre, i est important
      if ii<>[] & (ii <= nxblk | ii>nb) then fl=%t;break; end
//	      if ii <= nxblk then fl=%t;break; end
    end
    if fl then break;end
  end
  if fl then critev(i,1)=1; end
end



function [ord,ok]=ctree(vec,in,depu)
//sctree(nb,vec,in,depu,outptr,cmat,ord,nord,ok,kk)
jj=find(depu);dd=zeros(depu);dd(jj)=ones(jj)';depu=dd;
nb=prod(size(vec));kk=zeros(vec);
[ord,ok]=sctree(vec,in,depu,outptr,cmatp);
ok=ok==1;
ord=ord';

function [ord,ok]=tree3(vec,dep_ut,typl)
//compute blocks execution tree
ok=%t
nb=size(vec,'*')
for j=1:nb+2
  fini=%t
  for i=1:nb
    if vec(i)==j-1 then 
      if j==nb+2 then 
	message('algebraic loop detected');ok=%f;ord=[];return;
      end
      if typl(i)==%t then
	fini=%f;
	kk=bexe(boptr(i):boptr(i+1)-1)';
      else
	kk=[];
	for ii=blnk(blptr(i):blptr(i+1)-1)'
	  if dep_ut(ii,1)|(typl(ii)&vec(ii)>-1) then
	    fini=%f;
	    kk=[kk ii];
	  end
	end
      end
      vec(kk)=j*ones(kk) ;   //disp(vec)
    end
  end
  if fini then break;end
end
[k,ord]=sort(-vec);
ord(find(k==1))=[];

function [okk,done,bllst,connectmat,clkconnect,typl,corinv]=..
    paksazi(bllst,connectmat,clkconnect,corinv,clkptr,cliptr,..
    typl,dep_ut,ddep_ut)
okk=%t
nblk=length(bllst)
nblkorg=nblk
if ~or(typl) then
  done=%t;
  return
end
change=%f
for lb=find(typl)
  indx=find(clkconnect(:,3)==lb) 
  nn=size(indx,'*')
  if nn>=2 then
    indxo=find(clkconnect(:,1)==lb)
    indy=find(connectmat(:,3)==lb)
    if size(indy,'*')>1 then 
      disp('logical unit cannot have more than 1 input')
    end
    for k=2:nn
      clkconnect(indx(k),3)=nblk+1;
      bllst(nblk+1)=bllst(lb);
      corinv(nblk+1)=corinv(lb);
      tmp=clkconnect(indxo,:);
      yek=ones(tmp(:,1))
      clkconnect=[clkconnect;[yek*(nblk+1),tmp(:,[2 3 4])]]
      nblk=nblk+1
    end
  connectmat=[connectmat;..
	[connectmat(indy,[1 2]),[nblkorg+1:nblk]',ones(nn-1,1)]]
  change=%t
  nblkorg=nblk
  end
end
if change then done=%f;return; end
//
con=clkptr(clkconnect(:,1))+clkconnect(:,2)-1
[junk,ind]=sort(-con);con=-junk
clkconnect=clkconnect(ind,:)
//
bclkconnect=clkconnect(:,[1 3])
boptr=1
bexe=[]
for i=1:nblk
  r=bclkconnect(find(bclkconnect(:,1)==i),2)
  bexe=[bexe;r]
  boptr=[boptr;boptr($)+size(r,1)]
end
//
bconnectmat=connectmat(:,[1 3])
blptr=1
blnk=[]

for i=1:nblk
  r=bconnectmat(find(bconnectmat(:,1)==i),2)
  blnk=[blnk;r]
  blptr=[blptr;blptr($)+size(r,1)]
end  
//
tclkconnect=clkconnect(~typl(clkconnect(:,1)),:)
tcon=clkptr(tclkconnect(:,1))+tclkconnect(:,2)-1
texeclk=tclkconnect(:,[3 4]);

ordptr1=1
for i=1:clkptr($)-1
  tmp=find(tcon<=i)
  if tmp==[] then 
    ordptr1(i+1)=ordptr1(i)
  else
    ordptr1(i+1)=max(tmp)+1
  end
end
//
pointer=[]
ordclk=[]
ordptr2=ordptr1
for o=1:clkptr($)-1
  p_ut=dep_ut
  texeclki=texeclk(ordptr1(o):ordptr1(o+1)-1,1)
  if texeclki<>[] then
    p_ut=dep_ut
    p_ut(texeclki,:)=ddep_ut(texeclki,:)
    vec=-ones(1,nblk);
    vec(texeclki')=zeros(texeclki)';
    
    [r,ok]=tree3(vec,p_ut,typl)
    if ~ok then 
      message('Algebraic loop detected; cannot be compiled.');
      ordptr=[],ordclk=[],cord=[],iord=[],oord=[],zord=[],critev=[]
      okk=%f;done=%t;return,
    end
    
    pointer=find(con==o)
    for bl=r
      if typl(bl) then
	mod=bllst(bl);mod(10)=%f,bllst(bl)=mod,typl(bl)=%f
	pointer=pointer(find(clkconnect(pointer,3)<>bl));
	yek=ones(pointer');
	clkconnect(pointer,:)=..
	    [yek*bl,yek,clkconnect(pointer,[3 4])];
	//connect all the event outputs of the logical block to ....
	for bl_out=2:clkptr(bl+1)-clkptr(bl)
	  clkconnect=[clkconnect;[yek*bl,bl_out*yek,clkconnect(pointer,[3 4])]];
	end
	//
	ok=%f,return
      else
	pointer=pointer(find(clkconnect(pointer,3)<>bl))
      end
    end
  end
  if pointer<>[] then warning('problem1');pause;end
end;
//

if or(typl) then warning('problem2');pause;end
//
okk=%t;done=%t;

function [ind,nxblk,ncxblk,ndblk,ndcblk]=find_order_blocks(bllst)
status=[];
nxblk=0;ncxblk=0;ndblk=0;ndcblk=0;
for i=1:length(bllst)
  //  Compile if the block is defined by an uncompiled Scilab function
  ll=bllst(i)
  if ll(6)<>[] then 
    if ll(10)=='z' then 
      disp('zero crossing blocks cannot have states');
      pause
    end
    //continuous block with state
    nxblk=1+nxblk;status=[status;1];
  elseif ll(7)==[]&ll(10)<>'l'&ll(10)<>'z' then 
    // block without state 
    ncxblk=ncxblk+1;status=[status;2];
  elseif ll(10)=='l' then 
    // block without state 
    ncxblk=ncxblk+1;status=[status;3];
  elseif ll(7)<>[] then 
    //discrete state block 
     status=[status;4];ndblk=ndblk+1
  elseif ll(10)=='z' then 
    //zero crossing block
    ndcblk=ndcblk+1;status=[status;5];
  end
end
[junk,ind]=sort(-status)


function [bllst,connectmat,clkconnect,cor,corinv]=..
    re_order_blocks(bllst,connectmat,clkconnect,cor,corinv,ind)

bltmp=list()
for i=1:length(bllst)
  bltmp(i)=bllst(ind(i))
  k1=corinv(ind(i))
  select size(k1,'*')
  case 0 then
  case 1  then
    cor(k1)=i
  else
    cor=change_tree_elt(cor,k1,i)  
  end
end
corinv_s=corinv;
corinv=list()
for i=1:size(corinv_s)
  corinv(i)=corinv_s(ind(i));
end
// corinv=[]

bllst=bltmp;bltmp=null()

[junk,indinv]=sort(-ind)
connectmat(:,1)=indinv(connectmat(:,1))
connectmat(:,3)=indinv(connectmat(:,3))
clkconnect(:,1)=indinv(clkconnect(:,1))
clkconnect(:,3)=indinv(clkconnect(:,3))


function [ordptr1,execlk]=discard(clkptr,cliptr,clkconnect)
con=clkptr(clkconnect(:,1))+clkconnect(:,2)-1
[junk,ind]=sort(-con);con=-junk
clkconnect=clkconnect(ind,:)
//
  ordptr1=1
  for i=1:clkptr($)-1
    tmp=find(con<=i)
    if tmp==[] then 
      ordptr1(i+1)=ordptr1(i)
    else
      ordptr1(i+1)=max(tmp)+1
    end
  end
new_execlk=[]
new_ordptr1=1

for j=1:clkptr($)-1
  if ordptr1(j)<>ordptr1(j+1) then
    clkconnectj=[clkconnect(ordptr1(j):ordptr1(j+1)-..
	ones(ordptr1(j+1)),3),clkconnect(ordptr1(j):ordptr1(j+1)-1,4)]
    con=cliptr(clkconnectj(:,1))+clkconnectj(:,2)-ones(clkconnectj(:,2))
    [junk,ind]=sort(-con);con=-junk
    clkconnectj=clkconnectj(ind,:)
    // discard duplicate calls to the same block port
    if size(con,'*')>=2 then
      clkconnectj(find(con(2:$)-con(1:$-1)==0),:)=[]
    end
    // group calls to different ports of the same block.
    clkconnectj=[clkconnectj(:,1),2^(clkconnectj(:,2)-..
	ones(clkconnectj(:,2)))]
    con=clkconnectj(:,1)
    clkconnectjj=[]
    if size(con,'*')>=2 then 
      iini=[find(con(2:$)-con(1:$-1)<>0),size(clkconnectj,1)]
    else
      iini=1
    end
    for ii=iini
      clkconnectjj=[clkconnectjj;[clkconnectj(ii,1),..
	  mysum(clkconnectj(find(clkconnectj(:,1)==clkconnectj(ii,1)),2))]]
    end
  else
    clkconnectjj=[]
  end

  wec=zeros(1,nblk);
  wec(clkconnectjj(:,1)')=clkconnectjj(:,2)';  
  [r,ok]=tree1(wec,outoin,outoinptr,typ_r,typ_c)

  if ~ok then 
    message('Algebraic loop detected; cannot be compiled.');
    ordptr=[],ordclk=[],cord=[],iord=[],oord=[],zord=[],critev=[]
    return,
  end
  tt=find(wec(r(:,1))>0)
  r(tt,2)=wec(r(tt,1))'
  
  new_execlk=[new_execlk;r]
  new_ordptr1=[new_ordptr1;new_ordptr1($)+size(r,1)]
end
execlk=new_execlk
ordptr1=new_ordptr1


function a=mysum(b)
if b<>[] then a=sum(b), else a=[], end


function [lnkptr,inplnk,outlnk,clkptr,cliptr,inpptr,outptr,..
    xptr,zptr,rpptr,ipptr,xc0,xd0,rpar,ipar,dep_ut,ddep_ut,..
    typl,typ_r,typ_c,funs,funtyp,initexe,labels,ok]=extract_info(bllst,..
    connectmat,clkconnect)

ok=%t
clkptr=1;cliptr=1;
inpptr=1;outptr=1;
xptr=1;zptr=1;rpptr=1;ipptr=1;

//
xc0=[];xd0=[];rpar=[];ipar=[];
dep_ut=[];ddep_ut=[];typl=[];typ_r=[];typ_c=[]
initexe=[];
funs=list();
funtyp=[];
labels=[]
//
//
for i=1:length(bllst)
  ll=bllst(i)
  if type(ll(1))==15 then
    funs(i)=ll(1)(1)
    funtyp(i,1)=ll(1)(2)
  else
    funs(i)=ll(1);
    funtyp(i,1)=0;
  end
  inpnum=ll(2);outnum=ll(3);cinpnum=ll(4);coutnum=ll(5);
  //
  if cinpnum<>[] & find(clkconnect(:,3)==i)==[] then
    typ_r(i)=%t
  else
    typ_r(i)=%f
  end
  //
  inpptr=[inpptr;inpptr($)+size(inpnum,'*')]
  outptr=[outptr;outptr($)+size(outnum,'*')]
  cliptr=[cliptr;cliptr($)+size(cinpnum,'*')]
  clkptr=[clkptr;clkptr($)+size(coutnum,'*')]
  //
  xc0=[xc0;ll(6)(:)]
  xptr=[xptr;xptr($)+size(ll(6),'*')]
  
  
  if funtyp(i,1)==3 then //sciblocks
    xd0k=var2vec(ll(7))
  else
    xd0k=ll(7)(:)
  end
  xd0=[xd0;xd0k]
  zptr=[zptr;zptr($)+size(xd0k,'*')]
  //  
  if funtyp(i,1)==3 then //sciblocks
    rpark=var2vec(ll(8))
  else
    rpark=ll(8)(:)
  end
  rpar=[rpar;rpark]
  rpptr=[rpptr;rpptr($)+size(rpark,'*')]
  if type(ll(9))==1 then 
    ipar=[ipar;ll(9)(:)]
    ipptr=[ipptr;ipptr($)+size(ll(9),'*')]
  else
    ipptr=[ipptr;ipptr($)]
  end
  //
  typl=[typl;ll(10)=='l']
  ddep_ut=[ddep_ut;(ll(12)(:))'];
  dep_ut=[dep_ut;ll(12)&(ll(10)=='c')];
  //
  if ll(10)=='c' then
    typ_c(i)=%t
  else
    typ_c(i)=%f
  end
  //
  if ll(5)<>[] then  
    ll11=ll(11)
    prt=find(ll11>=zeros(ll11))
    nprt=prod(size(prt))
    initexe=[initexe;..
	[i*ones(nprt,1),matrix(prt,nprt,1),matrix(ll11(prt),nprt,1)]];
  end

  if size(ll)>=13 then
    if type(ll(13))==10 then
      labels=[labels;ll(13)(1)]
    else
      labels=[labels;' ']
    end
  else
    labels=[labels;' ']
  end
end

[ok,bllst]=adjust_inout(bllst,connectmat)
nlnk=size(connectmat,1)
inplnk=zeros(inpptr($)-1,1);outlnk=zeros(outptr($)-1,1);ptlnk=1;
lnkbsz=[]
for jj=1:nlnk
  ko=outlnk(outptr(connectmat(jj,1))+connectmat(jj,2)-1)
  ki=inplnk(inpptr(connectmat(jj,3))+connectmat(jj,4)-1)
  if ko<>0 & ki<>0 then
    if ko>ki then 
      outlnk(outlnk>ko)=outlnk(outlnk>ko)-1
      outlnk(outlnk==ko)=ki
      inplnk(inplnk>ko)=inplnk(inplnk>ko)-1
      inplnk(inplnk==ko)=ki
      ptlnk=-1+ptlnk
      lnkbsz(ko)=[]
    elseif ki>ko
      outlnk(outlnk>ki)=outlnk(outlnk>ki)-1
      outlnk(outlnk==ki)=ko
      inplnk(inplnk>ki)=inplnk(inplnk>ki)-1
      inplnk(inplnk==ki)=ko
      ptlnk=-1+ptlnk
      lnkbsz(ki)=[]
    end
    
  elseif ko<>0 then
    inplnk(inpptr(connectmat(jj,3))+connectmat(jj,4)-1)=ko
  elseif ki<>0 then
    outlnk(outptr(connectmat(jj,1))+connectmat(jj,2)-1)=ki
  else
    outlnk(outptr(connectmat(jj,1))+connectmat(jj,2)-1)=ptlnk
    inplnk(inpptr(connectmat(jj,3))+connectmat(jj,4)-1)=ptlnk
    lnkbsz=[lnkbsz;bllst(connectmat(jj,1))(3)(connectmat(jj,2))]
    ptlnk=1+ptlnk
  end
end
lnkptr=cumsum([1;lnkbsz])


//store unconnected outputs, if any, at the end of outtb
unco=find(outlnk==0);
if unco==[] then return;end
siz_unco=0
for j=unco
  m=maxi(find(outptr<=j))
  n=j-outptr(m)+1
  siz_unco=maxi(siz_unco,bllst(m)(3)(n))
end
lnkptr=[lnkptr;lnkptr($)+siz_unco]
outlnk(unco)=maxi(outlnk)+1

  
function [outoin,outoinptr]=conn_mat(inpptr,outptr,inplnk,outlnk)
outoin=[];outoinptr=1
for i=1:nblk
  k=outptr(i):outptr(i+1)-1
  ii=[]
  for j=outlnk(k)'
    ii=[ii,find(inplnk==j)]
  end
  outoini=[];jj=0
  for j=ii
    m=maxi(find(inpptr<=j))
    n=j-inpptr(m)+1
    outoini=[outoini;[m,n]]
    jj=jj+1
  end
  outoinptr=[outoinptr;outoinptr($)+jj]
  outoin=[outoin;outoini]
end


function [clkptr,cliptr,typl,dep_ut,ddep_ut]=make_ptr(bllst,clkptr,cliptr,typl,dep_ut,ddep_ut)
nblk0=size(clkptr,'*')

for i=nblk0:size(bllst)
  ll=bllst(i)
  cliptr=[cliptr;cliptr($)+sum(ll(4))]
  clkptr=[clkptr;clkptr($)+sum(ll(5))]
  typl=[typl;ll(10)=='l']
  ddep_ut=[ddep_ut;ll(12)];
  dep_ut=[dep_ut;ll(12)&(ll(10)=='c')];
end


function [ord,ok]=tree2(vec,outoin,outoinptr,dep_ut)
//compute blocks execution tree
ok=%t;
wec=zeros(vec);
nb=size(wec,'*');
for j=1:nb+2
  fini=%t
  for i=1:nb
    if vec(i)==j-1 then 
      if j==nb+2 then 
	message('algebraic loop detected');ok=%f;ord=[];return;
      end
      //      kk=[];
      for k=outoinptr(i):outoinptr(i+1)-1
	ii=outoin(k,1);
	if dep_ut(ii,1) then
	  fini=%f;
	  //	 kk=[kk ii];
	  vec(ii)=j;   
	  wec(ii)=wec(ii)-2^(outoin(k,2)-1)
	end
      end
      //      vec(kk)=j*ones(kk) ;   
    end
  end
  if fini then break;end
end
[k,ord]=sort(-vec);
ord(find(k==1))=[];
//disp('tree2');
ord=[ord',wec(ord)']


function [ok,bllst]=adjust_inout(bllst,connectmat)
nlnk=size(connectmat,1)
for hhjj=1:length(bllst)
for hh=1:length(bllst)
  ok=%t
  for jj=1:nlnk
    nout=bllst(connectmat(jj,1))(3)(connectmat(jj,2))
    nin=bllst(connectmat(jj,3))(2)(connectmat(jj,4))
    if (nout>0&nin>0) then
      if nin<>nout then
	bad_connection(corinv(connectmat(jj,1)),connectmat(jj,2),nout,..
	    corinv(connectmat(jj,3)),connectmat(jj,4),nin)
	ok=%f;return
      end
    elseif (nout>0&nin<0) then 
      ww=find(bllst(connectmat(jj,3))(2)==nin)
      bllst(connectmat(jj,3))(2)(ww)=nout
      
      ww=find(bllst(connectmat(jj,3))(3)==nin)
      bllst(connectmat(jj,3))(3)(ww)=nout
    elseif (nin>0&nout<0) then 
      ww=find(bllst(connectmat(jj,1))(3)==nout)
      bllst(connectmat(jj,1))(3)(ww)=nin

      ww=find(bllst(connectmat(jj,1))(2)==nout)
      bllst(connectmat(jj,1))(2)(ww)=nin

    elseif (nin==0) then
      ww=bllst(connectmat(jj,3))(3)(:)
      if mini(ww)>0 then 
	if nout>0 then
	  if sum(ww)==nout then
	    bllst(connectmat(jj,3))(2)(connectmat(jj,4))=nout
	  else
	    bad_connection(corinv(connectmat(jj,3)))
	    ok=%f;return
	  end
	else
	  bllst(connectmat(jj,3))(2)(connectmat(jj,4))=sum(ww)
	  ok=%f
	end
      else      
	nww=ww(find(ww<0))
	if norm(nww-nww(1),1)==0 & nout>0 then
	  bllst(connectmat(jj,3))(2)(connectmat(jj,4))=nout
	  k=(nout-sum(ww(find(ww>0))))/size(nww,'*')
	  if k==int(k) then
	    bllst(connectmat(jj,3))(3)(find(ww<0))=k
	  else
	    bad_connection(corinv(connectmat(jj,3)))
	    ok=%f;return
	  end
	else
	  ok=%f
	end
      end

    elseif (nout==0) then
      ww=bllst(connectmat(jj,1))(2)(:)
      if mini(ww)>0 then 
	if nin>0 then
	  if sum(ww)==nin then
	    bllst(connectmat(jj,1))(3)(connectmat(jj,2))=nin
	  else
	    bad_connection(corinv(connectmat(jj,1)))
	    ok=%f;return
	  end
	else
	  bllst(connectmat(jj,1))(3)(connectmat(jj,2))=sum(ww)
	  ok=%f
	end
      else      
	nww=ww(find(ww<0))
	if norm(nww-nww(1),1)==0 & nin>0 then
	  bllst(connectmat(jj,1))(3)(connectmat(jj,2))=nin
	  k=(nout-sum(ww(find(ww>0))))/size(nww,'*')
	  if k==int(k) then
	    bllst(connectmat(jj,1))(2)(find(ww<0))=k
	  else
	    bad_connection(corinv(connectmat(jj,1)))
	    ok=%f;return
	  end
	else
	  ok=%f
	end
      end	

    else
      //case where both are negative
      ok=%f
    end
  end
if ok then return, end
end
message('Not enough information to determine port sizes');  
  for jj=1:nlnk
    nout=bllst(connectmat(jj,1))(3)(connectmat(jj,2))
    nin=bllst(connectmat(jj,3))(2)(connectmat(jj,4))
    if nout<=0&nin<=0 then
      	ninnout=under_connection(corinv(connectmat(jj,1)),connectmat(jj,2),nout,..
	    corinv(connectmat(jj,3)),connectmat(jj,4),nin)
	if ninnout==[] then ok=%f;return;end
	if ninnout<=0  then ok=%f;return;end
      bllst(connectmat(jj,1))(3)(connectmat(jj,2))=ninnout
      bllst(connectmat(jj,3))(2)(connectmat(jj,4))=ninnout
    end
  end
end

function ninnout=under_connection(path_out,prt_out,nout,path_in,prt_in,nin)
// alert for badly connected blocks
// path_out : Path of the "from block" in scs_m
// path_in  : Path of the "to block" in scs_m
//!
  lp=mini(size(path_out,'*'),size(path_in,'*'))
  k=find(path_out(1:lp)<>path_in(1:lp))
  path=path_out(1:k(1)-1) // common superbloc path
  path_out=path_out(k(1)) // "from" block number
  path_in=path_in(k(1))   // "to" block number
  
  if path==[] then
    hilite_obj(scs_m(path_out))
    if or(path_in<>path_out) then hilite_obj(scs_m(path_in)),end

      ninnout=evstr(dialog(['Hilited block(s) have connected ports ';
	'with  sizes that cannot be determiend by the context';
	'what is the size of this link'],'1'))
    hilite_obj(scs_m(path_out))
    if or(path_in<>path_out) then hilite_obj(scs_m(path_in)),end
  else
    mxwin=maxi(winsid())
    for k=1:size(path,'*')
      hilite_obj(scs_m(path(k)))
      scs_m=scs_m(path(k))(3)(8);
      scs_show(scs_m,mxwin+k)
    end
    hilite_obj(scs_m(path_out))
    if or(path_in<>path_out) then hilite_obj(scs_m(path_in)),end
      ninnout=evstr(dialog(['Hilited block(s) have connected ports ';
	'with  sizes that cannot be determiend by the context';
	'what is the size of this link'],'1'))
    for k=size(path,'*'):-1:1,xdel(mxwin+k),end
    scs_m=null()
    unhilite_obj(scs_m(path(1)))
  end



function [ord,ok]=tree1(wec,outoin,outoinptr,typ_r,typ_c)
//compute blocks execution tree
ok=%t
wec=wec(:);vec=-ones(wec);vec(find(wec<>0))=0;
nb=size(wec,'*')
for j=1:nb+2
  fini=%t
  for i=1:nb
    if vec(i)==0 then 
      vec(i)=-2   //turn off block i for ever
      if j==nb+2 then 
	message('problem!!!!!!');ok=%f;ord=[];return;
      end
      for k=outoinptr(i):outoinptr(i+1)-1
	ii=outoin(k,1);
	if vec(ii)==-1 & (typ_r(ii) | typ_c(ii)) then
	  fini=%f;
	  vec(ii)=0
	  if typ_r(ii) then 
	    wec(ii)=wec(ii)-2^(outoin(k,2)-1)
	  end
	end
      end
    end
  end
  if fini then break;end
end
ord=find(wec<>0)'
ord=[ord,wec(ord)]

