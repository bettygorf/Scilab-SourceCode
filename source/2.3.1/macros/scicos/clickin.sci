function [o,modified,newparameters,needcompile]=clickin(o)
//  o             : structure of clicked object, may be modified
//  modified      : boolean, indicates if simulation time parameters
//                  have been changed
//  newparameters : only defined for super blocks, gives pointers to
//                  sub-blocks for which parameters or states have been changed
//  needcompile   : indicates if modification implies a new compilation
//!
modified=%f;newparameters=list();needcompile=0;
if o(1)=='Block' then
  model=o(3)
  if model(1)=='super' then
    //wipe menubar
    erasemenubar(datam);
    [frect1,frect]=xgetech()
    lastwin=curwin
    curwin=get_new_window(windows)
    xset('window',curwin)
    execstr('scs_m_'+string(slevel)+'=scs_m')
    execstr('[o_n,needcompile,newparameters]='+o(5)+'(''set'',o)')
    modified=prod(size(newparameters))>0

    curwin=lastwin
    xset('window',curwin)
    xselect()
    xsetech(frect1,frect)
    drawmbar(menus,'v');
  elseif model(1)=='csuper' then
    execstr('[o_n,needcompile,newparameters]='+o(5)+'(''set'',o)')
    modified=prod(size(newparameters))>0
  else
    execstr('o_n='+o(5)+'(''set'',o)')
    model=o(3)
    model_n=o_n(3)
    modified=or(model(6)<>model_n(6))|..
	     or(model(7)<>model_n(7))|..
	     or(model(8)<>model_n(8))|..
	     or(model(9)<>model_n(9))
    if or(model(2)<>model_n(2))|or(model(3)<>model_n(3)) then  
      // input or output port sizes changed
      needcompile=1
    end
    if or(model(11)<>model_n(11))  then 
      // initexe changed
      needcompile=2
    end
    if or(model(10)<>model_n(10))|or(model(12)<>model_n(12))  then 
      // type 'c','d','z','l' or dep_ut changed
      needcompile=4
    end
  end
  o=o_n
elseif o(1)=='Link' then
  [nam,pos,ct]=o(5:7)
  c=getcolor('Choose a color',ct(1));
  if c<>[] then
    if ct(1)<>c then
      ct(1)=c;
      o(5)=nam;o(6)=pos;o(7)=ct;
    end
  end
elseif o(1)=='Text' then
  execstr('o_n='+o(5)+'(''set'',o)')
  o=o_n
end





