function [o,modified,newparameters,needcompile]=clickin(o)
//  o             : structure of clicked object, may be modified
//  modified      : boolean, indicates if simulation time parameters 
//                  have been changed
//  newparameters : only defined for super blocks, gives pointers to 
//                  sub-blocks for which parameters or states have been changed
//  needcompile   : indicates if modification implies a new compilation
//!
modified=%f;newparameters=list();needcompile=%f
if o(1)=='Block' then
  model=o(3)
  if model(1)=='super' then
    //wipe menubar
    erasemenubar(datam);
    [frect1,frect]=xgetech()
    wfree=find(windows(:,1)==0)
    lastwin=curwin
    if wfree<>[] then
      curwin=wfree(1)
    else
      curwin=maxi(windows(:,2))+1
    end
    xset('window',curwin)
    execstr('[o_n,needcompile,newparameters]='+o(5)+'(''set'',o)')
    modified=prod(size(newparameters))>0
    
    curwin=lastwin
    xset('window',curwin)
    xselect()
    xsetech(frect1,frect)
    drawmbar(menus,'v');
  elseif model(1)=='csuper' then
    execstr('[o_n,w,newparameters]='+o(5)+'(''set'',o)')
    modified=prod(size(newparameters))>0
    needcompile=%f
  else
    execstr('o_n='+o(5)+'(''set'',o)')
    model=o(3)
    model_n=o_n(3)
    modified=or(model(6)<>model_n(6))|..
	     or(model(7)<>model_n(7))|..
	     or(model(8)<>model_n(8))|..
	     or(model(9)<>model_n(9))
  end
  drawobj(o);
  o=o_n
  drawobj(o);
elseif o(1)=='Link' then
  if size(o)==4 then
    nam=' '
    pos=[0 0]
    color=0
  else
    [nam,pos,ct]=o(5:7)
  end
  [ok,c]=getvalue('couleur',' ',list('vec',1),string(ct(1)))
  if ok then 
    drawobj(o);
    ct(1)=c;
    o(5)=nam;o(6)=pos;o(7)=ct;
    drawobj(o)
  end
elseif o(1)=='Text' then
  execstr('o_n='+o(5)+'(''set'',o)')  
  drawobj(o);
  o=o_n
  drawobj(o);
end
//function r=%supnsup(s1,s2)
//r=%lnl(s1,s2)
