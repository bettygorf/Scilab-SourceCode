function whos()
// Copyright INRIA
[nams,vol]=who('get');
//display defined variable in a long form
typnames=['constant matrix';
    'polynomial'
    ' '
    'boolean'
    'sparse'
    'boolean sparse'
    ' '
    ' '
    ' '
    'string'
    'function'
    ' '
    'compiled function'
    'library'
    'list'
    'tlist']


n=size(nams,1)
write(%io(2),part('Name',1:25)+part('Type',1:20)+part('Size',1:20)+part('Bytes',1:13))
write(%io(2),' ')
for k=1:n
  sz=' '
  execstr('typ=type('+nams(k)+')')
  if typ<=10 then execstr('sz=size('+nams(k)+');'),end
  if typ<=16 then
    typn=typnames(typ)
    if typ==16 then
      execstr('tt='+nams(k)+'(1)')
      select tt(1)
      case 'r' then 
	typn='rational';
	execstr('sz=size('+nams(k)+'(2)+)')
      case 'lss' then 
	typn='state-space'
	execstr('sz=size('+nams(k)+'(''D'')+)')
      else 
	typn=tt
	execstr('sz=size('+nams(k)+')')
      end
    end
  else
    typn='?'
  end
  siz=strcat(string(sz),' by ')
  write(%io(2),part(nams(k),1:25)+part(typn,1:20)+part(siz,1:20)+part(string(vol(k)*8),1:13))
end
