function [x,y,typ]=scifunc_block(job,arg1,arg2)
//%Description
// job=='plot' :      block drawing
//                    arg1 is block data structure
//                    arg2 :unused
// job=='getinputs' : return position and type of inputs ports
//                    arg1 is block data structure
//                    x  : x coordinates of ports
//                    x  : y coordinates of ports
//                    typ: type of ports
// job=='getoutputs' : return position and type of outputs ports
//                    arg1 is block data structure
//                    x  : x coordinates of ports
//                    x  : y coordinates of ports
//                    typ: type of ports
// job=='getorigin'  : return block origin coordinates
//                    x  : x coordinates of block origin
//                    x  : y coordinates of block origin
// job=='set'        : block parameters acquisition
//                    arg1 is block data structure
//                    x is returned block data structure 
// job=='define'     : corresponding block data structure initialisation
//                    arg1: name of block parameters acquisition macro 
//                    x   : block data structure
//%Block data-structure definition
// bl=list('Block',graphics,model,init,'standard_block')
//  graphics=list([xo,yo],[l,h],orient,label)
//          xo          - x coordinate of block origin
//          yo          - y coordinate of block origin
//          l           - block width
//          h           - block height
//          orient      - boolean, specifies if block is tilded
//          label       - string block label
//  model=list(eqns,#input,#output,#clk_input,#clk_output,state,..
//             rpar,ipar,typ [,firing])
//          eqns        - function name (in string form if fortran routine)
//          #input      - number of inputs
//          #output     - number of ouputs
//          #clk_input  - number of clock inputs
//          #clk_output - number of clock outputs
//          state       - vector (column) of initial condition
//          rpar        - vector (column) of real parameters
//          ipar        - vector (column) of integer parameters
//          typ         - string: 'c' if block is continuous, 'd' if discrete
//                        'z' if zero-crossing.
//          firing      - boolean initial clock firing if true
//
x=[];y=[];typ=[];
select job
case 'plot' then
  standard_draw(arg1)
  graphics=arg1(2);[orig,sz]=graphics(1:2)
  xstringb(orig(1),orig(2),'Scifunc',sz(1),sz(2),'fill')
case 'getinputs' then
  [x,y,typ]=standard_inputs(arg1)
case 'getoutputs' then
  [x,y,typ]=standard_outputs(arg1)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  model=arg1(3);graphics=arg1(2);label=graphics(4)
  x=arg1
  ni1=model(2);no1=model(3);nci1=model(4);nco1=model(5);x1=model(6);
  z1=model(7);auto1=model(11);type_1=model(10);
  tt=model(9),rpar=model(8)
  while %t do
    [ok,ni,no,nci,nco,xx,z,type_,rpar,auto0]=..
	getvalue('Set scifunc_block parameters',..
	  ['number of inputs';'number of outputs';
	  'number of input events';'number of output events';
	  'initial continuous state';'initial discrete state';
	  'System type (z if zero-crossing)';
	  'System parameters vector';
	  'initial firing (<0 for no firing)'],..
	  list('vec',1,'vec',1,'vec',1,'vec',1,'vec',-1,'vec',-1,..
	'str',1,'vec',-1,'vec','x4'),..
	[sci2exp(ni1);sci2exp(no1);sci2exp(nci1);sci2exp(nco1);
	strcat(sci2exp(x1));strcat(sci2exp(z1));type_1;
	strcat(sci2exp(rpar));sci2exp(auto1)]);
    if ~ok then break,end
    xx=xx(:);z=z(:);rpar=rpar(:)
    nrp=prod(size(rpar))
    // create simulator 
    [ok,tt,dep_ut]=genfunc1(tt,ni,no,nci,nco,size(xx,1),size(z,1),nrp)
    if ~ok then break,end
    [model,graphics,ok]=check_io(model,graphics,ni,no,nci,nco)
    if ok then
      auto=auto0
      model(6)=xx
      model(7)=z
      model(8)=rpar
      model(9)=tt
      model(10)=type_
      model(11)=auto
      model(12)=dep_ut
      x(3)=model
      x(2)=graphics
      x_message('IMPORTANT: you have to Compile before Run')
      break
    end
  end
case 'define' then
  ipar=list(' ',' ',' ')
  model=list('scifunc',1,1,0,0,[],[],[],ipar,'c',[],[%t %t]);
  x=standard_define([2 2],model)
end
