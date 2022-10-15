      program mainsci
      character*40 arg,display
      character*256 pname 
      integer nos,now,idisp,mem
      integer p1,p2
      common /comnos/nos,mem
      data now,idisp /0,0/
      nos=0
      mem=0
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
      elseif (arg.eq.'-mem') then
         i=i+1
         arg=' '
         call fgetarg(i,arg)
         read(arg,'(i10)') mem
      endif
      goto 10
 11   continue
      mem=max(mem,180000)
      if(now.eq.1) then
         call scilab(nos)
      else
         call winsci(pname,nos,idisp,display)
      endif
      end
