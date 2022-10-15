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



