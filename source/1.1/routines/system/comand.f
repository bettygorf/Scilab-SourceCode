      subroutine comand(id) 
c     ====================================================================
c     Scilab Command execution 
c     ====================================================================
c     id(nsiz) coded name of the comand 
      include '../stack.h'
      logical compil
c     
      integer lunit
c     
      integer     cmdl
      parameter ( cmdl=22 )
c     
      integer cmd(nsiz,cmdl),a,d,e,z,lrecl,blank,name
      integer id(nsiz),ennd(nsiz),sel(nsiz),while(nsiz),for(nsiz)
      integer iff(nsiz)
      integer semi,comma,eol,percen,lparen,count
      logical eqid
      integer iadr,sadr
c     
      data a/10/,d/13/,e/14/,z/35/
      data eol/99/,semi/43/,comma/52/,lparen/41/
      data blank/40/,name/1/,percen/56/
      data ennd/671946510,673720360/,sel/236260892,673717516/
      data while/353505568,673720334/,iff/673713938,673720360/
      data for/672864271,673720360/
c     ------command names--------
c     if        else      for
c     while     end       select
c     case      quit      exit
c     return    help      what
c     who       
c     pause     clear     resume
c               then      do
c     apropos   abort     break
c     elseif
c     
      data cmd/
     $    673713938,673720360, 236721422,673720360, 672864271,673720360,
     $    353505568,673720334, 671946510,673720360, 236260892,673717516,
     $    236718604,673720360, 487726618,673720360, 487727374,673720360,
     $    505220635,673715995, 420810257,673720360, 487199008,673720360,
     $    672665888,673720360, 
     $    471730713,673720334, 168695052,673720347, 505155099,673713686,
     $                         386797853,673720360, 673716237,673720360,
     $    404429066,672929817, 454560522,673720349, 168696587,673720340,
     $    236721422,673713938/
c     
      data lrecl/80/
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c     
      if (ddt.eq.4) then
         call cvname(id,buf,1)
         call basout(io,wte,' comand   : '//buf(1:8))
      endif
c     
      fun = 0
      do 10 k = 1, cmdl
         if (eqid(id,cmd(1,k))) go to 11
 10   continue
      fin = 0
      return
c     
 11   if(fin.eq.-1) return
c     
 12   fin = 1
c     mots cles if  then else for do  while end case selec
      goto (32,33,30,31,35,36,37),k
      goto (42,42) k-16
c     
 15   goto(50,50,45,80,65,60,20,25,45,16,16,90,120,130,
     &     38),k-7
 16   call error( 16 )
      if ( err .gt. 0 ) return
c     
c     -----
c     pause
c     -----
c     
 20   continue
      if(char1.ne.eol.and.char1.ne.comma.and.char1.ne.semi) then
         call error(16)
         if(err.gt.0) return
      endif
c     compilation de pause:<12>
      if ( compil(0,12)) return 
      fin=3 
      goto 999
c     
c     -----
c     clear
c     -----
c     
 25   continue
      if(comp(1).ne.0) then
         call error(51)
         if(err.gt.0) return
      endif 
      if(char1.ge.a .and. char1.lt.blank.or.char1.eq.percen) go to 27
      if(char1.ne.eol.and.char1.ne.semi.and.char1.ne.comma) then
         call error(16)
         if(err.gt.0) return
      endif
      bot=bbot
      if(macr.eq.0.and.paus.eq.0) goto 998
      k=lpt(1) - 15
      bot=lin(k+5)
      go to 998
c     
 27   call getsym
      if(top+2.ge.bot) then
         call error(18)
         if(err.gt.0) return
      endif
      top = top+1
      il=iadr(lstk(top))
      err=lstk(top)+1 - lstk(bot)
      if(err.gt.0) then
         call error(17)
         if(err.gt.0) return
      endif
      istk(il)=0
      lstk(top+1)=lstk(top)+1
      rhs = 0
      call stackp(syn(1),0)
      if (err .gt. 0) return
      if(char1.ne.eol.and.char1.ne.comma.and.char1.ne.semi) goto 27
      fin = 1
      go to 998
c     
c     ---------------------------------------
c     for, while, if, else, end, select, case, elseif
c     ---------------------------------------
c     
 30   fin = -11
      go to 999
 31   fin = -12
      go to 999
 32   fin = -13
      go to 999
 33   fin = -14
      if(abs(rstk(pt)).ne.805) goto 42
      go to 999
 35   fin = -10
      if(abs(rstk(pt)).ne.805.and.abs(rstk(pt)).ne.802.and.
     $     abs(rstk(pt)).ne.806) goto 42
      go to 999
 36   fin = -15
      go to 999
 37   fin = -16
      if(abs(rstk(pt)).ne.805.or..not.eqid(ids(1,pt),sel)) goto 42
      go to 999
 38   fin = -17
      if(abs(rstk(pt)).ne.805) goto 42
      go to 999
c
 42   call error(34)
      return
c     
c     -------------
c     return/resume
c     -------------
c     
 45   continue
      if(char1.eq.lparen) then
c     return/resume avec rhs et sans lhs --> fonction et non commande
         fin=0
         goto 999
      endif
c     compilation return:<99>
      if (compil(0,99) ) return 
 46   continue
      k=lpt(1)-15
      if(pt.eq.0.or.k.le.0) goto 998
      pt=pt+1
 47   pt=pt-1
      if(pt.eq.0) goto 48
      if(rstk(pt).eq.802.or.rstk(pt).eq.612 .or.
     &     (rstk(pt).eq.805.and.eqid(ids(1,pt),sel)).or.
     &     (rstk(pt).eq.616.and.pstk(pt).eq.10)) top=top-1
      ir=rstk(pt)/100
      if(ir.ne.5) goto 47
 48   continue
      fin = 2
      lhs=0
      goto 999
c     
c     -------------
c     fin exit quit
c     -------------
c     
 50   continue
c     compilation quit:<17>
      if (compil(0,17)) return 
      if(paus.ne.0) then
c     quit dans une pause
         paus=paus-1
         pt=pt+1
 51      pt=pt-1
         if(rstk(pt).ne.503) goto 51
         k=lpt(1)-15
         lpt(1)=lin(k+1)
         lpt(2)=lin(k+4)
         lpt(6)=k
         bot=lin(k+5)
         pt=pt-1
         rio=pstk(pt)
         if(rstk(pt).eq.701) pt=pt-1
         goto 46
       else
c     quit (sortie)
         fun=99
      endif
      goto 998
c     
c     ---
c     who
c     ---
c     
 60   if(comp(1).ne.0) then
         call error(51)
         if(err.gt.0) return
      endif 
      call msgs(38,0)
      call prntid(idstk(1,bot),isiz-bot+1)
      l = lstk(isiz)-lstk(bot)+1
      write(buf,'(4i7)') l,lstk(isiz),isiz-bot,isiz-1
      call msgs(39,0)
      go to 998
c     
c     ----
c     what
c     ----
c     
 65   if(comp(1).ne.0) then
         call error(51)
         if(err.gt.0) return
      endif 
c     fonctions
c      call msgs(40,0)
      call funtab(id,0,0)
c     comandes
      fin=1
      call msgs(41,0)
      call prntid(cmd,cmdl)
      go to 998
c     
c     ----
c     help
c     ----
c     
 80   if(comp(1).ne.0) then
         call error(51)
         if(err.gt.0) return
      endif 
      call helpmg
      if(err.gt.0) goto 999
      goto 998
c     
c     ----
c     apropos
c     ----
c     
 90   if(comp(1).ne.0) then
         call error(51)
         if(err.gt.0) return
      endif 
      call apropo
      if(err.gt.0) goto 999
      goto 998
c     
c     abort
c     -----
c     
 120  continue
      if (compil(0,14)) return
c     compilation abort:<14>
      pt=pt+1
 121  pt=pt-1
      if(pt.eq.0) goto 122
      if(int(rstk(pt)/100).eq.5) then
         k = lpt(1) - 15
         lpt(1) = lin(k+1)
         lpt(2) = lin(k+2)
         lpt(3) = lin(k+3)
         lpt(4) = lin(k+4)
         lct(4) = lin(k+6)
         lpt(6) = k
         if(rstk(pt).le.502) then
            bot=lin(k+5)
         elseif(rstk(pt).eq.503) then
            if(rio.eq.rte) then
               rio=pstk(pt-1)
               paus=paus-1
               bot=lin(k+5)
            else
               call clunit(-rio,buf,0)
               rio=pstk(pt-1)
            endif
         endif
      endif
      goto 121
 122  continue
      lct(8)=0
      fin = 4
      comp(1)=0
      if(niv.gt.0)  err=9999999
      goto 999
c     
c     break
c------
 130  continue
      if (compil(0,13)) return 
c     compilation de break:<13>
      count=0
      pt=pt+1
 131  pt=pt-1
      if(pt.eq.0) then
         pt=1
         call putid(cmd(1,21),ids(1,pt))
         call error(72)
         return
      endif
c     
      ir=rstk(pt)/100
      if(ir.ne.8) goto 131
      count=count+1
      if(rstk(pt).eq.802) then
c     break dans un for
         top=top-1
         pt=pt-2
      elseif(eqid(ids(1,pt),while)) then
c     break dans un while
         pt=pt-1
      elseif(int(rstk(pt)/100).eq.5) then
         call putid(cmd(1,21),ids(1,pt))
         call error(72)
         return
      else
         goto 131
      endif
 132  call getsym

      if (sym .eq. eol) then
c     gestion des clause sur plusieurs lignes
         if(macr.gt.0.and.lin(lpt(4)+1).eq.eol) then
            call error(47)
            return
         endif
         if(rio.eq.rte.and.macr.eq.0) goto 998
         if(lpt(4).eq.lpt(6))  then
            call getlin(1)
         else
            lpt(4)=lpt(4)+1
            char1=blank
         endif
         goto 132
      endif

      if(sym.ne.name) goto 132
      if (eqid(syn,for) .or. eqid(syn,while) .or.
     $        eqid(syn,iff) .or. eqid(syn,sel)) count = count+1
      if(.not.eqid(syn,ennd)) goto 132
      count=count-1
      if(count.gt.0) goto 132
c      char1=blank
      fin=1
      return
c     
c     
c     fin
c     ---
c     
 998  continue
      fin = 0
      call getsym
      fin = 1
c     
 999  continue
      lunit = 0
      end
