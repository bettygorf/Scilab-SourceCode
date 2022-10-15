function [scs_m,newparameters,needcompile]=scicos(scs_m,menus)
// scicos - block diagram graphic editor
//%SYNTAX
// scs_m=scicos(scs_m,job)
//%PARAMETERS
// scs_m    : scilab list, scicos main data structure
//      scs_m(1) contains system name and other infos
//      scs_m(i+1) contains description of ith block diagram element
// menus : vector of character strings,optional parameter giving usable menus 
//!
scicos_ver='scicos2.3' // set current version of scicos

//check if superblock editing mode
[l,mac]=where()
slevel=prod(size(find(mac=='scicos')))
super_block=slevel>1

[lhs,rhs]=argn(0)
if rhs>=1 then
  if type(scs_m)==10 then //diagram is given by its filename
    fil=scs_m
    alreadyran=%f
    [ok,scs_m,cpr]=do_load(fil)
    if ~ok then return,end
    if size(cpr)==0 then
      needcompile=4
      state0=list()
    else
      state0=cpr(1);
      needcompile=0
    end
  else //diagram is given by its data structure
    if ~super_block then 
      cpr=list();needcompile=4;alreadyran=%f,state0=list()
    end
  end
else
  cpr=list();needcompile=4;alreadyran=%f;state0=list()
end


if ~super_block then
  // global variables
  pal_mode=%f // Palette edition mode
  newblocks=[] // table of added functions in pal_mode
  super_path=[] // path to the currently opened superblock
  addcolor([255 255 0;
      173 216 230]/255) // add menubar colors 
end
context=[];
tf=100000
tolerances=[1.d-4,1.d-6,1.d-10,tf+1];

if rhs<1 then
  Xshift=0
  Yshift=0
  scs_m=list(list([600,450,Xshift,Yshift],'Untitled',tolerances,tf,context)),
end
if type(scs_m)<>15 then error('first argument must be a scicos list'),end
scs_m(1)(1)(2)=maxi(scs_m(1)(1)(2),450) //compatibility


wpar=scs_m(1)
wsiz=wpar(1)
//next line for compatiblity
if size(wsiz,'*')<4 then wsiz(3)=0;wsiz(4)=0;wpar(1)=wsiz;end

//Menu definitions
if ~super_block then
  menu_p=['Help','Edit..','Simulate..','File..','Block..','Pal editor..','View','Exit']
  menu_e=['Help','Window','Palettes','Context','Move','Copy','Replace','Align',..
               'Link','Delete','Flip','Save','Undo','Replot','View',..
	       'Calc','Back']
  menu_s=['Help','Setup','Compile','Context','Eval','Run','Calc','Save','Back']
  menu_f=['Help','New','Purge','Rename','Save','Save As','FSave','Load','Back']
  menu_b=['Help','Resize','Icon','Color','Label','Back']
else
  menu_f=['Help','New','Purge','Rename','Newblk','Save','Save As','FSave','Load','Back']
  menu_p=['Help','Edit..','File..','Block..','View','Exit']
end

if rhs<=1 then 
  menus=menu_p  
else
  if menus==[] then
    win=xget('window')
    systshow(scs_m,win),
    xset('window',win);
    return,
  else
    menus=menus(:)'
    all=[menu_p,menu_e,menu_s,menu_f,menu_b]
    pb=[]
    for k=1:size(menus,'*')
      if find(menus(k)==all)==[] then pb=[pb,k],end
    end
    if pb<>[] then
      message(['Some required menus are undefined :';menus(pb)'])
      return
    end
  end
end


//Initialisation
//viewport
Xshift=wsiz(3)
Yshift=wsiz(4)


newparameters=list()
eps=0.1
gridvalues=[0,0,1,1]
enable_undo=%f
edited=%f
path='./'

if ~super_block then
  xset('window',0);
  curwin=xget('window');
  palettes=list();
  noldwin=0
  windows=[1 curwin]
else
  noldwin=size(windows,1)
  windows=[windows;slevel curwin]
  palettes=palettes;
end



//initialize graphics
xset('window',curwin);
xset('default')
xset('pattern',1)
xset('dashes',1)
xbasc();xselect()
dr=driver();
pixmap=xget('pixmap')==1
wsiz=wpar(1)
xset('wdim',wsiz(1),wsiz(2))
xsetech([-1 -1 8 8]/6,[Xshift,Yshift ,Xshift+wsiz(1),Yshift+wsiz(2)])
xset('alufunction',6)


if ~super_block then
  delmenu(curwin,'stop')
  addmenu(curwin,'stop',list(1,'haltscicos'))
  unsetmenu(curwin,'stop')
end
unsetmenu(curwin,'File',1) //clear
unsetmenu(curwin,'File',2) //select
unsetmenu(curwin,'File',7) //close
unsetmenu(curwin,'File',6) //load
unsetmenu(curwin,'3D Rot.')

scs_m(1)(1)(2)=maxi(scs_m(1)(1)(2),450)

//draw diagram and menus
drawobjs(scs_m)
datam=drawmbar(menus,'v')
if pixmap then xset('wshow'),end

//set context (variable definition...)
if size(scs_m(1))>4 then 
  if type(scs_m(1)(5))==10 then
    execstr(scs_m(1)(5)) ,
  else
    scs_m(1)(5)=' ' 
  end
end

n=0
while %t
  while %t do
    if n==0 then
      [btn,xc,yc]=xclick();
      pt=[xc,yc]
      [n,pt,btn]=getmenu(datam,pt)
    end
    if n>0 then
      n_sel=n; n=0;
      hilitemenu(n_sel,datam)
      if pixmap then xset('wshow'),end
      Cmenu=menus(n_sel);break
    else
      n_sel=0
      k=getobj(scs_m,[xc;yc])
      if k<>[] then Cmenu='Edit_Object',break,end
    end
  end
  select Cmenu
  case 'Exit' then  // OK
    ok=do_exit()
    if ok then 
      if pal_mode then 
	if edited then scs_m=list(),end
	newparameters=newblocks,
	needcompile=~edited|size(scs_m)>1
      end
      break
    else
      unhilitemenu(n_sel,datam)
    end
  case 'Palettes' then
    [palettes,windows]=do_palettes(palettes,windows)
    unhilitemenu(n_sel,datam)
  case 'New' then
    r=1
    if edited then
      r=message(['Diagram has not been saved';
	  'Really exit?'],['Yes';'No'])
    end
    if r==1 then
      if alreadyran then do_terminate(),end  //terminate current simulation
      Xshift=0;Yshift=0
      scs_m=list(list([600,450,Xshift,Yshift],'Untitled',tolerances,tf))
      wpar=scs_m(1);wsiz=wpar(1)
      xsetech([-1 -1 8 8]/6,[Xshift,Yshift ,Xshift+wsiz(1),Yshift+wsiz(2)])
      xbasc();drawobjs(scs_m)
      datam=drawmbar(menus,'v')
      edited=%f
    end
  case 'Move' then  // Move
    xinfo('Click object to move, drag to new position and click')
    scs_m_save=scs_m;nc_save=needcompile;enable_undo=%t
    scs_m=do_move(scs_m)
    xinfo(' ')
    unhilitemenu(n_sel,datam)
    edited=%t
  case 'Copy' then  // Copy
    xinfo('Click left on the object to copy or right for a region')
    scs_m_save=scs_m;nc_save=needcompile;enable_undo=%t
    [scs_m,needcompile]=do_copy(scs_m,needcompile);
    xinfo(' ')
    unhilitemenu(n_sel,datam)
    edited=%t
  case 'Replace' then  // Replace
    xinfo('Click on new object , click on object to be replaced')
    scs_m_save=scs_m;nc_save=needcompile;enable_undo=%t
    [scs_m,needcompile]=do_replace(scs_m,needcompile);
    xinfo(' ')
    unhilitemenu(n_sel,datam)
    edited=%t
  case 'Align' then
    xinfo('Click on an a port , click on a port of object to be moved')
    scs_m_save=scs_m;nc_save=needcompile;
    scs_m=prt_align(scs_m)
    xinfo(' ')
    unhilitemenu(n_sel,datam)
    edited=%t
  case 'Link' then  // Link
    xinfo('Click on the link origin , drag, click on final or intermediate point')
    scs_m_save=scs_m;nc_save=needcompile;enable_undo=%t
    [scs_m,needcompile]=getlink(scs_m,needcompile);
    xinfo(' ')
    unhilitemenu(n_sel,datam)
    edited=%t
  case 'Delete' then  // Delete
    xinfo('Click left on the object to delete or right for a region')
    scs_m_save=scs_m;nc_save=needcompile;enable_undo=%t
    [scs_m,needcompile]=do_delete(scs_m,needcompile);
    xinfo(' ')
    unhilitemenu(n_sel,datam)
    edited=%t
  case 'Flip' then
    xinfo('Click on block to be flipped')
    scs_m_save=scs_m;nc_save=needcompile;enable_undo=%t
    scs_m=do_tild(scs_m)
    xinfo(' ')
    unhilitemenu(n_sel,datam)
    edited=%t
  case 'Undo' then
    if enable_undo then
      scs_m=scs_m_save;needcompile=nc_save
      xset('alufunction',3);xbasc();xselect();xset('alufunction',6);
      drawobjs(scs_m),
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
    drawobjs(scs_m),
    datam=drawmbar(menus,'v')
  case 'Window' then
    wpar=scs_m(1);wd=wpar(1);
    wpar=do_window(wpar)
    if or(wd<>wpar(1)) then
      xset('alufunction',3);xbasc();xselect();xset('alufunction',6);
      wd=wpar(1)(1:2)
      xset('wdim',wd(1),wd(2)),
      xsetech([-1 -1 8 8]/6,[Xshift,Yshift ,Xshift+wd(1),Yshift+wd(2)])
      drawobjs(scs_m),
      datam=drawmbar(menus,'v')
      hilitemenu(n_sel,datam)
      if pixmap then xset('wshow'),end
    end
    scs_m(1)=wpar
    unhilitemenu(n_sel,datam)
  case 'Setup' then
    wpar=do_setup(scs_m(1))
    scs_m(1)=wpar
    unhilitemenu(n_sel,datam)
  case 'Context' then
    while %t do
      [context,ok]=do_context(scs_m(1)(5))
      if ~ok then break,end
      ierr=execstr(context,'errcatch')
      if ierr==0 then 
	scs_m(1)(5)=context;break,
      else
	message(['Incorrect context definition,';
	         'see message in Scilab window'])
      end
    end
    unhilitemenu(n_sel,datam)
  case 'Compile' then
    [cpr,ok]=do_compile(scs_m)
    if ok then
      newparameters=list()
      tcur=0 //temps courant de la simulation
      alreadyran=%f
      state0=cpr(1);
      needcompile=0;
    else
      needcompile=4,
    end
    unhilitemenu(n_sel,datam)
  case 'Run' then
    ok=%t
    [ok,tcur,cpr,alreadyran,needcompile,state0]=do_run(cpr)
    if ok then newparameters=list(),end
    unhilitemenu(n_sel,datam)
  case 'Rename' then
    scs_m=do_rename(scs_m) 
    unhilitemenu(n_sel,datam)    
  case 'Save' then
    ok=do_save(scs_m) 
    if ok then edited=%f,end
    unhilitemenu(n_sel,datam)
  case 'Save As' then
    [scs_m,edited]=do_SaveAs()
    unhilitemenu(n_sel,datam)
  case 'FSave' then
    ok=do_fsave(scs_m)
    edited=edited&~ok
    unhilitemenu(n_sel,datam)
  case 'Load' then
    [ok,scs_m,cpr]=do_load()
    if ok then
      wpar=scs_m(1)
      wdm=wpar(1)
      Xshift=wdm(3);Yshift=wdm(4);
      xset('alufunction',3);xbasc();xselect();
      xset('wdim',wdm(1),wdm(2))
      xsetech([-1 -1 8 8]/6,[Xshift,Yshift ,Xshift+wdm(1),Yshift+wdm(2)])
      xselect();
      xset('alufunction',6)
      drawobjs(scs_m),
      datam=drawmbar(menus,'v')
      execstr(scs_m(1)(5)) ,
      hilitemenu(n_sel,datam)
      if size(cpr)==0 then
	needcompile=4
	alreadyran=%f
      else
	state0=cpr(1)
	needcompile=0
	alreadyran=%f
      end
    end
    unhilitemenu(n_sel,datam)
  case 'Purge' then
    scs_m=do_purge(scs_m);
    needcompile=4;
    edited=%t
    unhilitemenu(n_sel,datam)
  case 'View' then
    xinfo('Click on the point you want to put in the middle of the window')
    wdm=do_view(scs_m)
    wpar=scs_m(1)
    wpar(1)=wdm;scs_m(1)=wpar
    Xshift=wdm(3);Yshift=wdm(4)
    drawobjs(scs_m),
    xinfo(' ')
    datam=drawmbar(menus,'v')
    if pixmap then xset('wshow'),end
    edited=%t
  case 'Calc' then
    xinfo('You may enter any Scilab instruction. enter return to terminate')
    scs_gc=save_scs_gc()
    erasemenubar(datam)
    pause
    xinfo(' ')
    restore_scs_gc(scs_gc);scs_gc=null()
    datam=drawmbar(menus,'v')
  case 'Newblk' then
    [ok,dir]=getvalue(['Enter path of the directory';
	'where to write the block GUI function'] ,'path',list('str',1),' ')
    if ok then
      path=save_csuper(scs_m,dir)
      if path<>[] then getf(path),end
    end
    unhilitemenu(n_sel,datam)
  case 'Nyquist' then
    syst=analyse(scs_m)
    sl=bloc2ss(syst)
    xset('window',curwin+1);xbasc()
    nyquist(sl)
    xset('window',curwin);
    unhilitemenu(n_sel,datam)
  case 'Edit_Object' then
    super_path=[super_path,k] 
    [o,modified,newparametersb,needcompileb]=clickin(scs_m(k))
    super_path($)=[]
    if ~pal_mode then
      needcompile=max(needcompile,needcompileb)
    end
    scs_m=update_redraw_obj(scs_m,k,o)
    //note if block parameters have been modified
    if modified&~pal_mode  then
      model=o(3)
      newparameters=mark_newpars(k,newparametersb,newparameters)
      edited=%t
    end
  case 'Resize' then
    xinfo('Click block to resize')
    scs_m=do_resize(scs_m)
    xinfo(' ')
    unhilitemenu(n_sel,datam)
    edited=%t
  case 'Icon' then
    xinfo('Click block to edit')
    scs_m_save=scs_m;nc_save=needcompile;enable_undo=%t
    scs_m=do_block(scs_m)
    xinfo(' ')
    unhilitemenu(n_sel,datam)
    edited=%t
  case 'Color' then
    xinfo('Click on block to paint')
    scs_m_save=scs_m;nc_save=needcompile;enable_undo=%t
    scs_m=do_color(scs_m)
    xinfo(' ')
    unhilitemenu(n_sel,datam)
    edited=%t
  case 'Label' then
    xinfo('Click block to label')
    scs_m_save=scs_m;nc_save=needcompile;enable_undo=%t
    [mod,scs_m]=do_label(scs_m)
    edited=edited|mod
    xinfo(' ')
    unhilitemenu(n_sel,datam)
  case 'Eval' then
    [scs_m,cpr,needcompile,ok]=do_eval(scs_m,cpr)
    if needcompile<>4 then state0=cpr(1),end
    alreadyran=%f
    unhilitemenu(n_sel,datam)
  case 'Help' then
    do_help()
    unhilitemenu(n_sel,datam)
  case 'AddNew' then
    [scs_m,fct]=do_addnew(scs_m)
    if fct<>[] then 
      getf(fct),
      newblocks=[newblocks;fct]
    end
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
  case 'Block..' then
    unhilitemenu(n_sel,datam)
    menus=menu_b
    erasemenubar(datam)
    datam=drawmbar(menus,'v')
  case 'Pal editor..' then
    unhilitemenu(n_sel,datam)
    erasemenubar(datam)
    [newblocks,pals_changed]=do_edit_pal()
    if pals_changed then exec('~/scicos_pal.exe',-1),end
    drawmbar(menus,'v');
  case 'Back' then
    unhilitemenu(n_sel,datam)
   
    menus=menu_p
    erasemenubar(datam)
    datam=drawmbar(menus,'v')
  end
  if pixmap then xset('wshow'),end
end








