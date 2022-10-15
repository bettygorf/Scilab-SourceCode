function [stk,txt,top]=sci_find()
// Copyright INRIA
if lhs==1 then
  if stk(top)(3)=='1' then //row vector
    stk=list('find('+stk(top)(1)+')','0','1','?','1')
  elseif stk(top)(4)=='1' then //column vector
    stk=list('find('+stk(top)(1)+')''','0','1','?','1')
  else
    txt=['/'+'/  mtlb_find('+stk(top)(1)+') may be replaced by'
	 '/'+'/  find('+stk(top)(1)+')'' if '+stk(top)(1)+' is not a row vector']
    stk=list('mtlb_find('+stk(top)(1)+')','0','1','?','1')
  end
elseif lhs==2 then
  i=lst(ilst+1)(2)
  j=lst(ilst+2)(2)
  txt='['+j+','+i+'] = find('+stk(top)(1)+');'+i+' = '+i+'(:);'+j+' = '+j+'(:);'
  stk=list(list('?','-2','1','?','1'),list('?','-2','1','?','1'))
else
  i=lst(ilst+1)(2)
  j=lst(ilst+2)(2)
  v=lst(ilst+3)(2)
  temp=gettempvar()
  txt=[temp+' = '+stk(top)(1)+';'
       '['+j+','+i+'] = find('+temp+');'+i+'='+i+'(:);'+j+'='+j+'(:);'
       temp+' = '+temp+'(:)'
       'if '+i+'<>[] then '+v+' = '+temp+'('+i+'+size('+temp+',1)*('+j+'-1)) ;else '+v+' = [],end']
  r=list('?','-2','1','?','1'),
  stk=list(r,r,r)
end
