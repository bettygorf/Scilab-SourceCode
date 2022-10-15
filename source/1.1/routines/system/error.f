      subroutine error(n)
c ====================================================================
c
c     gestion des erreurs
c
c ====================================================================
c
      include '../stack.h'

      integer iadr,sadr

c
      character mg*9,blh*1,bel*1,line*140
      integer errtyp,n,ll,r,eol
      logical first
      data mg /' !--error'/,blh/' '/,bel/' '/
      data eol/99/
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
c     set bel to ctrl-g if possible
      first=.true.
      num=0
      if(errct.gt.0) then
        num=errct-10000*int(errct/10000)
        imode=errct/10000
       else if(errct.lt.0) then
        num=-1
        imode=-errct/10000
      endif
      imess=imode/4
      imode=imode-4*imess
      errtyp=0
c
      ll=lct(5)
      lunit = wte
      m1=lpt(2)-lpt(1)
      if(m1.lt.1) m1=1
c
      if(imess.ne.0) goto 999
c
      if(macr.eq.0.and.rio.eq.rte) goto 1000
      call whatln(lpt(1),lpt(2),lpt(6),nlc,l1,ifin)
      m=ifin-l1+1
      if(m.gt.ll) then
         l1=max(l1,lpt(2)-ll/2)
         m=min(ifin-l1,ll)
      endif
      m1=lpt(2)-l1
c   ****************
c      if(n.eq.-1) goto 999
c   ****************
      call cvstr(m,lin(l1),line,1)
      call basout(io,lunit,line(1:max(m,1)))
 1000 line=' '
      line(m1+1:m1+9)=mg
      write(line(m1+11:m1+15),'(i5)') n
      line(m1+16:m1+16)=bel
      call basout(io,lunit,line(1:m1+16))
      if(hio.gt.0) call basout(io,hio,line(1:m1+15))
c
      goto (
     +   1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15,
     +  16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
     +  31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45,
     +  46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60,
     +  61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75,
     +  76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90,
     +  91, 92, 93, 94, 95, 96, 97, 98, 99,100,101,102,103,104,105,
     + 106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,
     + 121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,
     + 136,137,138,139,140,141,142,143
     + ),n
      goto 998
c
    1 call basout(io,lunit,'incorrect multiple assignation')
      go to 999
    2 call basout(io,lunit,'invalid factor')
      errtyp=1
      go to 999
    3 call basout(io,lunit,'waiting for right parenthesis')
      errtyp=1
      go to 999
    4 call cvname(ids(1,pt+1),buf,1)
      call basout(io,lunit,'undefined variable : '//buf(1:nlgh))
      go to 999
    5 call basout(io,lunit,'inconsistent column/row dimensions')
      go to 999
    6 call basout(io,lunit,'inconsistent row/column dimensions')
      go to 999
    7 continue
      go to 999
    8 call basout(io,lunit,'inconsistent addition')
      go to 999
    9 call basout(io,lunit,'inconsistent subtraction')
      go to 999
   10 call basout(io,lunit,'inconsistent multiplication')
       go to 999
   11 call basout(io,lunit,'inconsistent right division ')
      go to 999
   12 call basout(io,lunit,'inconsistent left division')
      go to 999
   13 call basout(io,lunit,'redefining permanent variable')
      go to 999
   14 call basout(io,lunit,
     &        'eye variable  undefined in context')
      go to 999
   15 call basout(io,lunit,'submatrix incorrectly defined')
      go to 999
   16 call basout(io,lunit,'incorrect command!')
      errtyp=1
      go to 999
   17 lb = lstk(isiz) - lstk(bot) + 1
      lt = err + lstk(bot)
      call basout(io,lunit,'memory size exceeded!')
      write(buf(1:21),'(3i7)') lb,lt,lstk(isiz)
      call basout(io,lunit,' '//buf(1:7)//' variables'//buf(8:14)//
     &            'intermediate ones'//buf(15:21)//' are available')
      go to 999
   18 call basout(io,lunit,'too many names!')
      go to 999
   19 call basout(io,lunit,
     &           'singular matrix')
      go to 999
   20 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument must be square matrix')
      else
         call basout(io,lunit,
     +        'first argument must be square matrix')
      endif
      go to 999
   21 call basout(io,lunit,'invalid index')
      go to 999
   22 call basout(io,lunit,' recursion problems.Sorry....')
c      call basout(io,lunit,'Veuillez nous transmettre le contexte '//
c     &            'ayant genere l''erreur. Merci')
c      errtyp=1
      go to 999
   23 call basout(io,lunit,
     &     ' 1-, 2- or infinity- norm for numerical matrix only')
      go to 999
   24 call basout(io,lunit,'convergence problem...')
      go to 999
   25 call cvname(ids(1,pt+1),line(1:nlgh),1)
      nl=lnblnk(line(1:nlgh))
      call  basout(io,lunit,
     &     'bad call to primitive :'//line(1:nl))
      go to 999
   26 call basout(io,lunit,
     &     'too complex for scilab! (memory size exceeded)')
      errtyp=1
      pt=min(pt,psiz)
      go to 999
   27 call basout(io,lunit,'division by zero...')
      go to 999
   28 call basout(io,lunit,'empty macro...')
      go to 999
   29 call basout(io,lunit,'matrix is not positive definite')
      go to 999
   30 call basout(io,lunit,'invalid exponent')
      go to 999
   31 call basout(io,lunit,'incorrect string')
      errtyp=1
      go to 999
   32 call basout(io,lunit,'singularity of log or tan function')
      go to 999
   33 call basout(io,lunit,'too many '':''')
      go to 999
   34 call basout(io,lunit,'incorrect clause ')
      errtyp=1
      go to 999
   35 continue
      call cvname(ids(1,pt),buf,1)
      call basout(io,lunit,'error in '//buf(1:nlgh))
      errtyp=1
      go to 999
   36 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument is incorrect here')
      else
         call basout(io,lunit,
     +   'first argument is incorrect')
      endif
      go to 999
   37 call basout(io,lunit,'incorrect macro ')
      go to 999
   38 call basout(io,lunit,'file name incorrect')
      go to 999
   39 call basout(io,lunit,'incorrect number of arguments')
      go to 999
   40 call basout(io,lunit,'waiting for end of command')
      errtyp=1
      go to 999
   41 call basout(io,lunit,'incompatible LHS')
      goto 999
   42 call basout(io,lunit,'incompatible RHS' )
      goto 999
   43 call basout(io,lunit,'not implemented in scilab....')
      goto 999
c
   44 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument is incorrect')
      else
         call basout(io,lunit,
     +        'first argument is incorrect')
      endif
      goto 999
   45 write(buf(1:3),'(i3)') err
      call basout(io,lunit,'null matrix (argument # '//buf(1:3)//')')
      goto 999
   46 call basout(io,lunit,'incorrect syntax')
      errtyp=1
      goto 999
   47 call basout(io,lunit,' end or else is missing...')
      errtyp=1
      goto 999
   48 l1=0
      do 481 i=1,bsiz
      if(buf(i:i).eq.' ') goto 481
      l1=l1+1
      buf(l1:l1)=buf(i:i)
  481 continue
      call basout(io,lunit,
     &     'cannot access this file : '//buf(1:l1))
      goto 999
c
   49 call basout(io,lunit,'incorrect file or format')
      goto 999
   50 call basout(io,lunit,'subroutine not found : '//buf(1:32))
      goto 999
   51 call basout(io,lunit,
     &     'This command cannot cannot be compiled : '//buf(1:nlgh))
      goto 999
   52 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument must be a real matrix')
      else
         call basout(io,lunit,
     +        'argument must be a real matrix')
      endif
      goto 999
   53 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument must be a scalar')
      else
         call basout(io,lunit,
     +        'argument must be a scalar')
      endif
      goto 999
   54 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument must be a polynomial')
      else
         call basout(io,lunit,
     +        'argument must be a polynomial')
      endif
      goto 999
   55 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument must be a character string')
      else
         call basout(io,lunit,
     +        'argument must be a character string')
      endif
      goto 999
   56 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument must be a list')
      else
         call basout(io,lunit,
     +        'argument must be a list')
      endif
      goto 999
   57 call basout(io,lunit,
     +     'problem with comparison symbol...')
      goto 999
   58 continue
      if(rhs.eq.0) then
             call basout(io,lunit,
     &       'macro has no input argument...')
                   else
              call basout(io,lunit,
     &       'incorrect number of arguments in macro call...')
              call basout(io,lunit,'arguments are :')
              call prntid(istk(pstk(pt)),rhs)
      endif
      goto 999
   59 continue
      if(lhs.eq.0) then
         call basout(io,lunit,
     &        'macro has no output')
      else
         call basout(io,lunit,
     &        'incorrect # of outputs in the macro')
         call basout(io,lunit,'arguments are :')
         call prntid(istk(pstk(pt)),lhs)
      endif
      goto 999
   60 call basout(io,lunit,'argument with incompatible dimensions')
      goto 999
   61 call basout(io,lunit,'direct acces : give format')
      goto 999
   62 write(buf(1:8),'(i8)') err
      call basout(io,lunit,'end of file at line '//buf(1:8))
      goto 999
   63 write(buf(1:8),'(i8)') err
      call basout(io,lunit,buf(1:8)//'graphic terminal?')
      goto 999
   64 continue
      call basout(io,lunit,'integration fails')
      goto 999
   65 write(buf(1:8),'(i8)') err
      call basout(io,lunit,buf(1:8)//': logical unit already used')
      goto 999
   66 call basout(io,lunit,'no more logical units available!')
      goto 999
   67 call basout(io,lunit,'unknown file format ')
      goto 999
   68 call inffic( 5, buf, nc)
      nc = max ( 1 , nc )
      call basout(io,lunit,
     +  'fatal error!!! your variables are saved in file :'
     +  //buf(1:nc))
      call basout(io,lunit,' bad call to a scilab function ? check')
      call basout(io,lunit,' ... otherwise send a bug report to : '//
     +     'the Scilab group')
      goto 999
   69 call basout(io,lunit,'floating point exception')
      goto 999
   70 call basout(io,lunit,'too many arguments in fort (max 30)')
      goto 999
   71 call basout(io,lunit,'this variable is not valid in fort')
      goto 999
 72   call cvname(ids(1,pt),buf,1)
      call basout(io,lunit,
     +     buf(1:nlgh)//'is not valid in this context')
      goto 999
   73 call basout(io,lunit,'error while linking')
      goto 999
   74 call basout(io,lunit,'Leading coefficient is zero')
      goto 999
   75 call basout(io,lunit,'Too high degree (max 100)')
      goto 999
   76 continue
      goto 999
   77 continue
      go to 999
   78 continue
      go to 999
   79 continue
      go to 999
   80 write(buf(1:3),'(i3)') err
      call  basout(io,lunit,
     +    ' incorrect function (argument n:'//buf(1:3)//')')
      go to 999
   81 continue
      go to 999
   82 continue
      goto 999
   83 continue
      goto 999
   84 continue
      goto 999
   85 call basout(io,lunit,'host does not answer...')
      goto 999
   86 call basout(io,lunit,'uncontrollable system')
      goto 999
   87 call basout(io,lunit,'unobservable system')
      goto 999
   88 call basout(io,lunit,
     +     'sfact : singular  or assymetric problem')
      goto 999
   89 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument has incorrect dimensions')
      else
         call basout(io,lunit,
     +        'argument has incorrect dimensions')
      endif
      goto 999
 90   if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument must be a transfer matrix')
      else
         call basout(io,lunit,
     +   'argument must be a transfer matrix')
      endif
      go to 999
   91 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument must be in state space form')
      else
         call basout(io,lunit,
     +   'argument must be in state space form')
      endif
      goto 999
   92 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     + 'th argument must be a rational matrix')
      else
         call basout(io,lunit,
     +   'argument must be a rational matrix')
      endif
      goto 999
   93 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument must be in continuous time')
      else
         call basout(io,lunit,
     +   'waiting for continuous time...')
      endif
      goto 999
   94 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument must be in discrete time')
      else
         call basout(io,lunit,
     +   'argument must be in discrete time')
      endif
      goto 999
   95 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//'th argument must '//
     &        'be SISO')
      else
         call basout(io,lunit,'argument must be '//
     &        'SISO')
      endif
      goto 999
   96 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,'time domain of  '//buf(1:3)//
     +        ' th argument is not defined')
      else
         call basout(io,lunit,'time domain of '//
     +        'argument is not defined')
      endif
      goto 999
   97 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,buf(1:3)//
     +        'th argument must be a system ' //
     +        'in state space or transfer matrix form')
      else
         call basout(io,lunit,'input argument must be '//
     &        'a system in state space or transfer matrix form')
      endif
      goto 999
   98 call basout(io,lunit,' variable returned by scilab external '//
     &     'is incorrect')
      goto 999
   99 if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,' elements of '//buf(1:3)//
     &        'th must be in increasing order!')
      else
         call basout(io,lunit,'elements of first'//
     &        ' argument are not (strictly) increasing')
      endif
      goto 999
 100  if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,'the elements of  '//buf(1:3)//
     &        'th argument are not in (strictly) decreasing order')
      else
         call basout(io,lunit,'elements of first '//
     &        'argument are not in (strictly) decreasing order')
      endif
      goto 999
 101  if(err.ne.1) then
         write(buf(1:3),'(i3)') err
         call basout(io,lunit,'last element of '//buf(1:3)//
     &        'th argument <>  first')
      else
         call basout(io,lunit,'last element of first'//
     &        ' argument does not matches the first one')
      endif
      goto 999
 102  call cvname(ids(1,pt+1),line(1:nlgh),1)
      nl=lnblnk(line(1:nlgh))
      nb=lnblnk(buf)
      call basout(io,lunit,'variable or macro '//line(1:nl)//
     +     ' is not in file '//buf(1:nb))
      goto 999
 103  call basout(io,lunit,' variable '//buf(1:nlgh) //
     +     ' is not a valid rational function ')
      goto 999
 104  call basout(io,lunit,' variable '//buf(1:nlgh) //
     +     ' is not a valid state space representation')
      goto 999
 105  call basout(io,lunit,'undefined fonction')
      goto 999
 106  call basout(io,lunit,' fonction name already used')
      goto 999
 107  write(buf(1:3),'(i3)') err
      call basout(io,lunit,'too many functions are defined (maximum #:'
     $     //buf(1:3)//')')
      goto 999
 108  continue
      goto 999
 109  continue
      goto 999
 110  call cvname(ids(1,pt+1),line(1:nlgh),1)
      nl=lnblnk(line(1:nlgh))
      call basout(io,lunit,line(1:nl)//' was a macro when'//
     +     ' compiled but is now a primitive!')
      goto 999
 111  call cvname(ids(1,pt+1),line(1:nlgh),1)
      nl=lnblnk(line(1:nlgh))
      call basout(io,lunit,'trying to re-define  macro '
     +     //line(1:nl))
      goto 999
 112  call basout(io,lunit,
     $     'Cannot allocate more memory')
      goto 999
 113  continue
      goto 999
 114  continue
      goto 999
 115  continue
      goto 999
 116  continue
      goto 999
 117  continue
      goto 999
 118  continue
      goto 999
 119  continue
      goto 999
 120  call basout(io,lunit,'indices for non-zero elements '//
     $     'must be given by a 2 column matrix')
      goto 999
 121  call basout(io,wte,
     $     'incompatible indices for non-zero elements ')
      goto 999
 122  write(buf(1:3),'(i3)') err
      call basout(io,lunit,' logical unit number should be '//
     $     '  larger than '//buf(1:3))
      goto 999
 123  call basout(io,lunit,' fonction not lower bounded')
      goto 999
 124  continue
      goto 999
 125  call basout(io,lunit,' problem may be unbounded :'//
     $     'too high distance between two consecutive iterations')
      goto 999
 126  continue
      goto 999
 127  continue
      goto 999
 128  continue
      goto 999
 129  continue
      goto 999
 130  continue
      call basout(io,wte,
     &     '  optimization fails: back to initial point')
      goto 999
 131  continue
      call basout(io,wte,
     &     ' optim: stop requested by simulator (ind=0)')
      goto 999
 132  continue
      call basout(io,wte,
     &     ' optim: incorrect input parameters')
      goto 999
 133  continue
      call basout(io,wte,' too small memory')
      goto 999
 134  continue
      call basout(io,wte,
     &     'optim: problem with initial constants in simul ')
      goto 999
 135  call basout(io,lunit,
     +     'optim : bounds and initial guess are incompatible')
      goto 999
 136  call basout(io,lunit,'optim : this method is NOT implemented ')
      goto 999
 137  call basout(io,lunit,
     +     'NO hot restart available in this method')
      goto 999
 138  call basout(io,lunit,'optim : incorrect stopping parameters')
      go to 999
 139  call basout(io,lunit,'optim : incorrect bounds')
      go to 999
 140  continue
      go to 999
 141  write(buf(1:3),'(i3)') err
      call  basout(io,lunit,
     +    ' incorrect function (argument n:'//buf(1:3)//')')
      go to 999
 142  write(buf(1:3),'(i3)') err
      call basout(io,lunit,'hot restart : dimension of '//
     &     'working table (argument n:'//buf(1:3)//')')
      go to 999
 143  call basout(io,lunit,
     +   'optim : df0 must be positive !')
      goto 999


c
c
c---------------------------------------------------------------------
 998  continue
c     message d'erreur soft
      call basout(io,lunit,buf(1:80))
c
c     gestion de la recuperation des erreurs
 999  if((num.eq.n.or.num.lt.0).and.imode.ne.0.and.imode.ne.3
     &                         .and.errtyp.eq.0) then
         top=toperr
         if(err2.eq.0) then
            err1=n
         else
            err1=err2
         endif
         err=0
         goto 1010
      else
         comp(1)=0
         err=n
      endif
c
c depilement de l'environnement
      lct(4)=2
      pt=pt+1
 1001 pt=pt-1
      if(pt.eq.0) goto 1010
      r=rstk(pt)
      goto(1002,1002,1004) r-500
      goto 1001
c
c     on depile une macro
 1002 k=lpt(1)-15
      lpt(1)=lin(k+1)
      lpt(2)=lin(k+2)
      lpt(6)=k
c
c     recherche du nom de la macro correspondant a ce niveau
      lk=sadr(lin(k+6))
      if(lk.le.lstk(top+1)) then
         km=0
      else
         km=lin(k+5)-1
      endif
 1003 km=km+1
      if(km.gt.isiz)goto 1013
      if(lstk(km).ne.lk) goto 1003
c
 1013 continue
      ilk=lin(k+6)
      if(istk(ilk).ne.10) then
         if(first) then
            buf='at line '
            m=11
            first=.false.
         else
            buf='line '
            m=6
         endif
         call whatln(lpt(1),lpt(2),lpt(6),nlc,l1,ifin)
         write(buf(m+1:m+5),'(i4)') lct(8)-nlc
         m=m+4
         buf(m+1:m+18)=' of macro     '
         m=m+13
         if (km.le.isiz) call cvname(idstk(1,km),buf(m+1:m+nlgh),1)
         m=m+nlgh
      else
         buf='in  execstr instruction'
         m=26
      endif
      buf(m+1:m+14)=' called by :'
      m=m+14
      call basout(io,lunit,buf(1:m))
      lct(8)=lin(k+14)
c
      call whatln(lpt(1),lpt(2),lpt(6),nlc,l1,ifin)
      m=ifin-l1+1
      if(m.gt.ll) then
         l1=max(l1,lpt(2)-ll/2)
         m=min(ifin-l1,ll)
      endif
       if(l1.gt.0.and.m.gt.0.and.m+l1-1.le.lsiz) then
          call cvstr(m,lin(l1),buf(1:m),1)
          call basout(io,lunit,buf(1:m))
       endif
c
      macr=macr-1
      if(istk(ilk).ne.10) bot=lin(k+5)
      goto 1001
c
c     on depile un exec ou une pause
 1004 if(rio.ne.rte) then
c     exec
         k=lpt(1)-15
         lpt(1)=lin(k+1)
         lpt(2)=lin(k+4)
         lpt(6)=k
c
         if(first) then
            buf='at line '
            m=11
            first=.false.
         else
            buf='line '
            m=6
         endif
         write(buf(m+1:m+5),'(i4)') lct(8)-nlc
         m=m+4
         buf(m+1:m+29)=' of exec file called by :'
         m=m+29
         call basout(io,lunit,buf(1:m))
         lct(8)=lin(k+14)
c
         call whatln(lpt(1),lpt(2),lpt(6),nlc,l1,ifin)
         m=ifin-l1+1
         if(m.gt.ll) then
            l1=max(l1,lpt(2)-ll/2)
            m=min(ifin-l1,ll)
         endif
         call cvstr(m,lin(l1),buf,1)
         call basout(io,lunit,buf(1:m))
         call clunit(-rio,buf,0)
 1005    pt=pt-1
         if(rstk(pt).ne.902) goto 1005
         rio=pstk(pt)
         goto 1001
      else
c     pause
         top=ids(2,pt-1)
         goto 1010
      endif
c
 1010 continue
      call basout(io,lunit,' ')
c
      return
      end