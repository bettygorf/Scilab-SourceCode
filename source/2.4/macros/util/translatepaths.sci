function translatepaths(Paths,res_path)
// Copyright INRIA
if exists('m2scilib')==0 then load('SCI/macros/m2sci/lib'),end
logfile=%io(2)
Paths=stripblanks(Paths)
for k=1:size(Paths,'*')
  if part(Paths(k),length(Paths(k)))<>'/' then 
    Paths(k)=Paths(k)+'/',
  end
end
for k=1:size(Paths,'*')
  path=Paths(k)
  if getenv('WIN32','NO')=='OK' & getenv('COMPILER','NO')=='VC++' then 
    mfiles=unix_g('dir '+path+'*.m')
  else
    mfiles=unix_g('ls '+path+'*.m')
  end
  for k=1:size(mfiles,1)
    kk=strindex(mfiles(k),'/')
    fnam=part(mfiles(k),kk($)+1:length(mfiles(k))-2)
    
    mpath=mfiles(k)
    scipath=res_path+fnam+'.sci'
    scepath=res_path+fnam+'.sce'
    if newest(mpath,scipath)==mpath then
      if newest(mpath,scepath)==mpath then
	mfile2sci(mpath,res_path,%f,%t)
      end
    end
  end
end
