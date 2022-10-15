function [stk,txt,top]=sci_meshgrid()
// Copyright INRIA
txt=[]
if rhs==2 then
  X=stk(top-1)(1)
  Y=stk(top)(1)
  txt='// translation of meshgrid('+makeargs([X,Y])+')'

  if ~isname(X) then
    X=gettempvar(1)
    txt=[txt;
	X+'='+stk(top-1)(1)]
  end
  txt=[txt;
      X+'='+X+'(:)''']

  if ~isname(Y) then
    Y=gettempvar(2)
    txt=[txt;
	Y+'='+stk(top)(1)]
  end
  txt=[txt;
      Y+'='+Y+'(:)']
  
  txt=[txt;
      X+'='+X+'(ones('+Y+'(:)),:)'
      Y+'='+Y+'(:,ones('+X+'(1,:)))']
  stk=list(list(X,'0','?','?','1'),list(Y,'0','?','?','1'))
else
  X=stk(top-2)(1)
  Y=stk(top-1)(1)
  Z=stk(top)(1)
  X='mtlb_meshgrid('+makeargs([X,Y,Z])+')'
  stk=list(list(X,'-1','?','?','1'),list(X,'-1','?','?','1'))
end


