//simple ops
if 1==0 then pause,end
if 1<0 then pause,end
if 1<=0 then pause,end
if 1==1 then,else pause,end
if ~(1==1) then pause,end
if 0>1 then pause,end
if 0>=1 then pause,end
if 1<>1 then pause,end
if 0<>1 then,else pause,end
if '1'=='0' then pause,end
if '1'<>'1' then pause,end

%s=poly(0,'s');
if %s==0 then pause,end
if 0==%s then pause,end
if %s==%s then,else pause,end
if %s<>%s then pause,end
if %s==%s+1 then pause,end
if %s+1==%s then pause,end

if 1/%s==0 then pause,end
if 0==1/%s then pause,end
if 1/%s==1/%s then,else pause,end
if 1/%s<>1/%s then pause,end
if 1/%s==1/%s+1 then pause,end
if 1/%s+1==1/%s then pause,end
if 1/%s<>1/%s+1 then , else  pause,end
if 1/%s+1<>1/%s then , else  pause,end

l=list(1,[1 23],'adssa')
l1=list(123,'sdwqqwq')
if l==0 then pause,end
if 0==l then pause,end
if l==l then,else pause,end
if l<>l then pause,end
if l==l1 then pause,end
if l1==l then pause,end
if l<>l1 then , else pause,end
if l1<>l then , else pause,end


if %t&1==2 then pause,end
if %t|1==2 then, else pause,end
if %t&-1==2 then pause,end
if %t|-1==2 then, else pause,end
if 1<2&1==2 then pause,end
if 1<2|1==2 then, else pause,end
if 1<2&-1==2 then pause,end
if 1<2|-1==2 then, else pause,end
if 2>1&1==2 then pause,end
if 2>1|1==2 then, else pause,end
if 2>1&-1==2 then pause,end
if 2>1|-1==2 then, else pause,end
if 1==1&1==2 then pause,end
if 1==1|1==2 then, else pause,end
if 1==1&-1==2 then pause,end
if 1==1|-1==2 then, else pause,end
if 1<>2&1==2 then pause,end
if 1<>2|1==2 then, else pause,end
if 1<>2&-1==2 then pause,end
if 1<>2|-1==2 then, else pause,end

if %t&1>2 then pause,end
if %t|1>2 then, else pause,end
if %t&-1>2 then pause,end
if %t|-1>2 then, else pause,end
if 1<2&1>2 then pause,end
if 1<2|1>2 then, else pause,end
if 1<2&-1>2 then pause,end
if 1<2|-1>2 then, else pause,end
if 2>1&1>2 then pause,end
if 2>1|1>2 then, else pause,end
if 2>1&-1>2 then pause,end
if 2>1|-1>2 then, else pause,end
if 1==1&1>2 then pause,end
if 1==1|1>2 then, else pause,end
if 1==1&-1>2 then pause,end
if 1==1|-1>2 then, else pause,end
if 1<>2&1>2 then pause,end
if 1<>2|1>2 then, else pause,end
if 1<>2&-1>2 then pause,end
if 1<>2|-1>2 then, else pause,end

