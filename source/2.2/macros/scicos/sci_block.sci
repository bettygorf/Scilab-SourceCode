function [x,y,typ]=sci_block(job,arg1,arg2)
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
//  model=list(eqns,#input,#output,#clk_input,#clk_output,state,dstate..
//             rpar,ipar,typ,firing,deps)
//          eqns        - function name (in string form if fortran routine)
//          #input      - number of inputs
//          #output     - number of ouputs
//          #clk_input  - number of clock inputs
//          #clk_output - number of clock outputs
//          state       - vector (column) of initial condition
//          dstate      - vector (column) of initial discrete condition
//          rpar        - vector (column) of real parameters
//          ipar        - vector (column) of integer parameters
//          typ         - string: 'z' if zero-crossing.
//          firing      - vector of initial firing times
//          deps        - [timedep udep] 
//                        timedep boolean, mark if system has time varying 
//                                output 
//                        udep boolean, mark if system has direct feedthrough
//
x=[];y=[];typ=[];
select job
case 'plot' then
  standard_draw(arg1)
  graphics=arg1(2);[orig,sz]=graphics(1:2)
  xstringb(orig(1),orig(2),'Sci_Block',sz(1),sz(2),'fill')
case 'getinputs' then
  [x,y,typ]=standard_inputs(arg1)
case 'getoutputs' then
  [x,y,typ]=standard_outputs(arg1)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  model=arg1(3);graphics=arg1(2);label=graphics(4)
  x=arg1
  if model(1)==' ' then
    [ok,mac]=getvalue('Set Scilab Block',..
	['Scilab function name'],list('str',1),' ')
    mac=stripblanks(mac);
    if exists(mac)==0 then 
      x_message(['This function is not currently available in';..
	  'Scilab environment. Leave Scicos and getf the function'])
      ok=%f
    end
    if ~ok then return,end
    model(1)=mac
    execstr('out='+mac+'(model,'' '',[],[],[],-1)')
    model=out(1)
    [orig,sz]=graphics(1:2)
    x1=standard_define([2 2],model)
    graphics=x1(2);graphics(1)=orig;graphics(2)=sz;
    x(2)=graphics
  end
  mac=model(1)
  if type(mac)==10 then
    execstr('out='+mac+'(model,label,[],[],[],-2)')
  else
    execstr('out=mac(model,label,[],[],[],-2)')
  end
  if size(out)<>0 then
    model=out(1);label=out(2)
    graphics(4)=label
    x(2)=graphics;x(3)=model;
  end
case 'define' then
  [lhs,rhs]=argn(0)
  if rhs>=2 then //sci_block with a defined macro
    model=list(arg1)
    mac=arg1
    execstr('out=mac(model,'' '',[],[],[],-1)')
    model=out(1);
    x=standard_define([2 2],model,out(2))
  else //sci_block with no defined macro
    model=list(' ',0,0,0,0,[],[],[],[],%f,[%f %f])
    x=standard_define([3 2],model)
  end
end
