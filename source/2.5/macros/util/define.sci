function define(x)
txt=[]
if x<>'{' then error('define :Incorrect syntax'),end
while %t
  t=''
  while %t
    t1=stripblanks(read(%io(1),1,1,'(a)'))
    if part(t1,1:3)=='-->' then t1=part(t,4:length(t)),end
    ks=strindex(t1,'..')
    if ks==[] then t=t+t1,break,end
    if ks(1)==length(t1)-1 then 
      t=t+part(t1,1:ks(1)-1),
    else
      t=t+t1,break,
    end
  end
  strsubst(t,'''','''''')
  strsubst(t,'""','""""')
  if t=='}' then break,end
  txt=[txt;t]
end
if size(txt,'*')==0 then 
  disp('Empty code, no function defined')
end
h=stripblanks(txt(1))
txt(1)=[]
if part(h,1:9)=='function ' then h=part(h,10:length(h)),end

k=strindex(h,'=')
if k==[] then k=0,end
k1=strindex(h,'(')
if k1<>[] then
  name=stripblanks(part(h,k+1:k1-1))
else
  name=stripblanks(part(h,k+1:length(h)))
end
deff(h,txt)
execstr(name+'=resume('+name+')')


  
