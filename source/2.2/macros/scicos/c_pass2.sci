function [state,sim,cor,corinv,ok]=c_pass2(bllst,connectmat,clkconnect,cor,corinv,modsim)
// cor    ; correspondance table with initial block ordering
//
// bllst: list with nblk elts where nblk denotes number of blocks.
//        Each element must be a list with 12 elements:
//          1- function name (in string form if fortran routine)
//          2- number of inputs
//          3- number of ouputs
//          4- number of clock inputs
//          5- number of clock outputs
//          6- vector (column) of continuous initial condition
//          7- vector (column) of discrete initial condition
//          8- vector (column) of real parameters
//          8- vector (column) of integer parameters
//          10- string: 'z' if zero-crossing, else otherwise
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
ok=%t;
//sort blocks by their types (first regular blocks, then 'z' blocks)
status=[];
nxblk=0;ncxblk=0;ndblk=0;ndcblk=0;
for i=1:length(bllst)
  //  Compile if the block is defined by an uncompiled Scilab function
  ll=bllst(i)
  if ll(6)<>[] then 
    if ll(10)=='z' then error('zero crossing blocks cannot have states');end
    //continuous block with state
    nxblk=1+nxblk;status=[status;1];
  elseif ll(7)==[]&ll(6)==[]&ll(10)<>'z' then 
    // block without state 
    ncxblk=ncxblk+1;status=[status;2];
  elseif ll(7)<>[] then 
    //discrete state block 
     status=[status;3];ndblk=ndblk+1
  elseif ll(10)=='z' then 
    //zero crossing block
    ndcblk=ndcblk+1;status=[status;5];
  end
end
ncblk=nxblk+ncxblk;
nb=ncblk+ndblk;
nblk=nb+ndcblk

if nxblk==0 & ndcblk<>0 then
  x_message(['For using treshold, you need to have a continuous system with state in your diagram.';'You can include DUMMY CLSS block (linear palette) in your diagram.']);
  state=[];sim=[];cor=[];corinv=[];ok=%f
  return
end
[junk,ind]=sort(-status)
bltmp=list()

for i=1:nblk
  bltmp(i)=bllst(ind(i))
  k1=corinv(ind(i))
  if size(k1,'*')==1 then
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

bllst=bltmp;bltmp=null()

[junk,indinv]=sort(-ind)
connectmat(:,1)=indinv(connectmat(:,1))
connectmat(:,3)=indinv(connectmat(:,3))
clkconnect(:,1)=indinv(clkconnect(:,1))
clkconnect(:,3)=indinv(clkconnect(:,3))

//form sizes and parameter vectors
inpbsz=[];outbsz=[];clkbsz=[];clibsz=[];
cstbsz=[];dstbsz=[];rpbsz=[];ipbsz=[];xc0=[];xd0=[];rpar=[];ipar=[];
dep_ut=[];
funs=list()

initexe=[]
for i=1:length(bllst)
  ll=bllst(i)
  funs(i)=ll(1);
  inpbsz=[inpbsz;ll(2)]
  outbsz=[outbsz;ll(3)]
  clibsz=[clibsz;ll(4)]
  clkbsz=[clkbsz;ll(5)]
  xc0=[xc0;ll(6)]
  cstbsz=[cstbsz;prod(size(ll(6)))]
  xd0=[xd0;ll(7)]
  dstbsz=[dstbsz;prod(size(ll(7)))]
  if type(ll(8))==1 then
    rpar=[rpar;ll(8)]
    rpbsz=[rpbsz;prod(size(ll(8)))]
  else
    rpbsz=[rpbsz;0]
  end
  if type(ll(9))==1 then 
    ipar=[ipar;ll(9)]
    ipbsz=[ipbsz;prod(size(ll(9)))]
  else
    ipbsz=[ipbsz;0]
  end


  dep_ut=[dep_ut;ll(12)];
  //
  if ll(5)<>0 then  
    ll11=ll(11)
    if type(ll11)==4 then
      //this is for backward compatibility
      prt=find(ll11)
      nprt=prod(size(prt))
      initexe=[initexe;[i*ones(nprt,1),matrix(prt,nprt,1),zeros(nprt,1)]]
    else
      prt=find(ll11>=zeros(ll11))
      nprt=prod(size(prt))
      initexe=[initexe;[i*ones(nprt,1),matrix(prt,nprt,1),matrix(ll11(prt),nprt,1)]];
    end
  end
end
// order initial firing events in chronological order.
timevec=initexe(:,3)
[timevec,indtime]=sort(-timevec)
initexe=initexe(indtime,:)
timevec=[]

//Compute pointers from sizes 
UN=poly(1,'z','c');ZM1=poly(1,'z')
inpptr=rtitr(UN,ZM1,inpbsz')'+1
outptr=rtitr(UN,ZM1,outbsz')'+1
clkptr=rtitr(UN,ZM1,clkbsz')'+1
cliptr=rtitr(UN,ZM1,clibsz')'+1
cstptr=rtitr(UN,ZM1,cstbsz')'+1
dstptr=rtitr(UN,ZM1,dstbsz')'+1
rpptr=rtitr(UN,ZM1,rpbsz')'+1
ipptr=rtitr(UN,ZM1,ipbsz')'+1

//construct connect vec
connectvec=[outptr(connectmat(:,1))+connectmat(:,2)-1 ,..
            inpptr(connectmat(:,3))+connectmat(:,4)-1]

//initialize agenda
ninit=prod(size(initexe(:,1)))
if modsim=1 then
  pointf=0 //this is an indicator that modsim 1 is to be used
  pointi=0
  nevts=clkptr(nblk+1)-1 //time events agenda size
  tevts=0*ones(nevts,1)
  tevts(clkptr(initexe(:,1))+initexe(:,2)-1)=initexe(:,3)
  evtspt=-ones(nevts,1)

  if ninit>0 then 
    pointi=clkptr(initexe(1,1))+initexe(1,2)-1;
    evtspt(pointi)=0
  end
  if ninit>1 then
    evtspt(clkptr(initexe(1:ninit-1,1))+initexe(1:ninit-1,2)-1)=..
	clkptr(initexe(2:ninit,1))+initexe(2:ninit,2)-1;
    evtspt(clkptr(initexe(ninit,1))+initexe(ninit,2)-1)=0;
  end
else
  pointi=1
  pointf=1+ninit
  nevts=10*max(pointf,clkptr(nblk+1)-1) //time events agenda size
  tevts=0*ones(nevts,1)
  evtspt=zeros(nevts,1)
  if ninit>0 then
    tevts(1:ninit)=initexe(:,3)
    evtspt(1:ninit)=clkptr(initexe(1:ninit,1))+initexe(1:ninit,2)-1
  end
end
if ninit==0 & ndcblk==0 then
  x_message(['Warning';
             'Systems contains no discrete blocks';
	     'Simulation results except end point state will be lost'])
end
//form "connection matrix" in fact just a permutation stored in a vector

cmat=zeros([1:inpptr(nblk+1)-1])
[junk,ind]=sort(-connectvec(:,2))
cmat=connectvec(ind,1);


//
con=clkptr(clkconnect(:,1))+clkconnect(:,2)-1
[junk,ind]=sort(-con);con=-junk
clkconnect=clkconnect(ind,:)
execlk=clkconnect(:,[3 4]);
ordptr1=1;
con=[con;-1];
i0=1;
for i=1:prod(size(con))-1
  if con(i)<>con(i+1) then 
    i0=i0+1;
    ordptr1(i0)=i+1;
  end
end

// Set execution scheduling tables 
[ordptr2,ordclk,cord,iord,oord,zord,critev,ok]=scheduler(inpptr,outptr,..
    clkptr,execlk,ordptr1,cmat,ncblk,nxblk,nb,ndblk);

ordptr=[ordptr1,ordptr2];


//form scicos arguments
simtp=['scs','funs','stptr','inpptr','outptr','cmat','rpar','rpptr','ipar',..
    'ipptr','clkptr','ordptr','execlk','ordclk','cord','iord','ncblk',..
    'nxblk','ndblk','ndcblk','oord','zord','critev']

sim=tlist(simtp,funs,[cstptr;dstptr(2:nblk+1,1)+cstptr(nblk+1)-1],..
          inpptr,outptr,..
          cmat,rpar,rpptr,ipar,ipptr,clkptr,..
          ordptr,execlk,ordclk,cord,iord,ncblk,nxblk,ndblk,ndcblk,..
	  oord,zord,critev);
statetp=['xcs','x0','tevts','evtspt','pointi','pointf']
state=tlist(statetp,[xc0;xd0],tevts,evtspt,pointi,pointf);


function [ordptr2,ordclk,cord,iord,oord,zord,critev,ok]=..
    scheduler(inpptr,outptr,clkptr,execlk,ordptr1,cmat,ncblk,nxblk,nb,ndblk);

IN=zeros(1:inpptr(nblk+1)-1)
 
ind=1
flo=1
for k=2:nblk+1
  while inpptr(k)<>ind, IN(ind)=flo,ind=ind+1,end
  flo=flo+1
end
[k,cmatp]=sort(-cmat)
t_var_blk=find(dep_ut(:,2));


vec=-ones(1,nb)
vec(1:nxblk)=0*ones(1,nxblk)  // continuous system with state
vec(t_var_blk)=0*t_var_blk // time varying blocks
[cord,ok]=ctree(vec,IN,dep_ut)

if ~ok then 
  x_message('Algebraic loop detected; cannot be compiled.');
  ordptr2=[],ordclk=[],cord=[],iord=[],oord=[],zord=[],critev=[]
  return,
end

vec=0*vec;
[iord,ok]=ctree(vec,IN,dep_ut)

if ~ok then 
    x_message('Algebraic loop detected; cannot be compiled.');
  ordptr2=[],ordclk=[],cord=[],iord=[],oord=[],zord=[],critev=[]
  return,
end

ordclk=[]
ordptr2=ordptr1
for o=1:clkptr(nblk+1)-1
  vec=-ones(1,nb);
  vec(execlk(ordptr1(o):ordptr1(o+1)-1,1)')=..
      zeros(execlk(ordptr1(o):ordptr1(o+1)-1))';
  vec(t_var_blk)=0*t_var_blk
  [r,ok]=ctree(vec,IN,dep_ut)

  if ~ok then 
    x_message('Algebraic loop detected; cannot be compiled.');
    ordptr2=[],ordclk=[],cord=[],iord=[],oord=[],zord=[],critev=[]
    return,
  end
  ordptr2(1+o)=prod(size(r))+ordptr2(o)
  ordclk=[ordclk;r(:)]
end

zord=cord
oord=cord
n=prod(size(cord))
for iii=n:-1:1
  i=cord(iii)
  fl=%f
  fz=%f
  for k=outptr(i):outptr(i+1)-1
    ii=IN(cmatp(k))
    //ii est un block affecte par changement de sortie du 
    //i-eme block de oord
    if ii<=nxblk | ii>nb then fz=%t;end
    if ii<=nxblk then fl=%t;end
    if fl&fz then break,end
    //si ii est un block integre (continu avec etat) 
    //il faut garder i
    for l=iii+1:n
      //si ii est un block qu'on a decide de garder 
      //il faut garder i
      if ii=zord(l) then fz=%t; end
      if ii=oord(l) then fl=%t; end
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
  vec=-ones(1,nb);
  vec(execlk(ordptr1(o):ordptr1(o+1)-1,1)')=..
      zeros(execlk(ordptr1(o):ordptr1(o+1)-1))';
  [r,ok]=ctree(vec,IN,dep_ut)

  if ~ok then 
    x_message('Algebraic loop detected; cannot be compiled.');
    ordptr2=[],ordclk=[],cord=[],iord=[],oord=[],zord=[],critev=[]
    return,
  end
  ordptr3(1+o)=prod(size(r))+ordptr3(o)
  ordclk_fut=[ordclk_fut;r(:)]
end

// 1: important; 0:non
n=clkptr(nblk+1)-1 //nb d'evenement
//a priori tous les evenemets sont non-importants

critev=zeros(n,1)
for i=1:n
  fl=%f
  for j=ordptr3(i):ordptr3(i+1)-1      
    jj= ordclk_fut(j)  //block excite par evenement i
    for k=outptr(jj):outptr(jj+1)-1 //les sorties du  "    "
      ii=IN(cmatp(k))   //block excite par block excite par evenement i
      //si il est integre, i est important
      if ii <= nxblk then fl=%t;break; end
    end
    if fl then break;end
  end
  if fl then critev(i,1)=1; end
end



function [ord,ok]=tree(vec,IN,dep_ut)
//compute blocks execution tree
//This function is not used anymore, it is replaced by ctree.
ok=%t
for j=1:nb+2
  fini=%t
  for i=1:nb
    if vec(i)==j-1 then 
      if j==nb+2 then 
	x_message('algebraic loop detected');ok=%f;ord=[];return;
      end
      k=outptr(i):outptr(i+1)-1;
      kk=[];
      for l=k
	ii=IN(cmatp(l));
	if dep_ut(ii,1) then
	 fini=%f;
	 kk=[kk ii];
	end
      end
      vec(kk)=j*ones(kk) ;   
    end
  end
  if fini then break;end
end
[k,ord]=sort(-vec);
ord(find(k==1))=[];
tokill=[]
for i=1:prod(size(ord))
  l=ord(i)
  if outptr(l+1)-outptr(l)==0 then tokill=[tokill i];end
end
ord(tokill)=[]

function [ord,ok]=ctree(vec,in,depu)
//sctree(nb,vec,in,depu,outptr,cmat,ord,nord,ok,kk)
jj=find(depu);dd=zeros(depu);dd(jj)=ones(jj)';depu=dd;
nb=prod(size(vec));kk=zeros(vec);
[ord,ok]=sctree(vec,in,depu,outptr,cmatp);
ok=ok==1;
ord=ord';

