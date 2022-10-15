function [scs_m,newparameters,needcompile,edited]=scicos(scs_m,menus)
// scicos - block diagram graphic editor
//%SYNTAX
// scs_m=scicos(scs_m,job)
//%PARAMETERS
// scs_m    : scilab list, scicos main data structure
//      scs_m(1) contains system name and other infos
//      scs_m(i+1) contains description of ith block diagram element
// menus : vector of character strings,optional parameter giving usable menus 
//!
// Copyright INRIA
[lhs,rhs]=argn(0)
//check if superblock editing mode
[l,mac]=where()
slevel=prod(size(find(mac=='scicos')))
super_block=slevel>1
if ~super_block then
  // define scicos libraries
  if exists('scicoslib')==0 then load('SCI/macros/scicos/lib'),end
  if exists('blockslib')==0 then load('SCI/macros/scicos_blocks/lib'),end
end

if rhs>1 then 
  win=xget('window')
  systshow(scs_m,win),
  xset('window',win);
  return,
end

scicos_ver='scicos2.4' // set current version of scicos

//Initialisation
newparameters=list()
enable_undo=%f
edited=%f
path='./'


if ~super_block then // global variables
  pal_mode=%f // Palette edition mode
  newblocks=[] // table of added functions in pal_mode
  super_path=[] // path to the currently opened superblock
end
//
if rhs>=1 then
  if type(scs_m)==10 then //diagram is given by its filename
    fil=scs_m
    alreadyran=%f
    [ok,scs_m,cpr,edited]=do_load(fil,'diagram')
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
  scs_m=empty_diagram()
  cpr=list();needcompile=4;alreadyran=%f;state0=list()
end
//
if type(scs_m)<>15 then error('first argument must be a scicos list'),end



//Menu definitions
 
menu_e=['Palettes','Context','Smart Move','Move','Copy','Copy Region',..
	'Replace','Align','Link','Delete','Delete Region','Add new block',..
	'Flip','Undo']
menu_s=['Setup','Compile','Eval','Run']
menu_f=['Replot','New','Region to Super Block','Purge','Rename','Save','Save As',..
	'Load','Load as Palette','Save as Palette','Save as Interf. Func.',..
	'Set Diagram Info','Navigator','Exit']
menu_b=['Open/Set','Resize','Icon','Color','Label','Get Info','Set block ID']
menu_v=['Window','Background color','Default link colors','ID fonts','3D aspect',..
	'Add color','Focus','Shift','Zoom in','Zoom out','Help','Calc']

menus=list(['Edit','Simulate','Diagram','Object','Misc'],..
    menu_e,menu_s,menu_f,menu_b,menu_v)
//Create callbacks
w='menus(2)(';rpar=')'
Edit=w(ones(menu_e))+string(1:size(menu_e,'*'))+rpar(ones(menu_e))
w='menus(3)(';rpar=')'
Simulate=w(ones(menu_s))+string(1:size(menu_s,'*'))+rpar(ones(menu_s))
w='menus(4)(';rpar=')'
Diagram=w(ones(menu_f))+string(1:size(menu_f,'*'))+rpar(ones(menu_f))
w='menus(5)(';rpar=')'
Object=w(ones(menu_b))+string(1:size(menu_b,'*'))+rpar(ones(menu_b))
w='menus(6)(';rpar=')'
Misc=w(ones(menu_v))+string(1:size(menu_v,'*'))+rpar(ones(menu_v))
 



//viewport
wpar=scs_m(1)
wsiz=wpar(1)
options=wpar(7)

if ~super_block then
  xset('window',0);
  curwin=xget('window');
  palettes=list();
  noldwin=0
  windows=[1 curwin]
  pixmap=xget('pixmap')==1
else
  noldwin=size(windows,1)
  windows=[windows;slevel curwin]
  palettes=palettes;
end

//initialize graphics
xdel(curwin)
xset('window',curwin);

xset('default')
xbasc();
if pixmap then xset('pixmap',1); end
xset('pattern',1)
xset('dashes',1)
if ~set_cmap(options('Cmap')) then // add colors if required
  options('3D')(1)=%f //disable 3D block shape
end
if pixmap then xset('wwpc');end
xbasc();xselect()
dr=driver();driver('Rec');
set_background()

wech=[1100/1085 790/705]  // ration between xset and xget wdim
//wdm=xget('wdim').*wech
wsiz=wpar(1)
xset('wdim',wsiz(1),wsiz(2))
if size(wsiz,'*')<5 then wsiz(5)=wsiz(1);wsiz(6)=wsiz(2);end
xsetech([-1 -1 8 8]/6,[wsiz(3),wsiz(4),wsiz(3)+wsiz(5),wsiz(4)+wsiz(6)])
xset('alufunction',6)



unsetmenu(curwin,'File',1) //clear
unsetmenu(curwin,'File',2) //select
//unsetmenu(curwin,'File',7) //close
unsetmenu(curwin,'File',6) //load
unsetmenu(curwin,'3D Rot.')

execstr('Edit_'+string(curwin)+'=Edit')
execstr('Simulate_'+string(curwin)+'=Simulate')
execstr('Object_'+string(curwin)+'=Object')
execstr('Misc_'+string(curwin)+'=Misc')
execstr('Diagram_'+string(curwin)+'=Diagram')

scs_m(1)(1)(2)=maxi(scs_m(1)(1)(2),450)

//draw diagram and menus
drawobjs(scs_m)

if pixmap then xset('wshow'),end

menubar(curwin,menus)
if ~super_block then
  delmenu(curwin,'stop')
  addmenu(curwin,'stop',list(1,'haltscicos'))
  unsetmenu(curwin,'stop')
else
  unsetmenu(curwin,'Simulate')
end

//set context (variable definition...)
if size(scs_m(1))>4 then 
  if type(scs_m(1)(5))==10 then
    execstr(scs_m(1)(5)) ,
  else
    scs_m(1)(5)=' ' 
  end
end

Cmenu='Open/Set'
while %t
  while %t do
    if Cmenu==[] then
      [btn,xc,yc,win,Cmenu]=getclick()
      pt=[xc,yc]
    end
    if Cmenu<> [] then break,end
  end
  Cmenu1=Cmenu
  select Cmenu
  case 'Exit' then  // OK
    Cmenu=[]
    wdm12=round(xget('wdim').*wech)
    if maxi(abs(scs_m(1)(1)(1:2)-wdm12))>10 then
      scs_m(1)(1)(1)=wdm12(1);scs_m(1)(1)(2)=wdm12(2);
      edited=%t
    end

    do_exit()
    break
  case 'Palettes' then
    Cmenu=[]
    [palettes,windows]=do_palettes(palettes,windows)
  case 'New' then
    Cmenu=[]
    r=1
    if edited then
      r=message(['Diagram has not been saved';
	  'Really exit?'],['Yes';'No'])
    end
    if r==1 then
      if alreadyran then do_terminate(),end  //terminate current simulation
      scs_m=empty_diagram()
      wpar=scs_m(1);wsiz=wpar(1);
      xsetech([-1 -1 8 8]/6,[wsiz(3),wsiz(4),wsiz(3)+wsiz(5),wsiz(4)+wsiz(6)])
      xbasc();drawobjs(scs_m)
      edited=%f
    end
  case 'Smart Move' then  // Move
    xinfo('Click object to move, drag and click (left to fix, right to cancel)')
    scs_m=do_move(scs_m)
    xinfo(' ')
  case 'Move' then  // Move
    xinfo('Click object to move, drag and click (left to fix, right to cancel)')
    scs_m=do_stupidmove(scs_m)
    xinfo(' ')

//    edited=%t
  case 'Copy' then  // Copy
    xinfo('Click on the object to copy, drag, click (left to copy, right to cancel)')
    [scs_m,needcompile]=do_copy(scs_m,needcompile);
    xinfo(' ')
//    edited=%t
  case 'Copy Region' then  // Copy Region
    xinfo('Copy Region: Click, drag region, click (left to fix, right to cancel)')
    [scs_m,needcompile]=do_copy_region(scs_m,needcompile);
    xinfo(' ')
//    edited=%t 
  case 'Replace' then  // Replace
    Cmenu=[]
    xinfo('Click on new object , click on object to be replaced')
    scs_m_save=scs_m;nc_save=needcompile;enable_undo=%t
    [scs_m,needcompile]=do_replace(scs_m,needcompile);
    xinfo(' ')
//    edited=%t
  case 'Align' then
    Cmenu=[]
    xinfo('Click on an a port , click on a port of object to be moved')
    scs_m_save=scs_m;nc_save=needcompile;
    scs_m=prt_align(scs_m)
    xinfo(' ')
//    edited=%t
  case 'Link' then  // Link
    xinfo('Click link origin, drag, click left for final or intermediate points or right to cancel')
    [scs_m,needcompile]=getlink(scs_m,needcompile);
    xinfo(' ')
//    edited=%t
  case 'Delete' then  // Delete
    xinfo('Delete: Click on the object to delete')
    [scs_m,needcompile]=do_delete(scs_m,needcompile);
    xinfo(' ')
//    edited=%t
  case 'Delete Region' then  // Delete region
    xinfo('Delete Region: Click, drag region and click (left to delete, right to cancel)')
    [scs_m,needcompile]=do_delete_region(scs_m,needcompile);
    xinfo(' ')
//    edited=%t
  case 'Flip' then
    Cmenu=[]
    xinfo('Click on block to be flipped')
    scs_m_save=scs_m;nc_save=needcompile;
    scs_m=do_tild(scs_m)
    xinfo(' ')
//    edited=%t
  case 'Undo' then
    Cmenu=[]
    if enable_undo then
      disablemenus()
      scs_m=scs_m_save;needcompile=nc_save
      wpar=scs_m(1)
      wdm=wpar(1)
      do_xsetech(wdm)
      drawobjs(scs_m),
      xset('alufunction',6);
      if pixmap then xset('wshow'),end
      enable_undo=%f
      enablemenus()
    end
  case 'Replot' then
    Cmenu='Open/Set'
    disablemenus()
    xset('alufunction',3);xbasc();xselect();xset('alufunction',6);
    wdm12=round(xget('wdim').*wech)
    scs_m(1)(1)(1)=wdm12(1);scs_m(1)(1)(2)=wdm12(2);
    wdm=scs_m(1)(1)
    xsetech([-1 -1 8 8]/6,[wdm(3),wdm(4),wdm(3)+wdm(5),wdm(4)+wdm(6)])
    drawobjs(scs_m),
    enablemenus()
  case 'Window' then
    Cmenu=[]
    disablemenus()
    wdm12=round(xget('wdim').*wech)
    scs_m(1)(1)(1)=wdm12(1);scs_m(1)(1)(2)=wdm12(2);
    wpar=scs_m(1);wd=wpar(1);
    wpar=do_window(wpar)
    edited=or(wpar<>scs_m(1))
    if or(wd<>wpar(1)) then
      xset('alufunction',3);xbasc();xselect();xset('alufunction',6);
      wd=wpar(1)
      xset('wdim',wd(1),wd(2)),
      wdm12=round(xget('wdim').*wech)
      scs_m(1)(1)(1)=wdm12(1);scs_m(1)(1)(2)=wdm12(2);
      wdm=scs_m(1)(1)
      xsetech([-1 -1 8 8]/6,[wdm(3),wdm(4),wdm(3)+wdm(5),wdm(4)+wdm(6)])
      drawobjs(scs_m),
      if pixmap then xset('wshow'),end
    end
    scs_m(1)=wpar
    enablemenus()
  case 'Setup' then
    Cmenu=[]
    wpar=do_setup(scs_m(1))
    scs_m(1)=wpar
  case 'Context' then
    Cmenu=[]
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
  case 'Compile' then
    Cmenu=[]
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
  case 'Run' then
    Cmenu=[]
    ok=%t
    [ok,tcur,cpr,alreadyran,needcompile,state0]=do_run(cpr)
    if ok then newparameters=list(),end
  case 'Rename' then
    Cmenu=[]
    scs_m=do_rename(scs_m) 
  case 'Save' then
    Cmenu=[]
    wdm12=round(xget('wdim').*wech)
    scs_m(1)(1)(1)=wdm12(1);scs_m(1)(1)(2)=wdm12(2);

    ok=do_save(scs_m) 
    if ok then edited=%f,end
  case 'Save As' then
    wdm12=round(xget('wdim').*wech)
    scs_m(1)(1)(1)=wdm12(1);scs_m(1)(1)(2)=wdm12(2);
    disablemenus()
    Cmenu=[]
    [scs_m,edited]=do_SaveAs()
    enablemenus()
  case 'FSave' then
    wdm12=round(xget('wdim').*wech)
    scs_m(1)(1)(1)=wdm12(1);scs_m(1)(1)(2)=wdm12(2);

    Cmenu=[]
    ok=do_fsave(fscs_m)
    edited=edited&~ok
  case 'Load' then
    Cmenu='Open/Set'
    disablemenus()
    [ok,scs_m,cpr,edited]=do_load()
    if ok then
      wpar=scs_m(1);
      options=wpar(7)
      if ~set_cmap(options('Cmap')) then 
	options('3D')(1)=%f //disable 3D block shape
      end
      wdm=wpar(1)
      xset('alufunction',3);xbasc();xselect();
      xset('wdim',wdm(1),wdm(2))
      if size(wdm,'*')<5 then wdm(5)=wdm(1);wdm(6)=wdm(2);scs_m(1)(1)=wdm;end
      xsetech([-1 -1 8 8]/6,[wdm(3),wdm(4),wdm(3)+wdm(5),wdm(4)+wdm(6)])
      xselect();
      set_background()
      xset('alufunction',6)
      drawobjs(scs_m),
      execstr(scs_m(1)(5)) ,
      if size(cpr)==0 then
	needcompile=4
	alreadyran=%f
      else
	state0=cpr(1)
	needcompile=0
	alreadyran=%f
      end
    end
    enablemenus()
  case 'Purge' then
    Cmenu=[]
    scs_m=do_purge(scs_m);
    needcompile=4;
    edited=%t

  case 'Shift' then
    Cmenu='Open/Set'
    xinfo('Click on the point you want to put in the middle of the window')
    wdm=do_view(scs_m)
    do_xsetech(wdm)
    wpar=scs_m(1)
    scs_m_save=scs_m,nc_save=needcompile,enable_undo=%t,edited=%t
    wpar(1)=wdm;scs_m(1)=wpar
    drawobjs(scs_m),
    xinfo(' ')
    if pixmap then xset('wshow'),end

  case 'Focus' then
    Cmenu='Open/Set'
    xinfo('Select rectangle to focus into')
    wdm=do_focus(scs_m)
    do_xsetech(wdm)
    wpar=scs_m(1)
    scs_m_save=scs_m,nc_save=needcompile,enable_undo=%t,edited=%t
    wpar(1)=wdm;scs_m(1)=wpar
    drawobjs(scs_m),
    xinfo(' ')
    if pixmap then xset('wshow'),end

  case 'Zoom in' then
    Cmenu='Open/Set'
    xinfo('Zoom in')
    wdm=do_zoomin(scs_m)
    do_xsetech(wdm)
    wpar=scs_m(1)
    scs_m_save=scs_m,nc_save=needcompile,enable_undo=%t,edited=%t
    wpar(1)=wdm;scs_m(1)=wpar
    drawobjs(scs_m),
    xinfo(' ')
    if pixmap then xset('wshow'),end

  case 'Zoom out' then
    Cmenu='Open/Set'
    xinfo('Zoom out')
    wdm=do_zoomout(scs_m)
    do_xsetech(wdm)
    wpar=scs_m(1)
    scs_m_save=scs_m,nc_save=needcompile,enable_undo=%t,edited=%t
    wpar(1)=wdm;scs_m(1)=wpar
    drawobjs(scs_m),
    xinfo(' ')
    if pixmap then xset('wshow'),end

  case 'Calc' then
    Cmenu=[]
    xinfo('You may enter any Scilab instruction. enter return to terminate')
    scs_gc=save_scs_gc()
    disablemenus()
    pause
    //xinfo(' ')
    restore_scs_gc(scs_gc);scs_gc=null()
    enablemenus()
  case 'Save as Interf. Func.' then
    Cmenu=[]
    ok=%f
    while ~ok then
      fname=xgetfile('*.sci')
      if fname<>emptystr() then 
	[dir,name,ext]=splitfilepath(fname)
	select ext
	case 'sci' then
	  ok=%t
	else
	  message('Only *.sci files allowed');
	  ok=%f
	end
      else
	ok=%t
      end
    end
    if fname<>emptystr() then
      scs_m(1)(2)(1)=name
      [ok,wh]=getvalue(['Enter path of the directory';
	  'and the type of Interf. Func. to create'],..
	  ['Block(0) or SuperBlock(1)'],list('vec','1'),..
	  ['1'])
      if ok then
	scs_m(1)(2)(1)=name
	if wh==0 then
	  path=save_csuper(scs_m,dir)
	else
	  path=save_super(scs_m,dir)
	end
	if path<>[] then getf(path),end
      end
    end
  case 'Region to Super Block' then
    xinfo(' Click, drag region and click (left to fix, right to cancel)')
    scs_m=do_region2block(scs_m)
  case 'Nyquist' then
    syst=analyse(scs_m)
    sl=bloc2ss(syst)
    xset('window',curwin+1);xbasc()
    nyquist(sl)
    xset('window',curwin);
  case 'Open/Set' then
    xinfo('Click object to open or set')
    k=[]
    while %t 
      [btn,xc,yc,win,Cmenu]=getclick()
      if Cmenu==[] then
	disablemenus()
	if windows(find(win==windows(:,2)),1)==100000 then
	  //click in navigator
	  [Path,k,ok]=whereintree(Tree,xc,yc)
	  if ok&k<>[] then Path($)=null();Path($)=null();end
	  if ~ok then k=[],end
	else
	  k=getobj(scs_m,[xc;yc])
	  Path=k
	end
      else
	break
      end
      if k<>[] then
	super_path=[super_path,k] 
	[o,modified,newparametersb,needcompileb,editedb]=clickin(scs_m(Path))
	if needcompileb==4 then
	  kw=find(windows(:,1)==100000)
	  if kw<>[] then
	    xdel(windows(kw,2))
	    Tree=list()
	  end
	end
	edited=edited|editedb
	super_path($-size(k,2)+1:$)=[]
	if editedb then
	  scs_m_save=scs_m;nc_save=needcompile
	  if ~pal_mode then
	    needcompile=max(needcompile,needcompileb)
	  end
	  scs_m=update_redraw_obj(scs_m,Path,o)
	end

	//note if block parameters have been modified
	if modified&~pal_mode  then
	  model=o(3)
	  newparameters=mark_newpars(k,newparametersb,newparameters)
	end
      end
      enablemenus()
    end
    xinfo(' ')
  case 'Resize' then
    Cmenu=[]
    scs_m_save=scs_m;nc_save=needcompile;enable_undo=%t
    xinfo('Click block to resize')
    scs_m=do_resize(scs_m)
    xinfo(' ')
    edited=%t
  case 'Icon' then
    Cmenu=[]
    xinfo('Click on block to edit its icon')
    scs_m_save=scs_m;nc_save=needcompile;enable_undo=%t
    scs_m=do_block(scs_m)
    xinfo(' ')
    edited=%t
  case 'Icon Editor' then
    Cmenu=[]
    scs_m_save=scs_m;nc_save=needcompile;enable_undo=%t
    disablemenus()
    scs_m=do_icon_edit(scs_m)
    Cmenu=[]
    enablemenus()
    xinfo(' ')
    edited=%t  
  case 'Color' then
    xinfo('Click on object to paint')
    scs_m_save=scs_m;nc_save=needcompile;enable_undo=%t
    scs_m=do_color(scs_m)
    xinfo(' ')
    edited=%t
  case 'Label' then
    Cmenu=[]
    xinfo('Click block to label')
    scs_m_save=scs_m;nc_save=needcompile;enable_undo=%t
    [mod,scs_m]=do_label(scs_m)
    edited=edited|mod
    xinfo(' ')
  case 'Eval' then
    Cmenu=[]
    disablemenus()
    [scs_m,cpr,needcompile,ok]=do_eval(scs_m,cpr)
    if needcompile<>4 then state0=cpr(1),end
    alreadyran=%f
    enablemenus()
  case 'Help' then
    Cmenu=[]
    xinfo('Click on object or menu to get help')
    do_help()
    xinfo(' ')
  case 'Add new block' then
    Cmenu='Open/Set'
    [scs_m,fct]=do_addnew(scs_m)
    if fct<>[] then 
      getf(fct),
      newblocks=[newblocks;fct]
    end
  case 'Pal editor..' then
    Cmenu=[]
    [newblocks,pals_changed]=do_edit_pal()
    if pals_changed then exec('~/scicos_pal.exe',-1),end
  case 'Load as Palette' then
    Cmenu=[]
    [palettes,windows]=do_load_as_palette(palettes,windows)
  case 'Save as Palette' then
    Cmenu=[]
    spmode=pal_mode
    pal_mode=%t
    [scs_m,edited]=do_SaveAs()
    pal_mode=spmode
  case 'FSave as Palette' then
    Cmenu=[]
    spmode=pal_mode
    pal_mode=%t
    ok=do_fsave(scs_m)
    edited=edited&~ok
    pal_mode=spmode
  case 'Background color' then
    Cmenu=[]
    [edited,options]=do_options(scs_m(1)(7),'Background')
    scs_m(1)(7)=options
    if edited then
      scs_m(1)(7)=options
      set_background()
      Cmenu='Replot'
    end
  case 'Default link colors' then
    Cmenu=[]
    [edited,options]=do_options(scs_m(1)(7),'LinkColor')
    scs_m(1)(7)=options,
    if edited then Cmenu='Replot',end
  case 'ID fonts' then
    Cmenu=[]
    [edited,options]=do_options(scs_m(1)(7),'ID')
    scs_m(1)(7)=options
    if edited then Cmenu='Replot',end
  case '3D aspect' then
    Cmenu=[]
    [edited,options]=do_options(scs_m(1)(7),'3D')
    scs_m(1)(7)=options
    if edited then Cmenu='Replot',end
  case 'Add color' then
    Cmenu=[]
    [edited,options]=do_options(scs_m(1)(7),'Cmap')
    if edited then 
      scs_m(1)(7)=options
      set_cmap(options('Cmap'))
      set_background()
      Cmenu='Replot'
    end       
  case 'Get Info' then   
    xinfo('Click on object  to get information on it')
    do_block_info()
    xinfo(' ')
  case 'Set Diagram Info' then
    Cmenu=[]
    [ok,info]=do_set_info(scs_m(1)(10))
    if ok then scs_m(1)(10)=info,end
  case 'Set block ID' then
    xinfo('Click on the object to set ID')
    scs_m = do_ident(scs_m)
    xinfo(' ')
  case 'Navigator' then
    [Tree,windows]=do_navigator(scs_m,windows)
    Cmenu='Open/Set'
  else
    Cmenu=[]
  end
  if pixmap then xset('wshow'),end
end








