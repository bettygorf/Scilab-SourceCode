function [x,newparameters,needcompile]=scicos(x,job)
// scicos - block diagram graphic editor
//%SYNTAX
// x=scicos(x,job)
//%PARAMETERS
// x   : scilab list, 
//      x(1) contains system name
//      x(i+1) contains description of ith block diagram element 
// job :
//!
[lhs,rhs]=argn(0)

//check if superblock editing mode
[l,mac]=where()
slevel=prod(size(find(mac=='scicos')))
super_block=slevel>1

if ~super_block then
  tolerances=[1.d-4,1.d-6,1.d-10];tf=100000;sim_mode=1;
else
  tolerances=[];tf=[];sim_mode=[];
end

if rhs<1 then x=list(list([600,400],'Untitled',tolerances,tf,sim_mode)),end
if type(x)<>15 then error('first argument must be a scicos list'),end
//next line for compatiblity
if size(x(1))<5 then par=x(1),par(5)=sim_mode,x(1)=par,end

if rhs<=1 then job='edit',end
if job<>'edit' then  
  win=xget('window')
  systshow(x,win),
  xset('window',win);
  return,
end

//Initialisation
//viewport 
Xshift=0
Yshift=0

newparameters=list()
eps=0.1
gridvalues=[0,0,1,1]
enable_undo=%f
edited=%f 
path='./'
if exists('user_pal_dir')==0 then user_pal_dir=[],end
//
//Menu definitions
if ~super_block then
  menu_p=['Help','Edit..','Simulate..','File..','View','Exit']
else
  menu_p=['Help','Edit..','File..','Setup','View','Exit']
end
menu_e=['Help','Palettes','Move','Copy','Align','Link','Delete','Flip',..
               'Save','Undo','Replot','View','Back']
menu_s=['Help','Setup','Compile','Run','Back']
menu_f=['Help','New','Save','Save As','FSave','Newblk','Load','Back']

if ~super_block then
  xset('window',0);xset('dashes',0);
  curwin=xget('window');
  objs=list();
  needcompile=%t
  noldwin=0
  windows=[1 curwin]
  pal_names=set_palette()
else 
  noldwin=size(windows,1)
  windows=[windows;slevel curwin]
  needcompile=%f
  objs=objs;
end

menus=menu_p
//initialize graphics
wpar=x(1)
xset('window',curwin);xbasc();xselect()
dr=driver();
pixmap=xget('pixmap')==1
wsiz=wpar(1)
if wsiz<>[] then xset('wdim',wsiz(1),wsiz(2)),end
xsetech([-1 -1 8 8]/6,[Xshift,Yshift ,Xshift+wsiz(1),Yshift+wsiz(2)])
xset('alufunction',6)

if ~super_block then
  delmenu(curwin,'stop')
  addmenu(curwin,'stop',list(1,'halt_scicos'))
  unsetmenu(curwin,'stop')
end
unsetmenu(curwin,'File',1) //clear
unsetmenu(curwin,'File',6) //close
unsetmenu(curwin,'File',5) //load
unsetmenu(curwin,'3D Rot.')

//draw scheme and menus
drawobjs(x)
datam=drawmbar(menus,'v')
if pixmap then xset('wshow'),end


n=0
while %t 
  while %t do
    if n==0 then 
      [btn,xc,yc]=xclick();
      pt=[xc,yc]
      [n,pt,btn]=getmenu(datam,pt)
    end
    if n>0 then
      //write(33,strcat(string([btn,xc,yc]),',')+' /'+'/'+menus(n))
      n_sel=n; n=0
      hilitemenu(n_sel,datam)
      if pixmap then xset('wshow'),end
      Cmenu=menus(n_sel);break
    else
      //write(33,strcat(string([btn,xc,yc]),',')+' /'+'/ Block')
      n_sel=0
      k=getobj(x,[xc;yc])
      if k<>[] then Cmenu='Edit_Object',break,end
    end
  end
  select Cmenu
  case 'Exit' then  // OK      
    r=1
    if edited&~super_block then
      r=x_message(['Diagram has not been saved';
	         'Really exit?'],['Yes';'No'])
    end
    if r==1 then
      xset('window',curwin)
      erasemenubar(datam)
      if pixmap then xset('wshow'),end
      xset('alufunction',3)
      setmenu(curwin,'3D Rot.')
      setmenu(curwin,'File',1) //clear
      setmenu(curwin,'File',5) //load
      setmenu(curwin,'File',6) //close
      if ~super_block then 
	delmenu(curwin,'stop'),
	xset('window',curwin),xsetech([0 0 1 1])
      end
      for win=windows(size(windows,1):-1:noldwin+1,2)',xbasc(win),xdel(win);end
      break
    else
      unhilitemenu(n_sel,datam)
    end
  case 'Palettes' then
    kpal=x_choose(pal_names,'Choose a Palette')
    if kpal<>0 then
      winpal=find(windows(:,1)==-kpal)
      lastwin=curwin
      if winpal==[] then
	wfree=find(windows(:,1)==0)
	if wfree<>[] then
	  curwin=wfree(1)
	else
	  curwin=maxi(windows(:,2))+1
	end
	windows=[windows;[-kpal curwin]]
      else
	curwin=windows(winpal,2)
      end
      xset('alufunction',3)
      no=size(objs)
      for k=no+1:kpal-1, objs(k)=list(),end
      xset('window',curwin),xselect();
      if pixmap then xset('pixmap',1),end,xbasc();
      objs(kpal)=drawpal(set_palette(pal_names(kpal)))
      if pixmap then xset('wshow'),end
      no=size(objs)
      curwin=lastwin
      xset('window',curwin)
      xset('alufunction',6)
    end
    unhilitemenu(n_sel,datam)
  case 'New' then
    r=1
    if edited then
      r=x_message(['Diagram has not been saved';
	  'Really exit?'],['Yes';'No'])
    end
    if r==1 then
      x=list(list([600,400],'Untitled',tolerances,tf))
      wpar=x(1);wsiz=wpar(1)
      Xshift=0;Yshift=0
      xsetech([-1 -1 8 8]/6,[Xshift,Yshift ,Xshift+wsiz(1),Yshift+wsiz(2)])
      xbasc();drawobjs(x)
      datam=drawmbar(menus,'v')
      edited=%f
    end
  case 'Move' then  // Move
    x_save=x;nc_save=needcompile;enable_undo=%t
    x=do_move(x)
    unhilitemenu(n_sel,datam)
    edited=%t
  case 'Copy' then  // Copy
    x_save=x;nc_save=needcompile;enable_undo=%t
    [x,needcompile]=do_copy(x,needcompile);
    unhilitemenu(n_sel,datam)
    edited=%t
  case 'Align' then
    x_save=x;nc_save=needcompile;
    x=prt_align(x)
    unhilitemenu(n_sel,datam)
    edited=%t
  case 'Link' then  // Link
    x_save=x;nc_save=needcompile;enable_undo=%t
    [x,needcompile]=getlink(x,needcompile);
    unhilitemenu(n_sel,datam)
    edited=%t
  case 'Delete' then  // Delete
    x_save=x;nc_save=needcompile;enable_undo=%t
    [x,needcompile]=do_delete(x,needcompile);
    unhilitemenu(n_sel,datam)
    edited=%t
  case 'Flip' then
    x_save=x;nc_save=needcompile;enable_undo=%t
    x=do_tild(x)
    unhilitemenu(n_sel,datam)
    edited=%t
  case 'Undo' then
    if enable_undo then
      x=x_save;needcompile=nc_save
      xset('alufunction',3);xbasc();xselect();xset('alufunction',6);
      drawobjs(x),
      xset('alufunction',6);
      datam=drawmbar(menus,'v')
      hilitemenu(n_sel,datam)
      if pixmap then xset('wshow'),end
      enable_undo=%f
    end
    unhilitemenu(n_sel,datam)
  case 'Replot' then
    xset('alufunction',3);xbasc();xselect();xset('alufunction',6);
    wdm=xget('wdim').*[1.016 1.12]
    xsetech([-1 -1 8 8]/6,[Xshift,Yshift ,Xshift+wdm(1),Yshift+wdm(2)])
    drawobjs(x),
    datam=drawmbar(menus,'v')
  case 'Setup' then
    wpar=x(1);wd=wpar(1);
    wpar=do_setup(wpar)
    if or(wd<>wpar(1)) then
      xset('alufunction',3);xbasc();xselect();xset('alufunction',6);
      wd=wpar(1)
      xset('wdim',wd(1),wd(2)),
      xsetech([-1 -1 8 8]/6,[Xshift,Yshift ,Xshift+wd(1),Yshift+wd(2)])
      datam=drawmbar(menus,'v')
      hilitemenu(n_sel,datam)
      drawobjs(x),
      if pixmap then xset('wshow'),end
    end
    x(1)=wpar
    unhilitemenu(n_sel,datam)
  case 'Compile' then
    [state,sim,cor,corinv,ok]=do_compile(x)
    if ok then
      newparameters=list()
      tcur=0 //temps courant de la simulation
      needcompile=%f
      alreadyran=%f
      state0=state;
    end
    unhilitemenu(n_sel,datam)
  case 'Run' then
    ok=%t
    [ok,tcur,state,sim,cor,corinv,needcompile,alreadyran,state0]=do_run()
    unhilitemenu(n_sel,datam)
  case 'Save' then
    fname=path+get_tree_elt(x,[1 2])+'.cos'
    errcatch(240,'continue','nomessage')
    u=file('open',fname,'unknown','unformatted')
    errcatch(-1)
    if iserror(240)==1 then
      x_message('Directory write access denied')
      errclear(240)
    else
      save(u,x)
      file('close',u)
      edited=%f
    end
    unhilitemenu(n_sel,datam)
  case 'Save As' then
    fname=xgetfile('*.cos')
    if fname<>emptystr() then
      [path,name,ext]=splitfilepath(fname)
      select ext
      case 'cos' then
	ok=%t
      else
	x_message('Only *.cos binary files allowed');
        ok=%f
      end
      if ok then 
	drawtitle(x(1))
	x=change_tree_elt(x,[1 2],name)
	errcatch(240,'continue','nomessage')
	u=file('open',fname,'unknown','unformatted')
	errcatch(-1)
	if iserror(240)==1 then
	  x_message('Directory write access denied')
	  errclear(240)
	else
	  save(u,x)
	  file('close',u)
	  edited=%f
	  drawtitle(x(1))
	end
      end
    end
    unhilitemenu(n_sel,datam)
  case 'FSave' then
    fname=xgetfile('*.cosf')
    if fname<>emptystr() then
      [path,name,ext]=splitfilepath(fname)
      select ext
      case 'cosf' then
	ok=%t
      else
	x_message('Only *.cosf  files allowed');
        ok=%f
      end
      if ok then 
	x=change_tree_elt(x,[1 2],name)
	errcatch(240,'continue','nomessage')
	u=file('open',fname,'unknown')
	errcatch(-1)
	if iserror(240)==1 then
	  x_message('Directory write access denied')
	  errclear(240)
	else
	  write(u,sci2exp(x,'x'),'(a)')
	  file('close',u)
	  edited=%f
	end
      end
    end
    unhilitemenu(n_sel,datam)
  case 'Load' then
    fname=xgetfile('*.cos*')
    if fname<>emptystr() then
      [path,name,ext]=splitfilepath(fname)
      select ext
      case 'cosf'
	exec(fname,-1)
	ok=%t
      case 'cos' then
	load(fname),
	ok=%t
      else
	x_message(['Only *.cos binary files or *.cosf formatted file';
	  'allowed'])
        ok=%f
      end
      if ok then
	//next line for compatiblity
	wpar=x(1)
	if size(wpar)<5 then wpar(5)=sim_mode,x(1)=wpar,end
	wdm=wpar(1)
	Xshift=0;Yshift=0;
	xset('alufunction',3);xbasc();xselect();
	xset('wdim',wdm(1),wdm(2)) 
	xsetech([-1 -1 8 8]/6,[Xshift,Yshift ,Xshift+wdm(1),Yshift+wdm(2)])
	xselect();
	xset('alufunction',6)
	drawobjs(x),
	datam=drawmbar(menus,'v')
	hilitemenu(n_sel,datam)
	needcompile=%t
      end
    end
    unhilitemenu(n_sel,datam)
  case 'View' then
    wpar=x(1);wdm=wpar(1)
    [btn,xc,yc]=xclick() //get center of new view
    oxc=Xshift+(wdm(1)-80)/2
    oyc=Yshift+(wdm(2))/2
    Xshift=Xshift+(xc-oxc)
    Yshift=Yshift+(yc-oyc)
    xset('alufunction',3);xbasc();xselect();
    xsetech([-1 -1 8 8]/6,[Xshift,Yshift ,Xshift+wdm(1),Yshift+wdm(2)])
    xset('alufunction',6)
    drawobjs(x),
    datam=drawmbar(menus,'v')
    if pixmap then xset('wshow'),end
  case 'Newblk' then
    nup=size(user_pal_dir,'*')
    if nup==0 then pal_dir=emptystr(),else pal_dir=user_pal_dir(nup),end
    [ok,pal_dir]=getvalue('Enter user palette path','path',list('str',1),..
	pal_dir)
    if ok then 
      save_csuper(x,pal_dir)
      if and(pal_dir<>user_pal_dir) then 
	user_pal_dir=[user_pal_dir;pal_dir]
      end
    end
    unhilitemenu(n_sel,datam)
  case 'Nyquist' then
    syst=analyse(x)
    sl=bloc2ss(syst)
    xset('window',curwin+1);xbasc()
    nyquist(sl)
    xset('window',curwin);
    unhilitemenu(n_sel,datam)
  case 'Edit_Object' then
    [o,modified,newparametersb,needcompileb]=clickin(x(k))
    needcompile=needcompile|needcompileb
    //note if block parameters have been modified 
    if modified then  //&~needcompile
      model=o(3)
      if model(1)=='super'|model(1)=='csuper'
	for npb=newparametersb
	  ok=%t;
	  for np=newparameters
	    if np==[k npb] then 
	      ok=%f;break,
	    end
	  end
	  if ok then 
	    newparameters(size(newparameters)+1)=[k npb];
	  end
	end
      else
	ok=%t
	for np=newparameters
	  if np==k then 
	    ok=%f;break;
	  end
	end
	if ok then 
	  newparameters(size(newparameters)+1)=k
	end
      end
      edited=%t
    end
    x(k)=o,
  case 'Help' then
    do_help()
    unhilitemenu(n_sel,datam)
  case 'Edit..' then
    unhilitemenu(n_sel,datam)
    menus=menu_e
    erasemenubar(datam)
    datam=drawmbar(menus,'v')
  case 'Simulate..' then
    unhilitemenu(n_sel,datam)
    menus=menu_s
    erasemenubar(datam)
    datam=drawmbar(menus,'v')
  case 'File..' then
    unhilitemenu(n_sel,datam)
    menus=menu_f
    erasemenubar(datam)
    datam=drawmbar(menus,'v')
  case 'Back' then 
     unhilitemenu(n_sel,datam)
     menus=menu_p
     erasemenubar(datam)
     datam=drawmbar(menus,'v')
  end
  if pixmap then xset('wshow'),end
end
function [path,name,ext]=splitfilepath(fname)
l=length(fname)
//getting the extension part
n=l
while n>0
  cn=part(fname,n)
  if cn=='.'|cn=='/' then break,end
  n=n-1
end
if n==0 then 
  ext=emptystr()
elseif cn=='/' then
  ext=emptystr()
  n=l
else
  ext=part(fname,n+1:l)
  n=n-1
end
//getting the name part
l=n
n=l
while n>0
  cn=part(fname,n)
  if cn=='/' then break,end
  n=n-1
end
if n==0 then 
  name=part(fname,1:l)
  path='./'
else
  name=part(fname,n+1:l)
  path=part(fname,1:n)
end
