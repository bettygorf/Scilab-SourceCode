function [stk,txt,top]=%i2sci()
//
//!
// Copyright INRIA
txt=[]
rhs=abs(evstr(op(3)))-2
sto=stk(top);top=top-1
sfrom=stk(top);top=top-1
top=top-rhs+1
s2=stk(top)
if rhs==1 then
  if s2(1)<>':' then
    if sto(3)=='0'|sto(4)=='0' then
      txt=sto(1)+'(1,'+s2(1)+') = '+sfrom(1)+';'
      stk=list(op(2),'-1','?','?',sto(5))
    else
      if (sto(3)=='1'&sto(4)=='1') then //insertion in a scalar
	if sfrom(3)=='1'&sfrom(4)=='1' then
	  txt=sto(1)+'(1,'+s2(1)+') = '+sfrom(1)
	elseif sfrom(3)=='1' then
	  txt=sto(1)+'(1,'+s2(1)+') = '+sfrom(1)
	elseif sfrom(3)<>'?'& sfrom(4)<>'?' then
	  sz=mulf(sfrom(3),sfrom(4))
	  txt=sto(1)+'(1,'+s2(1)+') = matrix('+sfrom(1)+',1,'+sz+')'
	else
	  if ~isname(sfrom(1)) then
	    w=gettempvar()
	    txt=w+' = '+sfrom(1)
	    sfrom(1)=w
	  end
	  sz='size('+sfrom(1)+',''*'')'
	  txt=[txt;sto(1)+'(1,'+s2(1)+') = matrix('+sfrom(1)+',1,'+sz+')']
	end
	stk=list(op(2),'-1','1','?',sto(5))
      elseif (sto(3)=='1'&sto(4)<>'1') then //insertion in a row vector
	if sfrom(3)=='1'&sfrom(4)=='1' then //insert a scalar
	  txt=sto(1)+'('+s2(1)+') = '+sfrom(1)
	elseif sfrom(3)=='1' then //insert a row vector
	  txt=sto(1)+'('+s2(1)+') = '+sfrom(1) 
	elseif sfrom(3)<>'?'& sfrom(4)<>'?' then //insert a matrix with known sizes
	  sz=mulf(sfrom(3),sfrom(4))
	  txt=sto(1)+'('+s2(1)+') = matrix('+sfrom(1)+',1,'+sz+')'
	else
	  if ~isname(sfrom(1)) then
	    w=gettempvar()
	    txt=w+' = '+sfrom(1)
	    sfrom(1)=w
	  end
	  sfrom(1)=sfrom(1)+'(:).''',
	  txt=[txt;sto(1)+'(1,'+s2(1)+') = '+sfrom(1)+';']
	end
	stk=list(op(2),'-1','1','?',sto(5))
      elseif (sto(3)<>'1'&sto(4)=='1') //insertion in a column vector
	if sfrom(3)=='1'&sfrom(4)=='1' then //insert a scalar
	  txt=sto(1)+'('+s2(1)+') = '+sfrom(1)
	elseif sfrom(4)=='1' then //insert a column vector
	  txt=sto(1)+'('+s2(1)+') = '+sfrom(1) 
	elseif sfrom(3)<>'?'& sfrom(4)<>'?' then //insert a matrix with known sizes
	  sz=mulf(sfrom(3),sfrom(4))
	  txt=sto(1)+'('+s2(1)+') = matrix('+sfrom(1)+','+sz+',1)'
	else
	  if ~isname(sfrom(1)) then
	    w=gettempvar()
	    txt=w+' = '+sfrom(1)
	    sfrom(1)=w
	  end
	  sfrom(1)=sfrom(1)+'(:)',
	  txt=sto(1)+'('+s2(1)+',1) = '+sfrom(1)+';'
	end
	stk=list(op(2),'-1','?','1',sto(5))
      else
	e=sto(1)+' = mtlb_i('+sto(1)+','+s2(1)+','+sfrom(1)+')'
	e1=sto(1)+'('+s2(1)+') = '+sfrom(1)
	txt=['//!'+e+' may be replaced by '+e1
	     '//       if '+sto(1)+' is not a  vector'
             '//       or if '+sto(1)+' and '+sfrom(1)+' are both row or column vectors'
	     e]
	stk=list(op(2),'-1','?','?',sto(5))
      end
    end
  else 
    if sto(3)=='0'|sto(4)=='0' then
      if sfrom(4)=='1' then
	txt=sto(1)+' = '+sfrom(1)+';'
      elseif isname(sfrom(1)) then
	txt=sto(1)+' = '+sfrom(1)+'(:);'
      else
	txt=sto(1)+' = '+sfrom(1)+';'+sto(1)+' = '+sto(1)+'(:);'
      end
    else
      txt=sto(1)+'(:) = '+sfrom(1)+';'
    end
    stk=list(op(2),'-1','?','1',sto(5))
  end
else
  s1=stk(top+1)
  txt=sto(1)+rhsargs([s2(1),s1(1)])+' = '+sfrom(1)+';'
  stk=list(op(2),'-1','?','?',sto(5))
end



 



