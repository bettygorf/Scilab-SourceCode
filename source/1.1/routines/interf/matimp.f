      subroutine matimp
c ====================================================================
c
c     simulation  de systeme algebrico-differentiel
c
c ====================================================================
c
      INCLUDE '../stack.h'
c
      character*6 namadd,namres,namjac
      common/cadd/namadd
      common/cres/namres
      common/cjac/namjac
      integer iadr,sadr

c
      double precision atol,rtol,t0,t1,tj,tf,tf1
      integer top2,tope,hsize
      logical jaco,type,achaud
      external bresid,badd,bj2
      external fres,fadda,fj2
      integer adams,raide
      
      integer info(15)
      logical hotstart
      double precision tout,tstop,maxstep,stepin
      character*6 namer,namej
      common /dassln/ namer,namej
      external bresd,bjacd
      common/ierode/iero
c     
      data atol/1.d-7/,rtol/1.d-9/
      data adams/10/,raide/27/
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      
      
c     
c     impl     dassl
c     1         2
c     
      if (ddt .eq. 4) then
         write(buf(1:4),'(i4)') fin
         call basout(io,wte,' matimp '//buf(1:4))
      endif
c     
      goto(10,100) fin
c     
 10   if(rhs.lt.6) then
         call error(39)
         return
      endif
      if(lhs.ne.1.and.lhs.ne.3) then
         call error(39)
         return
      endif
c
      iero=0
c     
c     lw=premiere case libre dans la pile
      itype=raide
      tope=top
      lw=lstk(top+1)
      lw1=lw
      lw=lw+16
c     
c     test demarrage a chaud
      ifin=iadr(lstk(top))
      achaud=istk(ifin).eq.1
      if(achaud) then
c     ilc=adresse de  iw
         top=top-2
         il=iadr(lstk(top+2))
         if(istk(il).ne.1) then
            err=rhs-2
            call error(53)
            return
         endif
         liwp=istk(il+2)*istk(il+1)
         lci=sadr(il+4)
         ilc=iadr(lci)
c     lc=adresse de  w
         il=iadr(lstk(top+1))
         if(istk(il).ne.1) then
            err=rhs-1
            call error(53)
            return
         endif
         lc=sadr(il+4)
         lrwp=istk(il+1)*istk(il+2)
      endif
      top2=top-rhs+1
      if(achaud) top2=top2+2
      ile=iadr(lstk(top2))
      type=istk(ile).eq.10
      if(type) then
c     type fourni: mf=10 dans lsodi si adams
         top2=top2+1
         itype=abs(istk(ile+6))
         if(itype.ne.adams.and.itype.ne.raide) then
            call error(42)
            return
         endif
      endif
c     type non fourni methode raide a priori
      ilj=iadr(lstk(top))
      islj=istk(ilj)
      tj=stk(sadr(ilj+4))
      if(islj.lt.10.or.islj.gt.15.or.islj.eq.12) then
         err=rhs-(tope-top)
         call error(44)
         return
      endif
      ilf1=iadr(lstk(top-1))
      islf1=istk(ilf1)
      tf1=stk(sadr(ilf1+4))
      if(islf1.lt.10.or.islf1.gt.15.or.islf1.eq.12) then
         err=rhs-(tope-top)
         call error(44)
         return
      endif
      ilf=iadr(lstk(top-2))
      islf=istk(ilf)
      tf=stk(sadr(ilf+4))
      if(islf.lt.10.or.islf.gt.15.or.islf.eq.12)   then
c     jacobien non fourni
         jaco=.false.
         kytop=top
         jt=2
c     mf= 12 ou 22: jacobien non fourni a lsodi
         if(itype.eq.adams) mf=12
         if(itype.eq.raide) mf=22
         il=iadr(lstk(top))
         kf1=top
         kf=top-1
         jobj=1
         jobf=1
         ilf=ilf1
         islf=islf1
         ilf1=ilj
         islf1=islj
         if(islf.eq.10) jobf=3
      else
c     jacobien fourni
         jaco=.true.
         jt=1
         kytop=top-1
c     mf=21: jacobien fourni a lsodi
         if(itype.eq.adams) mf=11
         if(itype.eq.raide) mf=21
         kjac=top
         kf=top-2
         kf1=top-1
         jobj=0
         jobf=0
         if(islj.ge.11) jobj=1
         if(islj.eq.10) jobj=3
         if(islf.ge.11.and.islf1.ge.11) jobf=1
         if(islf.eq.10.and.islf1.eq.10) jobf=3
         if(jobf.eq.0.or.jobj.eq.0) then
            call error(42)
            return
         endif
      endif
c     jobj et jobf sont initialises
c     jobf et jobj valent 2 ou 3
c     
      if(jobj.eq.3) then
         ncj=istk(ilj+5)-1
         namjac=' '
         call cvstr(ncj,istk(ilj+6),namjac,1)
      endif
c     
      if(jobf.eq.3) then
         ncf=istk(ilf+5)-1
         ncf1=istk(ilf1+5)-1
         namres=' '
         call cvstr(ncf,istk(ilf+6),namres,1)
         namadd=' '
         call cvstr(ncf1,istk(ilf1+6),namadd,1)
      endif
c     
c     jaco,type et mf sont initialises...
c     top2 pointe sur y0
c     
c     y0
      kynew=top2
      il=iadr(lstk(top2))
c     
      if(istk(il).eq.1) then
         hsize=4
         ny=istk(il+1)*istk(il+2)*(istk(il+3)+1)
      elseif(istk(il).eq.2) then
         mn=istk(il+1)*istk(il+2)
         hsize=9+mn
         ny=(istk(il+8+mn)-1)*(istk(il+3)+1)
      else
         err=rhs-(tope-top2)
         call error(44)
         return
      endif
      it=istk(il+3)
      if(it.eq.1) nys2=ny/2
      ly=sadr(il+hsize)
c     
c     y0dot
      top2=top2+1
      kydtop=top2
      il=iadr(lstk(top2))
c     
      if(istk(il).eq.1) then
         lyd=sadr(il+4)
         nny=istk(il+1)*istk(il+2)*(istk(il+3)+1)
      elseif(istk(il).eq.2) then
         mn=istk(il+1)*istk(il+2)
         lyd=iadr(il+9+mn)
         nny=(istk(il+8+mn)-1)*(istk(il+3)+1)
      else
         err=rhs-(tope-top2)
         call error(44)
         return
      endif
      if(nny.ne.ny) then
         call error(60)
         return
      endif
c     
c     t0
      top2=top2+1
      kttop=top2
      il=iadr(lstk(top2))
      if(istk(il).ne.1) then
         err=rhs-(tope-top2)
         call error(53)
         return
      endif
      l=sadr(il+4)
      t0=stk(l)
c     t1
      top2=top2+1
      il=iadr(lstk(top2))
      if(istk(il).ne.1) then
         err=rhs-(tope-top2)
         call error(53)
         return
      endif
      nn=istk(il+1)*istk(il+2)
c     nn=nombre de points demandes
      lt1=sadr(il+4)
c     
c     parametres optionnels rtol et atol
      top2=top2+1
      rtol=1.0d-7
      atol=1.0d-9
      nr=1
      na=1
      jobtol=kytop-top2
c     jobtol=(rien,rtol seul,rtol et atol)
c     
      if(jobtol.eq.1) then
c     tolerances par defaut
         lr=lw
         la=lr+1
         stk(la)=atol
         stk(lr)=rtol
      else
c     rtol fourni
         lr=lw
c     rtol
         il=iadr(lstk(top2))
         if(istk(il).ne.1) then
            err=rhs-(tope-top2)
            call error(53)
            return
         endif
         nr=istk(il+1)*istk(il+2)
         if(nr.ne.1.and.nr.ne.ny) then
            err=rhs-(tope-top2)
            call error(89)
            return
         endif
         lrt=sadr(il+4)
         call dcopy(nr,stk(lrt),1,stk(lr),1)
         la=lr+nr
c     atol
         if(jobtol.eq.2) then
            stk(la)=atol
         else
            top2=top2+1
            il=iadr(lstk(top2))
            if(istk(il).ne.1) then
               err=rhs-(tope-top2)
               call error(53)
               return
            endif
            na=istk(il+1)*istk(il+2)
            if(na.ne.1.and.na.ne.ny) then
               err=rhs-(tope-top2)
               call error(89)
               return
            endif
            lat=sadr(il+4)
            call dcopy(na,stk(lat),1,stk(la),1)
         endif
      endif
c     
      lw=la+na
c     top pointe sur sa valeur a l'entree
c     
      if(nr.eq.1.and.na.eq.1) itol=1
      if(nr.eq.1.and.na.gt.1) itol=2
      if(nr.gt.1.and.na.eq.1) itol=3
      if(nr.gt.1.and.na.gt.1) itol=4
c     
c     parametres supplementaires
      itask=1
      istate=1
      iopt=0
c     
c     demarrage a chaud
c     
      if(achaud) then
         istate=2
c     restauration des commons
         lsavs=lc+lrwp-219
         lsavi=lci+liwp-41
         liwp1=liwp-41
         call rscom1(stk(lsavs),stk(lsavi))
c     restauration du tableau entier
         do 40 k=1,liwp1
            istk(ilc+k-1)=int(stk(lci+k-1))
 40      continue
      endif
c     
c     calcul des pointeurs ili,lyp
c     tableaux  de travail:w reel   debut lw  taille lrw
c     w entier debut ili (pile istk) taille liw entiers
c     lsodi
      if(mf.gt.10) lrw=22+16*ny+ny*ny
      if(mf.gt.20) lrw=22+9*ny+ny*ny
      liw=20+ny
      nsizd=219
      nsizi=41
      if(lhs.gt.1) then
         lrw=lrw+nsizd
         liw=liw+nsizi
      endif
      li=lw+lrw
      ili=iadr(li)
      lyp=li+liw
c     top pointe sur la zone de travail
      top=top+1
      lstk(top+1)=lw+lrw+liw+nn*ny
      err=lstk(top+1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
c     
      if(jaco) then
         ilw1=iadr(lw1)
         istk(ilw1)=3
         istk(ilw1+1)=ilw1+4
         istk(ilw1+2)=ilw1+8
         istk(ilw1+3)=ilw1+12
         istk(ilw1+4)=kf
         istk(ilw1+5)=kttop
         istk(ilw1+6)=kynew
         istk(ilw1+7)=kydtop
         istk(ilw1+8)=kf1
         istk(ilw1+9)=kttop
         istk(ilw1+10)=kynew
         istk(ilw1+11)=kydtop
         istk(ilw1+12)=kjac
         istk(ilw1+13)=kttop
         istk(ilw1+14)=kynew
         istk(ilw1+15)=kydtop
      else
         ilw1=iadr(lw1)
         istk(ilw1)=2
         istk(ilw1+1)=ilw1+3
         istk(ilw1+2)=ilw1+7
         istk(ilw1+3)=kf
         istk(ilw1+4)=kttop
         istk(ilw1+5)=kynew
         istk(ilw1+6)=kydtop
         istk(ilw1+7)=kf1
         istk(ilw1+8)=kttop
         istk(ilw1+9)=kynew
         istk(ilw1+10)=kydtop
      endif
c     
      call xsetf(1)
      call xsetun(wte)
c     
      if(.not.achaud) then
         lc=lw
         ilc=ili
      endif
c     
c     appel de l'integrateur
      do 50 k=1,nn
         t1=stk(lt1+k-1)
c     test sur le type des fonctions fournies
         if(jobf.eq.1) then
            if(jobj.eq.1) then
c     f macro j macro
               call lsodi(bresid,badd,bj2,ny,stk(ly),stk(lyd),t0,t1,
     1              itol,stk(lr),stk(la),itask,istate,iopt,stk(lc),lrw,
     2              istk(ilc),liw,mf)
            else
c     f macro j fortran
               call lsodi(bresid,badd,fj2,ny,stk(ly),stk(lyd),t0,t1,
     1              itol,stk(lr),stk(la),itask,istate,iopt,stk(lc),lrw,
     2              istk(ilc),liw,mf)
            endif
         else
            if(jobj.eq.1) then
c     f fortran j macro 
               call lsodi(fres,fadda,bj2,ny,stk(ly),stk(lyd),t0,t1,
     1              itol,stk(lr),stk(la),itask,istate,iopt,stk(lc),lrw,
     2              istk(ilc),liw,mf)
            else
c     f fortran j fortran
               call lsodi(fres,fadda,fj2,ny,stk(ly),stk(lyd),t0,t1,
     1              itol,stk(lr),stk(la),itask,istate,iopt,stk(lc),lrw,
     2              istk(ilc),liw,mf)
            endif
         endif
         if(err.gt.0) return
         if(istate.lt.0) then
            call error(24)
            return
         endif
         if(it.eq.0) then
            lys=lyp+(k-1)*ny
            call dcopy(ny,stk(ly),1,stk(lys),1)
         else
            lys=lyp+(k-1)*nys2
            call dcopy(nys2,stk(ly),1,stk(lys),1)
            call dcopy(nys2,stk(ly+nys2),1,stk(lys+nn*nys2),1)
         endif
 50   continue
c     
c     sortie des resultats
      ils=iadr(lstk(kynew))
      top=tope-rhs+1
      call icopy(hsize,istk(ils),1,istk(ile),1)
      nel=istk(ile+1)*istk(ile+2)
      istk(ile+2)=istk(ile+2)*nn
      ly=sadr(ile+hsize)
      if(istk(ile).eq.2) ly=sadr(ile+9+nel*nn)
      inc=1
      if(ly.gt.lyp) inc=-1
      call dcopy(ny*nn,stk(lyp),inc,stk(ly),inc)
      lstk(top+1)=ly+ny*nn
      if(istk(ile).eq.2) then
c     on defini la table des pointeurs
         il=ile+7
         do 52 i=2,nn
            do 51 j=1,nel
               istk(il+nel+j+1)=istk(ile+8+j)-1+istk(il+nel+1)
 51         continue
            il=il+nel
 52      continue
      endif
      if(lhs.eq.1) return
c     w
      top=top+1
      il=iadr(lstk(top))
      istk(il)=1
      istk(il+1)=1
      istk(il+2)=lrw
      istk(il+3)=0
      l=sadr(il+4)
      lstk(top+1)=l+lrw
      call dcopy(lrw-nsizd,stk(lc),1,stk(l),1)
      lsvs=l+lrw-nsizd
c     iw
      top=top+1
      il=iadr(lstk(top))
      istk(il)=1
      istk(il+1)=1
      istk(il+2)=liw
      istk(il+3)=0
      l=sadr(il+4)
      lstk(top+1)=l+liw
      do 60 k=1,liw-nsizi
         stk(l+k-1)=dble(istk(ilc+k-1))
 60   continue
      lsvi=l+liw-nsizi
      call svcom1(stk(lsvs),stk(lsvi))
c     fin de impl...
c     
      fin=2
      return
c     
cc    dassl
c     
 100  continue
c     
c     BASILE function : dassl
c     --------------------------
c     [y0 [,hotdata]]=dassl(y0,t0,t1 [,atol,rtol],res [,jac],info..
c     [,hotdata])
      iero=0
      maxord=5
      lbuf = 1
      lw = lstk(top+1)
      l0 = lstk(top+1-rhs)
      if (rhs .lt. 5 .or. rhs .gt.9) then
         call error(39)
         return
      endif
      if (lhs .ne. 2 .and. lhs .ne. 1) then
         call error(41)
         return
      endif
c     checking variable y0 (number 1)
c     
      ky=top-rhs+1
      il1 = iadr(lstk(top-rhs+1))
      if (istk(il1) .ne. 1) then
         err = 1
         call error(53)
         return
      endif
      n1 = istk(il1+1)
      neq=n1
      m1 = istk(il1+2)
      l1 = sadr(il1+4)
      lydot=l1+n1
      info(11)=0
      if (m1 .eq.1) then
         lydot=lw
         lw=lw+n1
         err=lw-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
         info(11)=1
         call dset(n1,0.0d0,stk(lydot),1)
      elseif(m1.ne.2) then
         err = 1
         call error(89)
         return
      else 
         istk(il1+2)=1
      endif
c     checking variable t0 (number 2)
c     
      kt0=top-rhs+2
      il2 = iadr(lstk(top-rhs+2))
      if (istk(il2) .ne. 1) then
         err = 2
         call error(53)
         return
      endif
      if (istk(il2+1)*istk(il2+2) .ne. 1) then
         err = 2
         call error(89)
         return
      endif
      t0 = stk(sadr(il2+4))
c     checking variable t1 (number 3)
c     
      il3 = iadr(lstk(top-rhs+3))
      if (istk(il3) .ne. 1) then
         err = 3
         call error(53)
         return
      endif
      m3 = istk(il3+1)*istk(il3+2)
      nt=m3
      l3 = sadr(il3+4)
c     
c     checking variable atol (number 4)
c     
      iskip=0
      il4 = iadr(lstk(top-rhs+4))
      if (istk(il4) .ne. 1) then
         latol=lw
         lrtol=lw+1
         lw=lw+2
         stk(latol)=atol
         stk(lrtol)=rtol
         info(2)=0
         iskip=iskip+2
         goto 105
      endif
      m4 = istk(il4+1)*istk(il4+2)
      l4 = sadr(il4+4)
      latol=l4
      if(m4.ne.1.and.m4.ne.n1) then
         err=4
         call error(89)
         return
      endif
c     checking variable rtol (number 5)
c     
      il5 = iadr(lstk(top-rhs+5))
      if (istk(il5) .ne. 1) then
         lrtol=lw
         lw=lw+1
         stk(lrtol)=1.0d-7
         info(2)=0
         iskip=iskip+1
         goto 105
      endif
      m5 = istk(il5+1)*istk(il5+2)
      l5 = sadr(il5+4)
      lrtol=l5
      if(m5.ne.m4) then
         call error(60)
         return
      endif
      if(m5.eq.1) then
         info(2)=0
      else
         info(2)=1
      endif
      
c     checking variable res (number 6)
c     
 105  kres=top-rhs+6-iskip
      il6=iadr(lstk(kres))
      if (istk(il6) .eq. 10) then
         if (istk(il6+1)*istk(il6+2) .ne. 1) then
            err = 6
            call error(89)
            return
         endif
         n6 = min(istk(il6+5)-1,6)
         l6 = il6+6
         namer=' '
         call cvstr(n6,istk(l6),namer,1)
      endif
      
      
c     checking variable jac (number 7)
c     
      kjac=top-rhs+7-iskip
      il7=iadr(lstk(kjac))
      if(kjac.eq.top.or.
     $     kjac.eq.top-1.and.istk(iadr(lstk(top))).eq.1) then
         iskip=iskip+1
         info(5)=0
      else
         info(5)=1
         if (istk(il7) .eq. 10) then
            if (istk(il7+1)*istk(il7+2) .ne. 1) then
               err = 7
               call error(89)
               return
            endif
            n7 = min(istk(il7+5)-1,6)
            l7 = il7+6
            namej=' '
            call cvstr(n7,istk(l7),namej,1)
         endif
      endif
c     
c     checking variable info (number 8)
c     
      il8 = iadr(lstk(top-rhs+8-iskip))
      if (istk(il8) .ne. 15) then
         err = 8
         call error(56)
         return
      endif
      n8=istk(il8+1)
      l8=sadr(il8+n8+3)
c     
c     --   subvariable tstop(info) --
      il8e1=iadr(l8+istk(il8+1+1)-1)
      l8e1 = sadr(il8e1+4)
      m8e1 = istk(il8e1+1)*istk(il8e1+2)
      if(m8e1.eq.0) then
         info(4)=0
      else
         info(4)=1
         tstop=stk(l8e1)
      endif
      
c     
c     --   subvariable imode(info) --
      il8e2=iadr(l8+istk(il8+1+2)-1)
      l8e2 = sadr(il8e2+4)
      info(3)=stk(l8e2)
      
c     
c     --   subvariable band(info) --
      il8e3=iadr(l8+istk(il8+1+3)-1)
      m8e3 =istk(il8e3+2)*istk(il8e3+2)
      l8e3 = sadr(il8e3+4)
      if(m8e3.eq.0) then
         info(6)=0
      elseif(m8e3.eq.2) then
         info(6)=1
         ml=stk(l8e3)
         mu=stk(l8e3+1)
      else
         err=8-iskip
         call error(89)
         return
      endif
c     
c     --   subvariable maxstep(info) --
      il8e4=iadr(l8+istk(il8+1+4)-1)
      m8e4 =istk(il8e4+2)*istk(il8e4+2)
      l8e4 = sadr(il8e4+4)
      if(m8e4.eq.0) then
         info(7)=0
      else
         info(7)=1
         maxstep=stk(l8e4)
      endif
      
c     
c     --   subvariable stepin(info) --
      il8e5=iadr(l8+istk(il8+1+5)-1)
      m8e5 =istk(il8e5+2)*istk(il8e5+2)
      l8e5 = sadr(il8e5+4)
      if(m8e5.eq.0) then
         info(8)=0
      else
         info(8)=1
         stepin=stk(l8e5)
      endif
      
c     
c     --   subvariable nonneg(info) --
      il8e6=iadr(l8+istk(il8+1+6)-1)
      l8e6 = sadr(il8e6+4)
      info(10)=stk(l8e6)
c     
c     --   subvariable isest(info) --
      il8e7=iadr(l8+istk(il8+1+7)-1)
      l8e7 = sadr(il8e7+4)
      isest=stk(l8e7)
      if(isest.eq.1) info(11)=1
      
      
      hotstart=.false.
      if(rhs.eq.9-iskip) then
         hotstart=.true.
c     
c     checking variable hotdata (number 9)
c     
         il9 = iadr(lstk(top-rhs+9-iskip))
         if (istk(il9) .ne. 1) then
            err = 9-iskip
            call error(53)
            return
         endif
         m9 = istk(il9+1)*istk(il9+2)
         lhot = sadr(il9+4)
      elseif(rhs.ne.8-iskip) then
         call error(39)
         return
      endif
      
c     
c     cross formal parameter checking
c     not implemented yet
c     
c     cross equal output variable checking
c     not implemented yet
c     
      nn15=0
      lw15=lw
      lw=lw+nn15
      lw17=lw
      lw=lw+nn15
      if(info(6).eq.0) then
C     for the full (dense) JACOBIAN case 
         lrw = 40+(maxord+4)*neq+neq**2
      elseif(info(5).eq.1) then
C     for the banded user-defined JACOBIAN case
         lrw=40+(maxord+4)*neq+(2*ml+mu+1)*neq
      elseif(info(5).eq.1) then
C     for the banded finite-difference-generated JACOBIAN case
         lrw = 40+(maxord+4)*neq+(2*ml+mu+1)*neq+2*(neq/(ml+mu+1)+1)
      endif
      liw=20+neq
      if(.not.hotstart) then
         lrwork=lw
         lw=lrwork+lrw
         liwork=lw
         lw=liwork+sadr(liw)+1
      else
         if(lrw+liw.gt.n9) then
            err=9-iskip
            call error(89)
            return
         endif
         lrwork=l9
         liwork=l9+lrw
         call entier(liw,stk(liwork),istk(iadr(liwork)))
      endif
      err=lw-lstk(bot)
      if (err .gt. 0) then
         call error(17)
         return
      endif
c     
      if(info(4).eq.1) then
         stk(lrwork)=tstop
      endif
      if(info(7).eq.1) then
         stk(lrwork+1)=maxstep
      endif
      if(info(8).eq.1) then
         stk(lrwork+2)=stepin
      endif
      if(info(6).eq.1) then
         istk(iadr(liwork))=ml
         istk(iadr(liwork+1))=mu
      endif
c     structure d'info pour les externals
      top=top+1
      lstk(top)=lw
      ilext=iadr(lw)
      istk(ilext)=2
      istk(ilext+1)=ilext+4
      istk(ilext+2)=ilext+8
      istk(ilext+3)=ilext+12
      istk(ilext+4)=kres
      istk(ilext+5)=neq
      istk(ilext+6)=kt0
      istk(ilext+7)=ky
      istk(ilext+8)=kjac
      istk(ilext+9)=neq
      istk(ilext+10)=kt0
      istk(ilext+11)=ky
      lw=sadr(ilext)+12
      
      
      lw0=lw
      ilyr=iadr(lw)
      istk(ilyr)=1
      istk(ilyr+1)=2*n1+1
      istk(ilyr+3)=0
      lyr=sadr(ilyr+4)
      lyri=lyr-(2*n1+1)
      k=0
      info(1)=0
      if(hotstart) info(1)=1
      info(9)=0
      do 120 i=0,nt-1
         tout=stk(l3+i)
c     
 115     k=k+1
         lyri=lyri+(2*n1+1)
         lw=lyri+(2*n1+1)
         lstk(top+1)=lw
         margin=(k-1)*(2*n1+1)+4
         lw1=lw+margin
         if(lhs.eq.2) lw1=lw1+4+lrw+liw
         if(lw1-lstk(bot).gt.0) then
c     not enough memory
            call msgstxt('Not enough memory to go further')
            k=k-1
            goto 125
         endif
         stk(lyri)=tout
         call dcopy(n1,stk(l1),1,stk(lyri+1),1)
         call dcopy(n1,stk(lydot),1,stk(lyri+n1+1),1)
         l1=lyri+1
         lydot=lyri+n1+1
         call ddassl(bresd,n1,t0,stk(l1),stk(lydot),
     &        stk(lyri),info,stk(lrtol),stk(latol),idid,
     &        stk(lrwork),lrw,istk(iadr(liwork)),liw,stk(lw15),
     &        stk(lw17),bjacd)
         if(err.gt.0)  return
         if(idid.eq.1) then
C     A step was successfully taken in the intermediate-output mode. 
C     The code has not yet reached TOUT.
            stk(lyri)=t0
            info(1)=1
            goto 115
            
         elseif(idid.eq.2) then
C     The integration to TSTOP was successfully completed (T=TSTOP)
            goto 125
            
         elseif(idid.eq.3) then
C     The integration to TOUT was successfully completed (T=TOUT) by 
C     stepping past TOUT. Y,ydot are obtained by interpolation.
            t0=tout
            info(1)=1
            goto 120
            
         elseif(idid.eq.-1) then
C     A large amount of work has been expended (About 500 steps)
            call msgstxt('to many steps necessary to reached next '//
     &           'required time discretization point')
            call msgstxt('Precise discretisation of time vector t '//
     &           'or decrease accuracy')
            stk(lyri)=t0
            goto 125
         elseif(idid.eq.-2) then
C     The error tolerances are too stringent.
            t0=tout
            info(1)=1
            goto 115
c     buf='The error tolerances are too stringent'
c     call error(9982)
c     return
         elseif(idid.eq.-3) then
C     The local error test cannot be satisfied because you specified 
C     a zero component in ATOL and the corresponding computed solution
C     component is zero. Thus, a pure relative error test is impossible 
C     for this component.
            buf='atol and computed test value are zero'
            call error(9983)
            return
         elseif(idid.eq.-6) then
C     repeated error test failures on the last attempted step.
            call msgstxt('A singularity in the solution '//
     &           'may be present')
            goto 125
         elseif(idid.eq.-7) then
C     The corrector could not converge.
            call msgstxt('May be inaccurate or ill-conditioned '//
     &           'JACOBIAN')
            goto 125
         elseif(idid.eq.-8) then
C     The matrix of partial derivatives is singular.
            buf='The matrix of partial derivatives is singular'//
     &           'Some of your equations may be redundant'
            call error(9986)
            return
         elseif(idid.eq.-9) then
C     The corrector could not converge. there were repeated error 
c     test failures in this step.
            call msgstxt('Either ill-posed problem or '//
     &           'discontinuity or singularity encountered')
            goto 125
         elseif(idid.eq.-10) then
            call msgstxt('external ''res'' return many times'//
     &           'with ires=-1')
            goto 125
         elseif(idid.eq.-11) then
C     IRES equal to -2 was encountered  and control is being returned to the
C     calling program.
            buf='error in external ''res'' '
            call error(9989)
            return
         elseif(idid.eq.-12) then
C     DDASSL failed to compute the initial YPRIME.
            buf='dassl failed to compute the initial Ydot.'
            call error(9990)
            return
         elseif(idid.eq.-33) then
C     The code has encountered trouble from which
C     it cannot recover. A message is printed
C     explaining the trouble and control is returned
C     to the calling program. For example, this occurs
C     when invalid input is detected.
            call msgstxt('dassl encountered trouble')
            goto 125
         endif
         t0=tout
         info(1)=1
 120  continue
c     
 125  top=top-rhs-1
      mv=lw0-l0
c     
c     Variable de sortie: y0
c     
      top=top+1
      if(k.eq.0) istk(ilyr+1)=0
      istk(ilyr+2)=k
      lw=lyr+(2*n1+1)*k
      lstk(top+1)=lw-mv
      if(lhs.eq.1) goto 150
      
c     
c     Variable de sortie: rwork
c     
      top=top+1
      ilw=iadr(lw)
      err=lw+4+lrw+liw-lstk(bot)
      if (err .gt. 0) then
         call error(17)
         return
      endif
      istk(ilw)=1
      istk(ilw+1)=lrw+liw
      istk(ilw+2)=1
      istk(ilw+3)=0
      lw=sadr(ilw+4)
      call dcopy(lrw,stk(lrwork),1,stk(lw),1)
      call int2db(liw,istk(iadr(liwork)),1,stk(lw+lrw),1)
      lw=lw+lrw+liw
      lstk(top+1)=lw-mv
c     
c     Remise en place de la pile
 150  call dcopy(lw-lw0,stk(lw0),1,stk(l0),1)
      return
      
c     
      
      end
