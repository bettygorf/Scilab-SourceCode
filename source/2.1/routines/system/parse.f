      subroutine parse
c     ====================================================================
c     Scilab parsing function
c     ====================================================================
      include '../stack.h'
      parameter (nz1=nsiz-1,nz2=nsiz-2)
      logical compil,eptover
      logical sevents
      external sevents
c     
      logical iflag
      common /basbrk/ iflag
      integer semi,equal,eol,lparen,rparen,colon
      integer blank,comma,left,right,less,great,quote,percen
      integer name,insert
c     
      integer id(nsiz),ans(nsiz),ennd(nsiz),else(nsiz),retu(nsiz)
      integer pts,psym,excnt,p,r
      integer pcount,strcnt,bcount,qcount
c     
      data blank/40/,semi/43/,equal/50/,eol/99/,comma/52/,colon/44/
      data lparen/41/,rparen/42/,left/54/,right/55/,less/59/,great/60/
      data quote/53/,percen/56/
      data name/1/,insert/2/
      data else/236721422,nz1*673720360/, ennd/671946510,nz1*673720360/
      data retu/505220635,nz1*673720360/, ans/672929546,nz1*673720360/
c     
      save job

c
 01   r = 0
      if(pt.gt.0) r=rstk(pt)
      if(ddt.eq.4) then
         write(buf(1:18),'(2i4,2i2,i6)') pt,r,icall,niv,err
         call basout(io,wte,' TOP    pt:'//buf(1:4)//' rstk(pt):'
     +        //buf(5:8)//' icall:'//buf(9:10)//' niv:'//buf(11:12)
     +        //' err:'//buf(13:18))
      endif
c     
      if(icall.eq.5) goto 88
      if(pt.gt.0) goto 86
      if(err.gt.0) goto 98

c     initialisation
c-------------------
 05   sym = eol
      job=0
      if(rio.eq.-1) job=-1
      top = 0
      fin=0
      macr=0
      paus=0
      icall=0
      rio = rte
      lct(3) = 0
      lct(4) = 2
      lpt(1) = 1
      
      if(job.eq.-1) goto 13
c     
 10   if(sym.ne.eol) goto 15
      if(comp(1).eq.0) goto 12
      if(lin(lpt(4)+1).eq.eol) goto 88
c     
c     acquisition d'un nouvelle ligne
c-------------------------------------
 12   continue
      if(lct(4).le.-10) then 
         lct(4)=-lct(4)-11      
      else
         if (mod(lct(4)/2,2).eq.1) then
            call prompt(lct(4)/4)
            lct(1)=0
            if(paus.eq.0.and.rio.eq.rte) then
               if(pt.ne.0) then
                  call msgs(30,0)
                  pt=0
               endif
               if(top.ne.0) then
                  call msgs(31,0)
                  top=0
               endif
            endif
         endif
      endif
 13   continue
      call stsync(1)
      call getlin(job)
      if(fin .eq. -1) then
c     gestion des lignes suite dans le cas "de l'appel par fortran"
         fun=99
         return
      endif
      job=0
      err = 0
c     
c     debut d'un nouveau statement , clause , expr ou command
c------------------------------------------------------------
 15   continue
      if(sevents()) then
         fun=99
         return
      endif 

      r = 0
      if(pt.gt.0) r=rstk(pt)
      if(ddt.eq.4) then
         write(buf(1:20),'(3i4,i2,i6)') pt,r,top,niv,err
         call basout(io,wte,' parse  pt:'//buf(1:4)//' rstk(pt):'
     +        //buf(5:8)//' top:'//buf(9:12)//' niv:'//buf(13:14)
     +        //' err:'//buf(15:20))
      endif
c     
      excnt = 0
      if(.not.iflag) goto 18

c     gestion des pauses
 16   if ( eptover(1,psiz))  goto 98
      pstk(pt)=rio
      ids(2,pt)=top
      rio=rte
      rstk(pt)=701
      iflag=.false.
      fin=2
      if(lct(4).le.-10) then
         fin=-1
         lct(4)=-lct(4)-11 
      endif
c     *call* macro
      goto 88
c     fin des pauses
 17   rio=pstk(pt)
      top=ids(2,pt)
      pt=pt-1
      goto 15

 18   lhs = 1
      call putid(id,ans)
c     
      call getsym
      if (sym.eq.right) call getsym
      if (sym.eq.colon) call getsym
      if (sym.eq.semi .or. sym.eq.comma .or. sym.eq.eol) goto 75
      if (sym.eq.name) goto 20
      if (sym.eq.left) goto 40
      goto 60
c     
c     lhs begins with name
c-------------------------
 20   call comand(syn)
      if (err .gt. 0) goto 98
      if (fun .eq. 99) return
      if (fin .lt. 0) goto 80
      if (fin .eq. 2) goto 88
      if (fin .eq. 3) goto 16
      if (fin .eq. 4) goto 05
      if (fin .gt. 0) goto 75
      rhs = 0
      fin=0
      call funtab(syn,fin,1)
      if (fin .gt. 0) then
c        name est le nom d'une primitive
         if(char1.eq.equal) then
            call putid(ids(1,pt+1),syn)
            call error(25)
            goto 98
         endif
c        name is a function, must be rhs
         goto 60
      endif
c     
c     peek one character ahead
      if (char1.eq.semi .or. char1.eq.comma .or. char1.eq.eol)
     $     call putid(id,syn)
      if (char1 .eq. equal) goto 25
      if (char1 .eq. lparen) goto 30
      goto 60
c     
c     lhs is simple variable
c---------------------------
 25   call putid(id,syn)
      lpts=lpt(2)
      call getsym
      if(char1.eq.equal) then
c     logical equality
         lpt(4)=lpts
         lpt(2)=lpts
         lpt(3)=lpts
         call putid(id,ans)
         char1=blank
         sym=blank
      endif
      call getsym
      goto 60
c     
c     lhs is name(...)
c---------------------
 30   lpt(5) = lpt(4)
      call putid(id,syn)
c     
c     looking for equal
      pcount=0
      strcnt=0
      bcount=0
 31   psym=sym
      call getsym
      if(strcnt.ne.0) then
         if(sym.eq.eol) then
            call error(3)
            goto 98
         endif
         if(sym.eq.quote) then
            qcount=0
 311        qcount=qcount+1
            if(abs(char1).ne.quote) goto 312
            call getsym
            goto 311
 312        continue
            if(2*int(qcount/2).ne.qcount)  strcnt=0
         endif
      else if(sym.eq.lparen) then
         pcount=pcount+1
      else if(sym.eq.rparen) then
         pcount=pcount-1
         if(pcount.lt.0) then
            call error(2)
            goto 98
         endif
      else if(sym.eq.quote) then
         if(.not.(psym.le.blank.or.psym.eq.rparen.or.psym.eq.right
     $        .or.psym.eq.percen.or.psym.eq.quote)) strcnt=1
      else if(sym.eq.left) then
         bcount=bcount+1
      else if(sym.eq.right) then
         bcount=bcount-1
         if(bcount.lt.0) then
            call error(2)
            goto 98
         endif
      else if(pcount.eq.0) then
         if(bcount.ne.0) then
            call error(2)
            goto 98
         endif
         if(sym.eq.equal) then
            if(char1.eq.equal) then
               call getsym
            else
               if(psym.ne.less.or.psym.ne.great)  goto 32
            endif
         endif
         if(sym.eq.eol .or. sym.eq.comma .or. sym.eq.semi) goto 50
      else if(sym.eq.eol) then
         if(bcount.eq.0) then
            call error(3)
            goto 98
         else
            if(lpt(4).eq.lpt(6))  then
               call getlin(1)
               if(err.gt.0) goto 98
            else
               lpt(4)=lpt(4)+1
               call getsym
            endif
         endif
      endif
      goto 31
c     
 32   lpt(4)=lpt(5)
      char1=lparen
      call getsym
 33   call getsym
      excnt = excnt+1
      if ( eptover(1,psiz)) goto 98
      call putid(ids(1,pt), id)
      pstk(pt) = excnt
      rstk(pt) = 702
c     *call* expr
      goto 81
 35   call putid(id,ids(1,pt))
      excnt = pstk(pt)
      pt = pt-1
      if (sym .eq. comma) goto 33
      if (sym .ne. rparen) then
         call error(3)
         if (err .gt. 0) goto 98
      endif
      if (sym .eq. rparen) call getsym
      goto 60
c     
c     multiple lhs
c-----------------
 40   lpt(5) = lpt(4)
      pts = pt
      call getsym
 41   if (sym .ne. name) goto 43
      call putid(id,syn)
      call getsym
      if (sym .eq. right) goto 42
      if (sym .eq. comma) call getsym
      if ( eptover(1,psiz)) goto 98
      lhs = lhs+1
      pstk(pt) = 0
      rstk(pt) = 0
      call putid(ids(1,pt),id)
      goto 41
 42   call getsym
      if (sym .eq. equal) then
         if(char1.eq.equal) goto 43
         goto 60
      endif
 43   lpt(4) = lpt(5)
      pt = pts
      lhs = 1
      sym = left
      char1 = lin(lpt(4)-1)
      call putid(id,ans)
      goto 60
c     
c     
c     lhs is really rhs
c-----------------------
 50   lpt(4)=lpt(5)
      char1=lparen
      sym=name
      call putid(syn,id)
      call putid(id,ans)
c     
c     lhs finished, start rhs
 60   if (sym .eq. equal) call getsym
c     call funtab(id,fin,1)
c     if(fin.ne.0) then
c     call putid(ids(1,pt+1),id)
c     call error(25)
c     return
c     endif
      if ( eptover(1,psiz))  goto 98
      call putid(ids(1,pt),id)
      pstk(pt) = excnt
      rstk(pt) = 703
c     *call* expr
      goto 81
 65   if (sym.eq.semi .or. sym.eq.comma .or. sym.eq.eol) goto 70
      call error(40)
      if (err .gt. 0) goto 98
c     
c     store results
c-------------------
 70   rhs = pstk(pt)
      if(err1.ne.0) goto 73
      if(rhs.eq.0) goto 72
      fin=-3
      call stackg(ids(1,pt))
      if (err .gt. 0) goto 98
      rhs=rhs+2
      pstk(pt)=lhs
      rstk(pt)=704
      fin=insert
c     *call* allops(insert)
      goto 93
 71   lhs=pstk(pt)
 72   call stackp(ids(1,pt),0)
      if (err .gt. 0) goto 98
c     print if required
c----------------------
      if(lct(4).lt.0.or.fin.eq.0) goto 73
      if(sym.ne.semi.and.lct(3).eq.0) then
         call print(ids(1,pt),fin,wte)
      else if(sym.eq.semi.and.lct(3).eq.1) then
         call print(ids(1,pt),fin,wte)
      endif
      if (err .gt. 0) goto 98
c     
 73   pt = pt-1
      lhs = lhs-1
      if (lhs .gt. 0) goto 70
c     
c     finish statement
c---------------------
 75   fin = 0
      p = 0
      r = 0
      if (pt .gt. 0) p = pstk(pt)
      if (pt .gt. 0) r = rstk(pt)
      if (ddt .eq. 4) then
         write(buf(1:22),'(4i4,3i2)') pt,r,p,lpt(1),niv,macr,paus
         call basout(io,wte,
     +        ' finish pt:'//buf(1:4)//' rstk(pt):'//buf(5:8)//
     +        ' pstk(pt):'//buf(9:12)//' lpt(1):'//buf(13:16)//
     +        ' niv:'//buf(17:18)//' macr:'//buf(19:20)//
     +        ' paus:'//buf(21:22))
      endif
      if(err1.ne.0) then
         if(err2.eq.0) err2=err1
         err1=0
         imode=abs(errct/10000)
         if(imode-4*int(imode/4).eq.2) iflag=.true.
      endif
      toperr=top
c     fin instruction
      if(sym.ne.eol) goto 15
c     gestion des points d'arrets dynamiques
      if(wmac.ne.0) then
         call whatln(lpt(1),lpt(2)-1,lpt(6),nlc,l1,ifin)
         
         do 76 ibpt=lgptrs(wmac),lgptrs(wmac+1)-1
            if(lct(8)-nlc.eq.bptlg(ibpt)) then
               call cvname(macnms(1,wmac),buf(1:nlgh),1)
               write(buf(nlgh+2:nlgh+7),'(i5)') lct(8)-nlc
               call msgs(32,0)
               call cvstr(ifin-l1+1,lin(l1),buf,1)
               call basout(io,wte,buf(1:ifin-l1+1))
               iflag=.true.
               goto 77
            endif
 76      continue
      endif
 77   continue
c     
      if(comp(1).ne.0) call seteol
c     fin ligne
      if(int(r/100).ne.8) goto 10
c     fin d'une instruction dans une clause
      if(comp(1).ne.0) then
         k=lpt(6)
         if(lin(k-1).eq.eol.and.lin(k).eq.eol) then
            call error(47)
            if (err .gt. 0) goto 98
         endif
      endif
      if(lpt(4).eq.lpt(6))  then
         call getlin(1)
      else
         lpt(4)=lpt(4)+1
         call getsym
      endif
      goto 15
c     
c     simulate recursion
c-----------------------
 80   icall=0
      call clause
      if (err .gt. 0) goto 98
      goto(81,82,83,93,88,92,15,80,85),icall
      if (pt .le. 0) goto 15
      r = rstk(pt)/100
      goto(81,82,83,93,88,92,95,80,85),r
      goto 99
c     
 81   icall=0
      call expr
      if (err .gt. 0) goto 98
      goto(81,82,83,93,88,92,15,80,85),icall
      r = rstk(pt)/100
      goto(81,82,83,93,88,92,95,80,85),r
      goto 99
c     
 82   icall=0
      call terme
      if (err .gt. 0) goto 98
      goto(81,82,83,93,88,92,15,80,85),icall
      r = rstk(pt)/100
      goto(81,82,83,93,88,92,95,80,85),r
      goto 99
c     
 83   icall=0
      call fact
      if (err .gt. 0) goto 98
      goto(81,82,83,93,88,92,15,80,85),icall
      r = rstk(pt)/100
      goto(81,82,83,93,88,92,95,80,85),r
      goto 99
c     
 85   icall=0
      if(err1.ne.0) then
         if(int(rstk(pt)/100).eq.9) pt=pt-1
         goto 86
      endif
c     compilation matfns: <100*fun rhs lhs fin>
      if (compil(100*fun,rhs,lhs,fin,0)) then 
         if (err.gt.0) goto 98 
         goto 86
      else
c     *call* matfns
         return
      endif
 86   if (err .gt. 0) goto 98
      goto(81,82,83,93,88,92,15,80,85),icall
      r = rstk(pt)/100
      goto(81,82,83,93,88,92,95,80,85),r
      goto 99
      
c     
 88   icall=0
      call macro
      if (err .gt. 0) goto 98
      goto(81,82,83,93,88,92,10,80,85),icall
      r = rstk(pt)/100
      goto(81,82,83,93,88,92,95,80,85,89),r
      goto 99
 89   fun=99
      return
c     
 92   icall=0
      call  run
      if (err .gt. 0) goto 98
      if (fun .eq. 99) return
c     le dernier label sert a gerer le retour de abort
      goto(81,82,83,93,88,92,15,80,85,05),icall
      r = rstk(pt)/100
      goto(81,82,83,93,88,92,95,80,85),r
      goto 99
c     
 93   icall=0
      call allops
      if (err .gt. 0) goto 98
      goto(81,82,83,93,88,92,15,80,85),icall
      r = rstk(pt)/100
      goto(81,82,83,93,88,92,95,80,85),r
      goto 99
c     
 95   goto(17,35,65,71,86) rstk(pt)-700
      goto 99
c     
      
 98   continue
c     recuperation des erreurs
c-----------------------------
      imode=abs(errct)/10000
      imode=imode-4*int(imode/4)
      if(imode.eq.3) then
         fun=99
         return
      endif
c     
c     erreur lors d'un external  (niv) ou d'une compilation (comp)
c     erreur lors d'une pause
      if(pt.ne.0) then
         if(rstk(pt).eq.503.and.rio.eq.rte) then
            comp(1)=0
            goto 12
         endif
      endif
c     erreur dans un external
      if(niv.gt.0) then
         return
      else
c     erreur dans une pause
         comp(1)=0
         goto 05
      endif
c     
 99   call error(22)
      goto 01
c

      end














