function [x,y,typ]=SUPER_f(job,arg1,arg2)
x=[];y=[],typ=[]
select job
case 'plot' then
  standard_draw(arg1)
  graphics=arg1(2); [orig,sz]=graphics(1:2)
  thick=xget('thickness');xset('thickness',2)
  xx=orig(1)+      [2 4 4]*(sz(1)/7)
  yy=orig(2)+sz(2)-[2 2 6]*(sz(2)/10)
  xrects([xx;yy;[sz(1)/7;sz(2)/5]*ones(1,3)])
  xx=orig(1)+      [1 2 3 4 5 6 3.5 3.5 3.5 4 5 5.5 5.5 5.5]*sz(1)/7
  yy=orig(2)+sz(2)-[3 3 3 3 3 3 3   7   7   7 7 7   7   3  ]*sz(2)/10
  xsegs(xx,yy,0)   
  xset('thickness',thick)
case 'getinputs' then
  [x,y,typ]=standard_inputs(arg1)
case 'getoutputs' then
  [x,y,typ]=standard_outputs(arg1)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  graphics=arg1(2);label=graphics(4)
  model=arg1(3);
  x=model(8)
  while %t do
    [x,newparameters,needcompile]=scicos(model(8),'edit')
    model(8)=x
    nin=0;nout=0;clkin=0;clkout=0;
    in=[],out=[],cin=[],cout=[]
    for k=2:size(x)
      o=x(k)
      if o(1)=='Block' then
	modelb=o(3)
	select o(5)
	case 'IN_f' then
	  nin=nin+1
	  in=[in modelb(9)]
	case 'OUT_f' then
	  nout=nout+1
	  out=[out modelb(9)]
	case 'CLKIN_f' then
	  clkin=clkin+1
	  cin=[cin modelb(9)]
	case 'CLKOUT_f' then
	  clkout=clkout+1
	  cout=[cout modelb(9)]
	end
      end
    end
    ok=%t
    mess=[]
    if nin>0 then 
      if ~and(sort(in)==(nin:-1:1)),
	mess=[mess;
	    'Super_block input ports must be numbered';
	    'from 1 to '+string(nin);' ']
	ok=%f
      end
    end
    if nout>0 then 
      if ~and(sort(out)==(nout:-1:1)),
	mess=[mess;
	    'Super_block output ports must be numbered';
	    'from 1 to '+string(nout);' ']
	ok=%f
      end
    end
    
    if clkin>0 then 
      if ~and(sort(cin)==(clkin:-1:1)),
	mess=[mess;
	    'Super_block event input ports must be numbered';
	    'from 1 to '+string(clkin);' ']
	ok=%f
      end
    end
    if clkout>0 then 
      if ~and(sort(cout)==(clkout:-1:1)),
	mess=[mess;
	    'Super_block event output ports must be numbered';
	    'from 1 to '+string(clkout);' ']
	ok=%f
      end
    end
    if ok then
      [model,graphics,ok]=check_io(model,graphics,nin,nout,clkin,clkout)
    else
      x_message(mess)
    end
    if ok then
      model(8)=x
      x=arg1;x(3)=model;x(2)=graphics;
      y=needcompile
      typ=newparameters
      break
    end
  end
case 'define' then
  model=list('super',1,1,0,0,[],[],..
      list(list([600,400],'Super Block',[],[])),[],'h',%f,[%f %f])
  x=standard_define([2 2],model)
end

