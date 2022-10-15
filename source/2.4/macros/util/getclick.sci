function [btn,xc,yc,win,Cmenu]=getclick(flag)
// Copyright INRIA
[lhs,rhs]=argn(0)
Cmenu=[]
if ~or(winsid()==curwin) then  Cmenu='Exit',return,end    
if rhs==1 then
  [btn,xc,yc,win,str]=xclick(flag)
else
  [btn,xc,yc,win,str]=xclick()
end
if btn==-100 then  
  Cmenu='Exit',
  return
end    
if btn==-2 then
  // click in a dynamic menu
  xc=0;yc=0
  execstr('Cmenu='+part(str,9:length(str)-1))
  execstr('Cmenu='+Cmenu)
end



