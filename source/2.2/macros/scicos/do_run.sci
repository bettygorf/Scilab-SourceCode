function [ok,tcur,state,sim,cor,corinv,needcompile,alreadyran,state0]=do_run(state0,state,tcur)

if needcompile then
  needstart=%t
  [state,sim,cor,corinv,ok]=do_compile(x)
  if ok then
    state0=state;
    newparameters=list()
    tcur=0 //temps courant de la simulation
    needcompile=%f
    alreadyran=%f
  else
    alreadyran=%f
    tcur=0
    state0=state
  end
end
if size(newparameters)<>0 then
  if alreadyran then
    select x_choose(['Continue';'Restart';'End'],'What do you want to do')
    case 0 then 
      ok=%f
    case 1 then //continue
      needstart=%f
      [state,sim]=modipar(newparameters,state,sim)
    case 2 then //restart
      needstart=%t
      [state0,sim]=modipar(newparameters,state0,sim)
    case 3 then //end
      errcatch(888,'continue')
      [state,t]=scicosim(state,tcur,tf,sim,'finish',tolerances)
      errcatch(-1)
      if iserror(888)==1 then
	errclear(888)
	x_message('End problem, see message in scilab window')
      end
      ok=%f
      needstart=%t
    end
  else
    [state0,sim]=modipar(newparameters,state0,sim)
    needstart=%t
  end
else
  if alreadyran then
    select x_choose(['Continue';'Restart';'End'],'What do you want to do')
    case 0 then 
      ok=%f
    case 1 then //continue
      needstart=%f
    case 2 then //restart
      needstart=%t 
    case 3 then //end
      errcatch(888,'continue')
      [state,t]=scicosim(state,tcur,tf,sim,'finish',tolerances)
      errcatch(-1)
      if iserror(888)==1 then
	errclear(888)
	x_message('End problem, see message in scilab window')
      end
      ok=%f
      needstart=%t
    end
  else
    needstart=%t 
  end
end

if ok then
  if needstart then //scicos initialisation
    tcur=0
    state=state0
    win=xget('window')
    xset('alufunction',3)
    wpar=x(1);tf=wpar(4);tolerances=wpar(3)
    errcatch(888,'continue')
    [state,t]=scicosim(state,tcur,tf,sim,'start',tolerances)
    errcatch(-1)
    if iserror(888)==1 then
      errclear(888)
      x_message('Initialisation problem, see message in scilab window')
      ok=%f
    end
    xset('window',win);
    xset('alufunction',6)
  end
  // simulation
  xset('alufunction',3)
  wpar=x(1);tf=wpar(4);tolerances=wpar(3)
  setmenu(curwin,'stop')
  timer()
  errcatch(888,'continue')
  [state,t]=scicosim(state,tcur,tf,sim,'run',tolerances)
  errcatch(-1)
  if iserror(888)==0 then
    tcur=t
    alreadyran=%t
  else
    errclear(888)
    x_message('Simulation problem, see message in scilab window')
    ok=%f
  end
  xset('window',curwin)
  disp(timer())
  unsetmenu(curwin,'stop')
  xset('window',curwin);
  xset('alufunction',6)
end

