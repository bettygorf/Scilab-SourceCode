//[ok,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11]=getvalue(desc,labels,typ,ini)
//  getvalues - xwindow dialog for data acquisition 
//%Syntax
//  [ok,x1,..,x11]=getvalue(desc,labels,typ,ini)
//%Parameters
//  desc    : column vector of strings, dialog general comment 
//  labels  : n column vector of strings, labels(i) is the label of 
//            the ith required value
//  typ     : list(typ1,dim1,..,typn,dimn)
//            typi : defines the type of the ith required value
//                   if may have the following values:
//                   'mat' : stands for matrix of scalars 
//                   'col' : stands for column vector of scalars
//                   'row' : stands for row vector of scalars
//                   'vec' : stands for  vector of scalars
//                   'str' : stands for string
//                   'lis' : stands for list
//            dimi : defines the size of the ith required value
//                   it must be a integer or a 2-vector of integer
//                    -1 stands for undefined dimension
//  ini     : n column vector of strings, ini(i) gives the suggested
//            response for the ith required value
//  ok      : boolean ,%t if ok button pressed, %f if cancel button pressed
//  xi      : contains the ith required value if ok=%t
//%Description
// getvalues macro encapsulate x_mdialog function with error checking,
// evaluation of numerical response, ...
//%Remarks
// All correct scilab syntax may be used as responses, for matrices 
// and vectors getvalues automatically adds [ ] around the given response
// before numerical evaluation
//%Example
// labels=['magnitude';'frequency';'phase    '];
// [ampl,freq,ph]=getvalue('define sine signal',labels,..
//            list('vec',1,'vec',1,'vec',1),['0.85';'10^2';'%pi/3'])
// 
//%See also
// x_mdialog, x_dialog
//!
[lhs,rhs]=argn(0)
n=prod(size(labels))
if lhs<>n+1 then error(41),end
if size(typ)<>2*n then
  error('typ : list(''type'',[sizes],...)')
end
x1=[];x2=[];x3=[];x4=[];x5=[];x6=[];x7=[];x8=[];x9=[];x10=[];x11=[];
if rhs==3 then  ini=emptystr(n,1),end
ok=%t
while %t do
  str=x_mdialog(desc,labels,ini)
  if str==[] then ok=%f,break,end
  nok=0
  for k=1:n
    select part(typ(2*k-1),1:3)
    case 'mat'
      v=evstr('['+str(k)+']')
      if type(v)<>1 then nok=-k,break,end
      sz=typ(2*k)
      [mv,nv]=size(v)
      ssz=string(sz(1))+' x '+string(sz(2))
      if sz(1)>=0 then if mv<>sz(1) then nok=k,break,end,end
      if sz(2)>=0 then if nv<>sz(2) then nok=k,break,end,end
    case 'vec'
      v=evstr('['+str(k)+']')
      if type(v)<>1 then nok=-k,break,end
      sz=typ(2*k)
      ssz=string(sz(1))
      [nv]=prod(size(v))
      if sz(1)>=0 then if nv<>sz(1) then nok=k,break,end,end
    case 'row'
      v=evstr('['+str(k)+']')
      if type(v)<>1 then nok=-k,break,end
      sz=typ(2*k)
      ssz=string(sz(1))+' x 1'
      [nv,mv]=prod(size(v))
      if mv<>1 then nok=k,break,end,
      if sz(1)>=0 then if nv<>sz(1) then nok=k,break,end,end
    case 'col'
      v=evstr('['+str(k)+']')
      if type(v)<>1 then nok=-k,break,end
      sz=typ(2*k)
      ssz='1 x '+string(sz(1))
      [mv,nv]=prod(size(v))
      if mv<>1 then nok=k,break,end,
      if sz(1)>=0 then if nv<>sz(1) then nok=k,break,end,end
    case 'str'
      v=str(k)
      if type(v)<>10 then nok=-k,break,end
      sz=typ(2*k)
      ssz=string(sz(1))
      [nv]=prod(size(v))
      if sz(1)>=0 then if nv<>1 then nok=k,break,end,end
    case 'lis'
      v=evstr(str(k))
      if type(v)<>15 then nok=-k,break,end
      sz=typ(2*k)
      ssz=string(sz(1))
      [nv]=size(v)
      if sz(1)>=0 then if nv<>sz(1) then nok=k,break,end,end
    else
      error('type non gere :'+typ(2*k-1))
    end
    execstr('x'+string(k)+'=v')
  end
  if nok>0 then 
    x_message(['answer given for  '+labels(nok);
             'has invalid dimension: ';
             'waiting for dimension  '+ssz])
    ini=str
  elseif nok<0 then
    x_message(['answer given for  '+labels(-nok);
             'has incorrect type :'+ typ(-2*nok-1)])
    ini=str
  else
    break
  end 
end


