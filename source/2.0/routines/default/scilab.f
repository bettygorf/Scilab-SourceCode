      Program main
      character*40 arg,display,pname
      integer nos,now,idisp
      integer p1,p2
      data nos,now,idisp /0,0,0/
      nargs = iargc()
      call fgetarg(0,pname)
      i = 0
 10   continue
      i=i+1
      if (i.gt.nargs) goto 11
      call fgetarg(i,arg)
         if (arg.eq.'-ns') then 
            nos=1
         elseif (arg.eq.'-nw') then 
            now=1
         elseif (arg.eq.'-display') then 
            i=i+1
            call fgetarg(i,display)
            idisp=1
         elseif (arg.eq.'-pipes') then
            i=i+1
            call fgetarg(i,arg)
            read(arg,'(i5)') p1
            i=i+1
            call fgetarg(i,arg)
            read(arg,'(i5)') p2
            call initcom(p1,p2)
         endif
         goto 10
 11      continue
      call mainsci(pname,nos,now,idisp,display)
      end
C     ***********************************************************
      subroutine scilab(nos)
      character*100  bu1
      integer       init,nc,nos
      common /comnos/ nos1
      nos1=nos
      bu1  = ' '
      init = -1
      nc=1
c     initialise 
      call matlab( init, bu1)
      if(nos.eq.0) then
c     get scilab.star path
         call inffic( 2, bu1,nc)
         nc   = max ( 1 , nc )
      endif

      init = -2
      call matlab( init, bu1(1:nc))
c     
      call sciquit
      return
      end

C     ***********************************************************
      subroutine sciquit
      integer nos1
      common /comnos/ nos1
      if(nos1.eq.0) then
         call matlab(-2,'exec(''SCI/scilab.quit'',-1);quit')
      endif
      return
      end
