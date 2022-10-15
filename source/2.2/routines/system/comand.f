      subroutine comand(id)
C     ====================================================================
C     Scilab Command execution 
C     ====================================================================
C     id(nsiz) coded name of the comand 
      include '../stack.h'
      logical compil
C     
      integer lunit
C     
      integer cmdl
      parameter (cmdl = 22)
      parameter (nz1 = nsiz-1, nz2 = nsiz-2)
C     
      integer cmd(nsiz,cmdl),a,blank,name
      integer id(nsiz),ennd(nsiz),sel(nsiz),while(nsiz),for(nsiz)
      integer iff(nsiz)
      integer semi,comma,eol,percen,lparen,count
      logical eqid
      integer iadr
C     
      data a/10/
      data eol/99/ semi/43/ comma/52/ lparen/41/
      data blank/40/ name/1/ percen/56/
      data ennd/671946510,nz1*673720360/
      data sel/236260892,673717516,nz2*673720360/
      data while/353505568,673720334,nz2*673720360/
      data iff/673713938,nz1*673720360/
      data for/672864271,nz1*673720360/
C     ------command names--------
C     if        else      for
C     while     end       select
C     case      quit      exit
C     return    help      what
C     who       
C     pause     clear     resume
C               then      do
C     apropos   abort     break
C     elseif
C     
      data ((cmd(i,j), i = 1,nsiz), j = 1,10)/
     &     673713938,nz1*673720360,236721422,nz1*673720360,672864271,
     &     nz1*673720360,353505568,673720334,nz2*673720360,671946510,
     &     nz1*673720360,236260892,673717516,nz2*673720360,236718604,
     &     nz1*673720360,487726618,nz1*673720360,487727374,
     &     nz1*673720360,505220635,673715995,nz2*673720360/
      data ((cmd(i,j), i = 1,nsiz), j = 11,20)/
     &     420810257,nz1*673720360,487199008,nz1*673720360,672665888,
     &     nz1*673720360,471730713,673720334,nz2*673720360,168695052,
     &     673720347,nz2*673720360,505155099,673713686,nz2*673720360,
     &     386797853,nz1*673720360,673716237,nz1*673720360,404429066,
     &     672929817,nz2*673720360,454560522,673720349,nz2*673720360/
      data ((cmd(i,j), i = 1,nsiz), j = 21,22)/
     &     168696587,673720340,nz2*673720360,236721422,673713938,
     &     nz2*673720360/
C     

      iadr(l) = l + l - 1
C     
      if (ddt .eq. 4) then
        call cvname(id,buf,1)
        call basout(io,wte,' comand   : '//buf(1:nlgh))
      endif
C     
      fun = 0
      do 10 k = 1,cmdl
        if (eqid(id,cmd(1,k))) goto 11
 10   continue
      fin = 0
      return
C     
 11   if (fin .eq. -1) return
C     
      fin = 1
C     mots cles if  then else for do  while end case selec
      goto (32,33,30,31,35,36,37) k
      goto (42,42) k-16
C     
      goto (50,50,45,80,65,60,20,25,45,16,16,90,120,130,38) k-7
 16   call error(16)
      if (err .gt. 0) return
C     
C     -----
C     pause
C     -----
C     
 20   continue
      if (char1.ne.eol .and. char1.ne.comma .and. char1.ne.semi) then
        call error(16)
        if (err .gt. 0) return
      endif
C     compilation de pause:<12>
      if (compil(12,0,0,0,0)) return
      fin = 3
      goto 999
C     
C     -----
C     clear
C     -----
C     
 25   continue
      if (comp(1) .ne. 0) then
        call error(51)
        if (err .gt. 0) return
      endif
      ic = abs(char1)
      if (ic.ge.a.and.ic.lt.blank .or. char1.eq.percen) goto 27
      if (char1.ne.eol .and. char1.ne.semi .and. char1.ne.comma) then
        call error(16)
        if (err .gt. 0) return
      endif
      bot = bbot
      if (macr.eq.0 .and. paus.eq.0) goto 998
      k = lpt(1) - (13+nsiz)
      bot = lin(k+5)
      goto 998
C     
 27   call getsym
      if (top+2 .ge. bot) then
        call error(18)
        if (err .gt. 0) return
      endif
      top = top + 1
      il = iadr(lstk(top))
      err = lstk(top) + 1 - lstk(bot)
      if (err .gt. 0) then
        call error(17)
        if (err .gt. 0) return
      endif
      istk(il) = 0
      lstk(top+1) = lstk(top) + 1
      rhs = 0
      call stackp(syn(1),0)
      if (err .gt. 0) return
      if (char1.ne.eol .and. char1.ne.comma .and. char1.ne.semi) goto 27
      fin = 1
      goto 998
C     
C     ---------------------------------------
C     for, while, if, else, end, select, case, elseif
C     ---------------------------------------
C     
 30   fin = -11
      goto 999
 31   fin = -12
      goto 999
 32   fin = -13
      goto 999
 33   fin = -14
      if (pt .eq. 0) then
        goto 42
      elseif (abs(rstk(pt)) .ne. 805) then
        goto 42
      endif
      goto 999
 35   fin = -10
      if (pt .eq. 0) then
        goto 42
      elseif (abs(rstk(pt)).ne.805 .and. abs(rstk(pt)).ne.802 .and.
     &        abs(rstk(pt)).ne.806) then
        goto 42
      endif
      goto 999
 36   fin = -15
      goto 999
 37   fin = -16
      if (pt .eq. 0) then
        goto 42
      elseif (abs(rstk(pt)).ne.805 .or. .not.eqid(ids(1,pt),sel)) then
        goto 42
      endif
      goto 999
 38   fin = -17
      if (pt .eq. 0) then
        goto 42
      elseif (abs(rstk(pt)) .ne. 805) then
        goto 42
      endif
      goto 999
C
 42   call error(34)
      return
C     
C     -------------
C     return/resume
C     -------------
C     
 45   continue
      if (char1 .eq. lparen) then
C     return/resume avec rhs et sans lhs --> fonction et non commande
        fin = 0
        goto 999
      endif
C     compilation return:<99>
      if (compil(99,0,0,0,0)) return
 46   continue
      k = lpt(1) - (13+nsiz)
      if (pt.eq.0 .or. k.le.0) goto 998
      pt = pt + 1
 47   pt = pt - 1
      if (pt .eq. 0) goto 48
      if (rstk(pt).eq.802 .or. rstk(pt).eq.612 .or.
     &    (rstk(pt).eq.805.and.eqid(ids(1,pt),sel)) .or.
     &    (rstk(pt).eq.616.and.pstk(pt).eq.10)) top = top - 1
      ir = rstk(pt) / 100
      if (ir .ne. 5) goto 47
 48   continue
      fin = 2
      lhs = 0
      goto 999
C     
C     -------------
C     fin exit quit
C     -------------
C     
 50   continue
C     compilation quit:<17>
      if (compil(17,0,0,0,0)) return
      if (paus .ne. 0) then
C     quit dans une pause
        paus = paus - 1
        pt = pt + 1
 51     pt = pt - 1
        if (rstk(pt) .ne. 503) goto 51
        k = lpt(1) - (13+nsiz)
        lpt(1) = lin(k+1)
        lpt(2) = lin(k+4)
        lpt(6) = k
        bot = lin(k+5)
        pt = pt - 1
        rio = pstk(pt)
        if (rstk(pt) .eq. 701) pt = pt - 1
        goto 46
      else
C     quit (sortie)
        fun = 99
      endif
      goto 998
C     
C     ---
C     who
C     ---
C     
 60   if (comp(1) .ne. 0) then
        call error(51)
        if (err .gt. 0) return
      endif
      call msgs(38,0)
      call prntid(idstk(1,bot),isiz-bot+1,wte)
      l = lstk(isiz) - lstk(bot) + 1
      write (buf,'(4i7)') l, lstk(isiz)-lstk(1), isiz-bot, isiz-1
      call msgs(39,0)
      goto 998
C     
C     ----
C     what
C     ----
C     
 65   if (comp(1) .ne. 0) then
        call error(51)
        if (err .gt. 0) return
      endif
C     fonctions
C      call msgs(40,0)
      call funtab(id,0,0)
C     comandes
      fin = 1
      call msgs(41,0)
      call prntid(cmd,cmdl,wte)
      goto 998
C     
C     ----
C     help
C     ----
C     
 80   if (comp(1) .ne. 0) then
        call error(51)
        if (err .gt. 0) return
      endif
      call helpmg
      if (err .gt. 0) goto 999
      goto 998
C     
C     ----
C     apropos
C     ----
C     
 90   if (comp(1) .ne. 0) then
        call error(51)
        if (err .gt. 0) return
      endif
      call apropo
      if (err .gt. 0) goto 999
      goto 998
C     
C     abort
C     -----
C     
 120  continue
      if (compil(14,0,0,0,0)) return
C     compilation abort:<14>
      pt = pt + 1
 121  pt = pt - 1
      if (pt .eq. 0) goto 122
      if (int(rstk(pt)/100) .eq. 5) then
        k = lpt(1) - (13+nsiz)
        lpt(1) = lin(k+1)
        lpt(2) = lin(k+2)
        lpt(3) = lin(k+3)
        lpt(4) = lin(k+4)
        lct(4) = lin(k+6)
        lpt(6) = k
        if (rstk(pt) .le. 502) then
c     . abort dans une macro  ou execstr
          if(pt.gt.1) then
             if(rstk(pt-1).ne.903) then
c     .      abort dans une macro
                bot = lin(k+5)
             endif
          else
c     .      abort dans une macro
             bot = lin(k+5)
          endif
        elseif (rstk(pt) .eq. 503) then
          if (rio .eq. rte) then
c     .     abort dans une pause
            rio = pstk(pt-1)
            paus = paus - 1
            bot = lin(k+5)
          else
c     .     abort dans un exec
            call clunit(-rio,buf,0)
            rio = pstk(pt-1)
          endif
        endif
      endif
      goto 121
 122  continue
      lct(8) = 0
      fin = 4
      comp(1) = 0
      if (niv .gt. 0) err = 9999999
      goto 999
C     
C     break
C------
 130  continue
      if (compil(13,0,0,0,0)) return
C     compilation de break:<13>
      count = 0
      pt = pt + 1
 131  pt = pt - 1
      if (pt .eq. 0) then
        pt = 1
        call putid(ids(1,pt),cmd(1,21))
        call error(72)
        return
      endif
C     
      ir = rstk(pt) / 100
c96
      if (ir .eq. 5) then
         call putid(ids(1,pt),cmd(1,21))
         call error(72)
         return
      endif
c
      if (ir .ne. 8) goto 131
      count = count + 1
      if (rstk(pt) .eq. 802) then
C     break dans un for
        top = top - 1
        pt = pt - 2
      elseif(eqid(ids(1,pt),sel)) then
c     discard select variable
         top = top - 1
         goto 131
      elseif (eqid(ids(1,pt),while)) then
C     break dans un while
        pt = pt - 1
      elseif (int(rstk(pt)/100) .eq. 5) then
        call putid(ids(1,pt),cmd(1,21))
        call error(72)
        return
      else
        goto 131
      endif
 132  call getsym
      if (sym .eq. eol) then
C     gestion des clause sur plusieurs lignes
        if (macr.gt.0 .and. lin(lpt(4)+1).eq.eol) then
          call error(47)
          return
        endif
        if (rio.eq.rte .and. macr.eq.0) goto 998
        if (lpt(4) .eq. lpt(6)) then
          call getlin(1)
        else
          lpt(4) = lpt(4) + 1
          char1 = blank
        endif
        goto 132
      endif
      if (sym .ne. name) goto 132
      if (eqid(syn,for) .or. eqid(syn,while) .or. eqid(syn,iff) .or.
     &    eqid(syn,sel)) count = count + 1
      if (.not. eqid(syn,ennd)) goto 132
      count = count - 1
      if (count .gt. 0) goto 132
C      char1=blank
      fin = 1
      return
C     
C     
C     fin
C     ---
C     
 998  continue
      fin = 0
      call getsym
      fin = 1
C     
 999  continue
      lunit = 0
      end

