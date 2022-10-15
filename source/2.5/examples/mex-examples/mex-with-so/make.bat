:begin
if "%1" == "" goto all
if "%1" == "all" goto all
if "%1" == "clean" goto clean
:all
@nmake /f makefile.mak pstarget
nmake /f makefile.mak
goto Ende
:clean
nmake /f makefile.mak clean
goto Ende
:Ende
