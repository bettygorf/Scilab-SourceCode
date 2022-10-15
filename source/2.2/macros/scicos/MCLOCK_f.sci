function [x,y,typ]=MCLOCK_f(job,arg1,arg2)
x=[];y=[],typ=[]
select job
case 'plot' then
  standard_draw(arg1)
  graphics=arg1(2);
  [orig,sz]=graphics([1:2])
  xstringb(orig(1),orig(2),['2freq clock';'  f/n     f'],sz(1),sz(2),'fill')
case 'getinputs' then
  [x,y,typ]=standard_inputs(arg1)
case 'getoutputs' then
  [x,y,typ]=standard_outputs(arg1)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  // paths to updatable parameters or states
  ppath = list(2)
  newpar=list();
  for path=ppath do
    np=size(path,'*')
    spath=[matrix([3*ones(1,np);8*ones(1,np);path],1,3*np)]
    xx=get_tree_elt(arg1,spath)// get the block
    execstr('xxn='+xx(5)+'(''set'',xx)')
    if ~and(xxn==xx) then 
      // parameter or states changed
      arg1=change_tree_elt(arg1,spath,xxn)// Update
      newpar(size(newpar)+1)=path// Notify modification
    end
  end
  x=arg1
  y=%f
  typ=newpar
case 'define' then
  model = list('csuper',0,0,0,2,[],[],..
  list(list([600 , 400],' ',[],[],[]),..
  list('Block',..
  list([334 , 199],[40 , 40],%t,' ',[],[],13,..
  [5;
  4]),list('mfclck',0,0,1,2,[],0, .1,5,'d',[-1 0],[%f , %f]),' ','MFCLCK_f'),..
  list('Block',..
  list([457 , 161],[16.666667 , 16.666667],%t,' ',[],[],..
  [5;
  10;
  0],6),list('sum',0,0,3,1,[],[],[],[],'d',%f,[%f , %f]),' ','CLKSOM_f'),..
  list('Link',..
  [360.66667;
  360.66667;
  411.92504],..
  [193.28571;
  169.33333;
  169.33333],'drawlink',' ',[0 , 0],[10 , -1],[2 , 2],[9 , 1]),..
  list('Link',..
  [347.33333;
  347.33333;
  461.78421;
  461.78421],..
  [193.28571;
  155.48961;
  155.48961;
  161],'drawlink',' ',[0 , 0],[10 , -1],[2 , 1],[3 , 1]),..
  list('Link',..
  [468.94938;
  482.45315],..
  [169.33333;
  169.33333],'drawlink',' ',[0 , 0],[10 , -1],[3 , 1],[12 , 1]),..
  list('Block',list([509 , 261],[20 , 20],%t,'Out',[],[],11,[]),..
  list('output',0,0,1,0,[],[],[],1,'d',%f,[%f , %f]),' ','CLKOUT_f'),..
  list('Block',list([509 , 142],[20 , 20],%t,'Out',[],[],14,[]),..
  list('output',0,0,1,0,[],[],[],2,'d',%f,[%f , %f]),' ','CLKOUT_f'),..
  list('Block',..
  list(..
  [411.92504;
  169.33333],[1 , 1],%t,' ',[],[],4,..
  [10;
  11]),list('lsplit',0,0,1,2,[],[],[],[],'d',[%f , %f],[%t , %f]),' ','CLKSPLIT_f'),..
  list('Link',..
  [411.92504;
  457],..
  [169.33333;
  169.33333],'drawlink',' ',[0 , 0],[10 , -1],[9 , 1],[3 , 2]),..
  list('Link',..
  [411.92504;
  411.92504;
  509],..
  [169.33333;
  271;
  271],'drawlink',' ',[0 , 0],[10 , -1],[9 , 2],[7 , 1]),..
  list('Block',..
  list(..
  [482.45315;
  169.33333],[1 , 1],%t,' ',[],[],6,..
  [13;
  14]),list('lsplit',0,0,1,2,[],[],[],[],'d',[%f , %f],[%t , %f]),' ','CLKSPLIT_f'),..
  list('Link',..
  [482.45315;
  489.60818;
  489.60818;
  354;
  354],..
  [169.33333;
  169.33333;
  338.27893;
  338.27893;
  244.71429],'drawlink',' ',[0 , 0],[10 , -1],[12 , 1],[2 , 1]),..
  list('Link',..
  [482.45315;
  482.45315;
  509],..
  [169.33333;
  152;
  152],'drawlink',' ',[0 , 0],[10 , -1],[12 , 2],[8 , 1])),[],'h',%f,[%f , %f])
  x=standard_define([3 3],model,' ')
end

