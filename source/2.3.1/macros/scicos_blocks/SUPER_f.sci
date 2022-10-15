function [x,y,typ]=SUPER_f(job,arg1,arg2)
x=[];y=[],typ=[]
select job
case 'plot' then
  standard_draw(arg1)
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
    [x,newparameters,needcompile]=scicos(model(8))
    model(8)=x
    nin=0;nout=0;nclkin=0;nclkout=0;
    in=[],out=[],cin=[],cout=[]
    inp=[],outp=[],cinp=[],coutp=[]
    for k=2:size(x)
      o=x(k)
      if o(1)=='Block' then
	modelb=o(3)
	select o(5)
	case 'IN_f' then
	  nin=nin+1
	  inp=[inp modelb(9)]
	  in=[in;modelb(3)]
	case 'OUT_f' then
	  nout=nout+1
	  outp=[outp modelb(9)]
	  out=[out;modelb(2)]
	case 'CLKIN_f' then
	  nclkin=nclkin+1
	  cinp=[cinp modelb(9)]
	  cin=[cin;modelb(5)]
 	case 'CLKINV_f' then
	  nclkin=nclkin+1
	  cinp=[cinp modelb(9)]
	  cin=[cin;modelb(5)]         
	case 'CLKOUT_f' then
	  nclkout=nclkout+1
	  coutp=[coutp modelb(9)]
	  cout=[cout;modelb(4)]
	case 'CLKOUTV_f' then
	  nclkout=nclkout+1
	  coutp=[coutp modelb(9)]
	  cout=[cout;modelb(4)]          
	end
      end
    end
    ok=%t
    mess=[]
    if nin>0 then
      [inp,k]=sort(-inp)
      if ~and(inp==-(1:nin)) then
	mess=[mess;
	    'Super_block input ports must be numbered';
	    'from 1 to '+string(nin);' ']
	ok=%f
      end
      in=in(k)
    end
    if nout>0 then
      [outp,k]=sort(-outp)
      if ~and(outp==-(1:nout)) then
	mess=[mess;
	    'Super_block output ports must be numbered';
	    'from 1 to '+string(nout);' ']
	ok=%f
      end
      out=out(k)
    end


    if nclkin>0 then
      [cinp,k]=sort(-cinp)
      if ~and(cinp==-(1:nclkin)) then
	mess=[mess;
	    'Super_block event input ports must be numbered';
	    'from 1 to '+string(nclkin);' ']
	ok=%f
      end
      cin=cin(k)
    end
    if nclkout>0 then
      [coutp,k]=sort(-coutp)
      if ~and(coutp==-(1:nclkout)) then
	mess=[mess;
	    'Super_block event output ports must be numbered';
	    'from 1 to '+string(nclkout);' ']
	ok=%f
      end
      cout=cout(k)
    end
    if ok then
      [model,graphics,ok]=check_io(model,graphics,in,out,cin,cout)
    else
      message(mess)
    end
    if ok then
      model(8)=x
      model(11)=[] //compatibility
      x=arg1;x(3)=model;x(2)=graphics;
      y=needcompile
      typ=newparameters
      break
    end
  end
case 'define' then
  model=list('super',1,1,[],[],[],' ',..
      list(list([600,450,0,0],'Super Block',[],[],[])),[],'h',[],[%f %f])
  gr_i=['thick=xget(''thickness'');xset(''thickness'',2);';
    'xx=orig(1)+      [2 4 4]*(sz(1)/7);';
    'yy=orig(2)+sz(2)-[2 2 6]*(sz(2)/10);';
    'xrects([xx;yy;[sz(1)/7;sz(2)/5]*ones(1,3)]);';
    'xx=orig(1)+      [1 2 3 4 5 6 3.5 3.5 3.5 4 5 5.5 5.5 5.5]*sz(1)/7;';
    'yy=orig(2)+sz(2)-[3 3 3 3 3 3 3   7   7   7 7 7   7   3  ]*sz(2)/10;';
    'xsegs(xx,yy,0);';
    'xset(''thickness'',thick)']
  x=standard_define([2 2],model,[],gr_i)
end




