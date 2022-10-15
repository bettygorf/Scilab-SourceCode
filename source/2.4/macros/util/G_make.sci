function [res]=G_make(files,objects_or_dll)
// Copyright INRIA
// call make for target files or objects depending 
// on OS and compilers
if getenv('WIN32','NO')=='OK' then 
  if typeof(objects_or_dll)<>'string' then error('G_addinter: objects must be a string');
    return;
  end 
  if getenv('COMPILER','NO')=='VC++' then 
    // scilab was build with VC++ 
    host('nmake /f Makefile.mak '+objects_or_dll);
  else 
    // Scilab was built with gcwin32 
    host('make '+objects_or_dll);
  end
  res=[objects_or_dll];
else 
  host('make '+ strcat(files,' '));
  res=files ;
end 

