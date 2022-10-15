function wpar=do_setup(wpar)
// set integration parameters
tolerances=wpar(3);
tf=wpar(4)
atol=tolerances(1);rtol=tolerances(2);ttol=tolerances(3);deltat=tolerances(4)
while %t do
  [ok,tf,atol,rtol,ttol,deltat]=getvalue('Set parameters',[
      'Final integration time';
      'Integrator absolute tolerance';
      'Integrator relative tolerance';
      'Tolerance on time'
      'deltat'],..
	  list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1),..
	  [string([tf;atol;rtol;ttol;deltat])])
  if ~ok then break,end
  if or([tf,atol,rtol,ttol,deltat]<=0) then
    message('Parameter must  be positive')
  else
    wpar(3)=[atol;rtol;ttol;deltat]
    wpar(4)=tf
    break
  end
end






