function update_scicos_pal(path,name,fname)
scicos_pal;
mess=%f
[u,ierr]=file('open','~/.scilab','unknown')
if ierr<>0 then
  message(['It was not possible to read or write your ~/.scilab file';
      'Please check'])
  return
end
txt=[]
startup=read(u,-1,1,'(a)')

if ~or(scicos_pal(:,1)==name&scicos_pal(:,2)==path) then
  t='scicos_pal=[scicos_pal;['+sci2exp(name)+','+sci2exp(fname)+']]'
  if find(startup==t)==[] then txt=[txt;t],mess=%t;end
end

left='getf('''
right=''')'
for k=1:size(newblocks,'*')
  t=left+newblocks(k)+right
  if find(startup==t)==[] then txt=[txt;t];mess=%t;end
end  

if mess then
  txt=dialog(['If you want to add this newly defined';
    'palette for further scilab calls you must add following lines';
    'to your ~/.scilab file.';
    'If you agree I''ll do it for you'],txt)
  if txt<>[] then write(u,txt,'(a)'),end
end
file('close',u)
[u,ierr]=file('open','~/scicos_pal.exe','unknown')
if ierr<>0 then
  message(['It was not possible to read or write your ~/.scicos_pal.exe file';
      'Please check'])
  return
end
if txt==[] then txt=' ',end
write(u,txt,'(a)')
file('close',u)


lf=length(fname)
if part(fname,lf-3:lf)=='.cos' then
  graph=part(fname,1:lf-4)+'.pal'
elseif part(fname,lf-4:lf)=='.cosf' then
  graph=part(fname,1:lf-5)+'.pal'
else
  graph=fname+'.pal'
end
if part(graph,1:4)='SCI/' then 
  graph=getenv('SCI')+'/'+part(graph,5:length(graph))
end
unix_s('\rm -f '+graph')



