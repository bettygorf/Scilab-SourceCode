REM Makesubdirs.bat all
@echo off
cd graphics
 nmake /f Makefile.mak %1
cd ..
cd calelm
 nmake /f Makefile.mak %1
cd ..
cd comm
 nmake /f Makefile.mak %1
cd ..
cd control
 nmake /f Makefile.mak %1
cd ..
cd default
 nmake /f Makefile.mak %1
cd ..
cd integ
 nmake /f Makefile.mak %1
cd ..
cd interf
 nmake /f Makefile.mak %1
cd ..
cd intersci
 nmake /f Makefile.mak %1
cd ..
cd lapack
 nmake /f Makefile.mak %1
cd ..
cd libcomm
 nmake /f Makefile.mak %1
cd ..
cd metanet
 nmake /f Makefile.mak %1
cd ..
cd optim
 nmake /f Makefile.mak %1
cd ..
cd poly
 nmake /f Makefile.mak %1
cd ..
cd signal
 nmake /f Makefile.mak %1
cd ..
cd sparse
 nmake /f Makefile.mak %1
cd ..
cd sun
 nmake /f Makefile.mak %1
cd ..
cd system
 nmake /f Makefile.mak %1
cd ..
cd system2
 nmake /f Makefile.mak %1
cd ..
cd menusX
 nmake /f Makefile.mak %1
cd ..
cd scicos
 nmake /f Makefile.mak %1
cd ..
cd sound
 nmake /f Makefile.mak %1
cd ..
cd wsci
 nmake /f Makefile.mak %1
cd ..
cd xdr
 nmake /f Makefile.mak %1
cd ..
cd f2c\libI77
 nmake /f Makefile.mak %1
cd ..\..
cd f2c\libF77
 nmake /f Makefile.mak %1
cd ..\..
echo on
