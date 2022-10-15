function  [blklst,cmat,ccmat,cor,corinv,ok]=c_pass1(x,ksup)
//%Purpose
// Determine one level blocks and connections matrix
//%Parameters
// x      :   scicos data structure
// ksup   :   
// blklst : a list containing the "model" information structure for each block 
//
// cmat   : nx4 matrix. Each row contains, in order, the block
//             number and the port number of an outgoing scicopath,
//             and the block number and the port number of the target
//             ingoing scicopath.
//
// ccmat  : same as cmat but for clock scico-paths.
//!
[lhs,rhs]=argn(0);
sup_tab=[]
if rhs<=1 then ksup=0;end
if ksup==0 then   // main scheme
  MaxBlock=countblocks(x);
  nsblk=0; // numer of special blocks (clock split,clock sum,super_blocks)
  sup_tab=[]
end

//initialize outputs
blklst=list(),nb=0,cor=list(),corinv=list(),cmat=[],ccmat=[];ok=%t
n=size(x)
for k=1:n, cor(k)=0;end

clksplit=[] // clock split table for this level
clksum=[] // clock sum table for this level

sel=2:n
for k=sel
  o=x(k)
  if o(1)=='Block' then
    model=o(3)
    sel(k-1)=0
    if o(5)=='CLKSPLIT_f' then
      nsblk=nsblk+1
      cor(k)=MaxBlock+nsblk
      clksplit=[clksplit,MaxBlock+nsblk]
    elseif o(5)=='CLKSOM_f' then
      nsblk=nsblk+1
      cor(k)=MaxBlock+nsblk
      clksum=[clksum,MaxBlock+nsblk] 
    elseif o(5)=='SOM_f' then
      [graphics,model]=o(2:3)
      sgn=model(7)
      if ~and(graphics(5)) then 
	//all input ports are not connected,renumber connected ones 
	//and modify signs 
	connected=get_connected(x,k)
	count=0;cnct=[]
	for kk=1:prod(size(connected))
	  kc=connected(kk)
	  lk=x(kc);to=lk(9)
	  if to(1)==k then  // an input link
	    cnct=[cnct to(2)]
	    count=count+1
	    to(2)=count;lk(9)=to;x(kc)=lk;
	  end
	end
	model(2)=prod(size(cnct));model(7)=sgn(cnct);o(3)=model
      end
      if ~and(graphics(6)) then 
	x_message('A summation block has unconnected output port');
	ok=%f;return;
      end
      //
      nb=nb+1
      corinv(nb)=k
      blklst(nb)=o(3)
      cor(k)=nb
    elseif model(1)=='super'|model(1)=='csuper' then
      nsblk=nsblk+1
      sup_tab=[sup_tab MaxBlock+nsblk]
      [graphics,model]=o(2:3)
      // check connections
      if ~and(graphics(5))|~and(graphics(6))|..
	  ~and(graphics(7))|~and(graphics(8)) then
        x_message(['A block has unconnected ports';'Please check'])
	ok=%f
	return  
      end

      connected=get_connected(x,k)
      for kk=1:prod(size(connected))
	kc=connected(kk);
	lk=x(kc);from=lk(8);to=lk(9);
	if to(1)==k then  // an input link
	  to(1)=MaxBlock+nsblk;
	  lk(9)=to;x(kc)=lk;
	end
	if from(1)==k then  // an output link
	  from(1)=MaxBlock+nsblk;
	  lk(8)=from;x(kc)=lk;
	end
      end
      [blklsts,cmats,ccmats,cors,corinvs,ok]=c_pass1(model(8),MaxBlock+nsblk)
      if ~ok then return,end
      nbs=size(blklsts)
      for kk=1:nbs
	blklst(nb+kk)=blklsts(kk)
	corinv(nb+kk)=[k,corinvs(kk)]
      end
      cors=shiftcors(cors,nb)
      if cmats<>[] then
	f=find(cmats(:,2)>0)
	if f<>[] then cmats(f,1)=cmats(f,1)+nb,end
	f=find(cmats(:,4)>0)
	if f<>[] then cmats(f,3)=cmats(f,3)+nb,end
	cmat=[cmat;cmats]
      end
      if ccmats<>[] then
	f=find(ccmats(:,2)>0)
	if f<>[] then ccmats(f,1)=ccmats(f,1)+nb,end
	f=find(ccmats(:,4)>0)
	if f<>[] then ccmats(f,3)=ccmats(f,3)+nb,end
	ccmat=[ccmat;ccmats]
      end
      cor(k)=cors
      nb=nb+nbs
    elseif o(5)=='IN_f' then
      if ksup==0 then 
	x_message('Input port must be only used in a Super Block')
	ok=%f
	return 
      end
      connected=get_connected(x,k)
      if connected==[] then
	x_message(['A Super Block Input port is unconnected';'Please check'])
	ok=%f
	return 
      end
      lk=x(connected)
      model=o(3)
      //ipar=model(9) contient le numero de port d'entree affecte 
      //a ce bloc
      from=[-ksup -model(9)]
      lk(8)=from;x(connected)=lk
    elseif o(5)=='OUT_f' then 
      if ksup==0 then 
	x_message('Output port must be only used in a Super Block')
	ok=%f
	return 
      end
      connected=get_connected(x,k)
      if connected==[] then
	x_message(['A Super Block Output port is unconnected';'Please check'])
	ok=%f
	return 
      end
      lk=x(connected)
      model=o(3)
      //ipar=model(9) contient le numero de port de sortie affecte 
      //a ce bloc
      to=[-ksup -model(9)]
      lk(9)=to;x(connected)=lk
    elseif o(5)=='CLKIN_f' then
      if ksup==0 then 
	x_message('Clock Input port must be only used in a Super Block')
	ok=%f
	return 
      end
      connected=get_connected(x,k)
      if connected==[] then
	x_message(['A Super Block Clock Input port is unconnected';
	    'Please check'])
	ok=%f
	return 
      end
      lk=x(connected)
      //ipar=model(9) contient le numero de port d'entree affecte 
      //a ce bloc
      from=[-ksup -model(9)]
      lk(8)=from;x(connected)=lk
    elseif o(5)=='CLKOUT_f' then 
      if ksup==0 then 
	x_message('Clock Output port must be only used in a Super Block')
	ok=%f
	return 
      end
      connected=get_connected(x,k)
      if connected==[] then
	x_message(['A Super Block Clock Output port is unconnected';
	    'Please check'])
	ok=%f
	return 
      end
      lk=x(connected)
      model=o(3)
      //ipar=model(9) contient le numero de port de sortie affecte 
      //a ce bloc
      to=[-ksup -model(9)]
      lk(9)=to;x(connected)=lk 
    else
      graphics=o(2)
      // check connections
      if ~and(graphics(5))|~and(graphics(6))|..
	  ~and(graphics(7))|~and(graphics(8)) then
           x_message(['A block has unconnected ports';
	       'Please check'])
	   ok=%f
	   return  
      end
      nb=nb+1
      corinv(nb)=k
      model=o(3)
      if model(1)=='scifunc' then
	model(1)=genmac(model(9))
      end
      blklst(nb)=model
      cor(k)=nb
    end
  elseif o(1)=='Deleted'|o(1)=='Text' then
    sel(k-1)=0
  end
end
if ksup==0&nb==0 then
  x_message('Empty diagram')
  ok=%f
  return
end

//loop on links
sel(find(sel==0))=[]
for k=sel
  o=x(k);
  [ct,from,to]=o(7:9);
  if from(2)<0& from(1)<0then 
    //fil issu d'un port d'entree d'un super block
    //on remet la valeur de from(1) au numero du superbloc dans x
    from(1)=-from(1)
  elseif or(from(1)==sup_tab) then //fil provenant d'un super block
//    from(2)=-from(2)
  else
    from(1)=cor(from(1)),
  end
  if to(2)<0&to(1)<0 then //fil connecte a un port de sortie d'un super block
      to(1)=-to(1)
  elseif or(to(1)==sup_tab)  then //fil connecte a un super block
//    to(2)=-to(2)
  else 
    to(1)=cor(to(1)),
  end
  if ct(2)==1 then 
    cmat=[cmat;[from(1),from(2),to(1),to(2)]];
  else
    ccmat=[ccmat;[from(1),from(2),to(1),to(2)]];
  end
end

// strip super block input connection
//==========================================

to_kill=[]

for k=sup_tab //loop on super blocks
  fn=find(cmat(:,1)==k); //super block inputs
  if fn<>[] then
    ni=max(abs(cmat(fn,2))) //number of super block input ports
    for kp=1:ni //loop on ports
      ip=find(cmat(fn,2)==-kp);fnp=fn(ip),
      to=[cmat(fnp(1),1), -cmat(fnp(1),2)]
      c=find(abs(cmat(:,3:4)-ones(cmat(:,1))*to)*[1;1]==0) //connected blocks
      if c<>[] then 
	cmat(c,3:4)=ones(c')*cmat(fnp(1),3:4);to_kill=[to_kill;fnp(1)],
      end
    end
  end
end
cmat(to_kill,:)=[];to_kill=[]
[nc,nw]=size(cmat)
// strip super block output  clock connection
//===========================================
for k=sup_tab //loop on super blocks
  fn=find(cmat(:,3)==k); //super block outputs
  if fn<>[] then
    no=max(abs(cmat(fn,4))); //number of super block output ports
    for kp=1:no //loop on ports
      ip=find(cmat(fn,4)==-kp);fnp=fn(ip);
      to=[cmat(fnp(1),3), -cmat(fnp(1),4)]
      c=find(abs(cmat(:,1:2)-ones(cmat(:,1))*to)*[1;1]==0) ;//connected blocks
      if c<>[] then
	cmat(c,1:2)=ones(c')*cmat(fnp(1),1:2);to_kill=[to_kill;fnp(1)];
      end
    end
  end
end
cmat(to_kill,:)=[]


[nc,nw]=size(ccmat)
if nc==0 then return,end
//strip clksplit and clksum blocks and change corresponding links 
//===============================================================
// strip clksplit
to_kill=[]
for ksplit=clksplit
  kfrom=find(ccmat(:,1)==ksplit); //links coming from the clksplit
  kto=find(ccmat(:,3)==ksplit); // link going to the clksplit
  if ~or(to_kill==kto) then to_kill=[to_kill,kto];end
  ccmat(kfrom,1:2)=ccmat(kto*ones(kfrom'),1:2);
end  

ccmat(to_kill,:)=[];to_kill=[]
// strip clksum
[nc,nw]=size(ccmat)
if nc==0 then return,end

for ksum=clksum
  //link(s) coming from the clksum. 
  //Due to previous substitutions, many links may go out of the clksum
  kfrom=find(ccmat(:,1)==ksum); // links coming from the clksum
  kto=find(ccmat(:,3)==ksum); // links going to the clksum
  if ~or(to_kill==kfrom(1)) then to_kill=[to_kill,kfrom(1)];end
  ccmat(kto,3:4)=ccmat(kfrom(1)*ones(kto'),3:4);
  kfrom(1)=[];
  nto=size(kto,'c');
  //add new links
  for k=kfrom
    if ~or(to_kill==k(1)) then to_kill=[to_kill,k(1)];end
    nc=size(ccmat,'r');
    ccmat=[ccmat;ccmat(kto,:)];
    ccmat(nc+1:nc+nto,3:4)=ccmat(k*ones(kto'),3:4);
  end
  ccmat(to_kill,:)=[];to_kill=[]
  [nc,nw]=size(ccmat)
end  

if nc==0 then return,end
// strip super block input  clock connection
//==========================================

to_kill=[]

for k=sup_tab //loop on super blocks
  fn=find(ccmat(:,1)==k); //super block inputs
  if fn<>[] then
    ni=max(abs(ccmat(fn,2))) //number of super block input ports
    for kp=1:ni //loop on ports
      ip=find(ccmat(fn,2)==-kp);fnp=fn(ip),
      to=[ccmat(fnp(1),1), -ccmat(fnp(1),2)]
      c=find(abs(ccmat(:,3:4)-ones(ccmat(:,1))*to)*[1;1]==0) //connected blocks
      if c<>[] then 
	ccmat(c,3:4)=ones(c')*ccmat(fnp(1),3:4);to_kill=[to_kill;fnp(1)],
	// handle clock sum outputs (many links issued from a single port)
	for ii=2:size(fnp,'*')
	  ccmat=[ccmat;[ccmat(c,1:2),ones(c')*ccmat(fnp(ii),3:4)] ]
	  to_kill=[to_kill;fnp(ii)],
	end
      end
    end
  end
end
ccmat(to_kill,:)=[];to_kill=[]
[nc,nw]=size(ccmat)
if nc==0 then return,end
// strip super block output  clock connection
//===========================================
for k=sup_tab //loop on super blocks
  fn=find(ccmat(:,3)==k); //super block outputs
  if fn<>[] then
    no=max(abs(ccmat(fn,4))); //number of super block output ports
    for kp=1:no //loop on ports
      ip=find(ccmat(fn,4)==-kp);fnp=fn(ip);
      to=[ccmat(fnp(1),3), -ccmat(fnp(1),4)]
      c=find(abs(ccmat(:,1:2)-ones(ccmat(:,1))*to)*[1;1]==0) ;//connected blocks
      if c<>[] then
	ccmat(c,1:2)=ones(c')*ccmat(fnp(1),1:2);to_kill=[to_kill;fnp(1)];
	// handle clock sum outputs (many links issued from a single port)
	for ii=2:size(fnp,'*')
	  ccmat=[ccmat;[ones(c')*ccmat(fnp(ii),1:2),ccmat(c,3:4)] ];
	  to_kill=[to_kill;fnp(ii)];
	end
      end
    end
  end
end
ccmat(to_kill,:)=[]
if ksup==0 then 
  if or(ccmat(:,1)>MaxBlock)|or(ccmat(:,3)>MaxBlock) then
    x_message(['Compilation problem: may be event loop';
	'if no event loop, please report'])
    ok=%f
    return
  end
end


function n=countblocks(x)
// count number of blocks used in the scicos data structure x

nx=size(x)
n=0
for o=x
  if o(1)=='Block' then
    model=o(3)
    if model(1)=='super'|model(1)=='csuper' then
      n=n+countblocks(model(8))
    else
      n=n+1
    end
  else
    n=n+1
  end
end

function cors=shiftcors(cors,ns)
n=size(cors)
for k=1:n
  if type(cors(k))==15 then
    cors(k)=shiftcors(cors(k),ns)
  else
    cors(k)=cors(k)+ns
  end
end

function mac=genmac(tt)
[txt1,txt2,txt3]=tt(1:3)
mac=null()
deff('[%_1,%_2]=mac(t,x,z,u,n_evi,%_flag,rpar,%_ipar)',..
    ['%_1=[];%_2=[];';
    'select %_flag';
    'case 1 then';
    txt1
    '%_1=y';
    'case 2 then';
    txt2
    '%_1=xd';
    '%_2=zp';
    'case 3 then';
    txt3
    '%_1=t_evo ';
    'case 4 then';
    '%_1=x'
    '%_2=z'
    'end'])
comp(mac)
