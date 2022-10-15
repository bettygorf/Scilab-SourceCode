function wpar=do_setup(wpar)
wd=wpar(1);w=wd(1);h=wd(2);
nm=wpar(2)
tolerances=wpar(3);
if tolerances==[]|tf==[]|sim_mode==[] then //super block
  while %t do
    [ok,nm,h,w]=getvalue('Set parameters',[
	'Super block name';
	'Window height';
	'Window width'],list('str',1,'vec',1,'vec',1),[nm;string([h;w])])
    if ~ok then break,end
    if or([h,w]<=0) then
      x_message('Parameter must all be positive')
    else
      drawtitle(wpar)
      wpar(1)=[w h]
      wpar(2)=nm
      drawtitle(wpar)
      break
    end
  end 
else
  tf=wpar(4)
  sim_mode=wpar(5)
  atol=tolerances(1);rtol=tolerances(2);ttol=tolerances(3)
  while %t do
    [ok,h,w,tf,atol,rtol,ttol,sim_mode]=getvalue('Set parameters',[
	'Window height';
	'Window width';
	'Final integration time';
	'Integrator absolute tolerance';
	'Integrator relative tolerance';
	'Tolerance on time'
	'Simulation mode'],..
	    list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1),..
	    [string([h;w;tf;atol;rtol;ttol;sim_mode])])
    if ~ok then break,end
    if or([h,w,tf,atol,rtol,ttol,sim_mode]<=0) then
      x_message('Parameter must  be positive')
    elseif sim_mode<>1&sim_mode<>2 then
      x_message('Simulation mode must be equal to 1 or 2')
    else
      wpar(1)=[w h]
      wpar(3)=[atol;rtol;ttol]
      wpar(4)=tf
      wpar(5)=sim_mode
      break
    end
  end
end
