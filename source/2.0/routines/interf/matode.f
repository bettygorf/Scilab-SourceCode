      Subroutine  matode
c ====================================================================
c     simulation non lineaire
c ====================================================================
      include '../stack.h'
      integer adr
      common/ls0001/xxxx(219),iiii(39)
      common/lsa001/yyyy(22),jjjj(9)
      common/eh0001/kkkk(2)
      double precision xxxx,yyyy
c
c     commons avec fydot,fjac
c
      character*6 namef,namej,names
      common/cydot/namef
      common/cjac/namej
      common/csurf/names
c     
      integer       iero
      common/ierajf/iero
c
c
      double precision atol,rtol,t0,t1
      integer top1,top2,tope,hsize
      logical jaco,achaud
      external bydot,bjac,bsurf
      integer raide(2),root(2),adams,discre,rgk(2)
      data raide/28,29/,adams/10/,root/27,24/
      data discre/13/,rgk/27,16/
c
      if (ddt .eq. 4) then
         write(buf(1:4),'(i4)') fin
         call basout(io,wte,' matode '//buf(1:4))
      endif
c
      tope=top
      itype=0
      goto ( 90,100,120,130,140) fin
 100  return
c
c     ode
c
 90   continue
      if(rhs.lt.4) then
         call error(39)
         return
      endif
c
c     lw=premiere adresse libre dans la pile
      lw=lstk(top+1)
      lw1=lw
      lw=lw+9
c
c     test demarrage a chaud
      ifin=adr(lstk(top),0)
      achaud=istk(ifin).eq.1
      if(achaud) then
c     ilc=adresse de  iw
         top=top-2
         il=adr(lstk(top+2),0)
         if(istk(il).ne.1) then
            err=rhs
            call error(53)
            return
         endif
         liwp=istk(il+2)*istk(il+1)
         lci=adr(il+4,1)
         ilc=adr(lci,0)
c     lc=adresse de  w
         il=adr(lstk(top+1),0)
         if(istk(il).ne.1) then
            err=rhs-1
            call error(53)
            return
         endif
         lc=adr(il+4,1)
         lrwp=istk(il+1)*istk(il+2)
      endif
c
      top2=top-rhs+1
      if(achaud) top2=top2+2
      ile=adr(lstk(top2),0)
c
      if(istk(ile).eq.10) then
         top2=top2+1
         if(abs(istk(ile+6)).eq.adams) then
c     lsode (adams)
            mf=10
         elseif(abs(istk(ile+6)).eq.raide(1) .and.
     $           abs(istk(ile+7)).eq.raide(2)) then
c     lsode (gear)
            mf=20
         elseif(abs(istk(ile+6)).eq.root(1) .and.
     $           abs(istk(ile+7)).eq.root(2)) then
c     lsodar
            mf=30
         elseif(abs(istk(ile+6)).eq.discre) then
c     ldisc
            mf=40
         elseif(abs(istk(ile+6)).eq.rgk(1) .and.
     $           abs(istk(ile+7)).eq.rgk(2)) then
c     runge-kutta
            mf=50
         else
            call error(42)
            return
         endif
      else
c     lsoda
         mf=0
      endif
c
      if(mf.lt.30) then
         if(lhs.ne.3.and.lhs.ne.1) then
            call error(39)
            return
         endif
      elseif(mf.eq.30) then
         if(lhs.ne.2.and.lhs.ne.4) then
            call error(39)
            return
         endif
      elseif(mf.eq.40.or.mf.eq.50) then
         if(lhs.ne.1) then
            call error(39)
            return
         endif
      endif
c
      top1=top
c
      if(mf.eq.30) then
c     on recupere le simulateur des equations des surfaces
         ilsurf=adr(lstk(top1),0)
         if(istk(ilsurf).ne.10.and.istk(ilsurf).ne.15.and.
     $        istk(ilsurf).ne.11.and.istk(ilsurf).ne.13) then
            err=rhs-(tope-top1)
            call error(80)
            return
         endif
         if(istk(ilsurf).eq.10) then
            namej=' '
            call cvstr(istk(ilsurf+5)-1,istk(ilsurf+6),names,1)
         endif
         ksurf=top1
         top1=top1-1
c     ... et le nombre d'equations
         il=adr(lstk(top1),0)
         if(istk(il).ne.1) then
            err=rhs-(tope-top1)
            call error(53)
            return
         endif
         if(istk(il+1)*istk(il+2).ne.1) then
            err=rhs-(tope-top1)
            call error(89)
            return
         endif
         l=adr(il+4,1)
         nsurf=stk(l)
         top1=top1-1
      else
         ksurf=0
      endif
      
      il=adr(lstk(top1-1),0)
      if(istk(il).eq.10.or.istk(il).eq.15.or.
     $     istk(il).eq.11.or.istk(il).eq.13) then
c     le jacobien est  fourni (il est defini par la variable top1)
         ilj=adr(lstk(top1),0)
         islj=istk(ilj)
         if(islj.lt.10.or.islj.gt.15.or.islj.eq.12) then
            err=rhs-(tope-top1)
            call error(80)
            return
         endif
         if(islj.eq.10) then
            namej=' '
            call cvstr(istk(ilj+5)-1,istk(ilj+6),namej,1)
         endif
         if(mf.eq.20) mf=21
         jaco=.true.
         kjac=top1
         jt=1
         top1=top1-1
      else
c     jacobien non fourni
         if(mf.eq.20) mf=22
         jaco=.false.         
         kjac=0
         jt=2
      endif
      kytop=top1

c
c     membre de droite
      ilf=adr(lstk(top1),0)
      islf=istk(ilf)
      if(islf.ne.10.and.islf.ne.15.and.islf.ne.11.and.islf.ne.13) then
         err=rhs-(tope-top1)
         call error(80)
         return
      endif
      kydot=top1
      if(islf.eq.10) then
         namef=' '
         call cvstr(istk(ilf+5)-1,istk(ilf+6),namef,1)
      endif
c
c     jaco,type et mf sont initialises...
c     top2 pointe sur y0
c
c     y0
      kynew=top2
      il=adr(lstk(top2),0)
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
      ly=adr(il+hsize,1)
c
c     t0
      top2=top2+1
      kttop=top2
      il=adr(lstk(top2),0)
      if(istk(il).ne.1) then
         err=rhs-(tope-top2)
         call error(53)
         return
      endif
      l=adr(il+4,1)
      t0=stk(l)
c     t1
      top2=top2+1
      il=adr(lstk(top2),0)
      if(istk(il).ne.1) then
         err=rhs-(tope-top2)
         call error(53)
         return
      endif
      nn=istk(il+1)*istk(il+2)
c     nn=nombre de points demandes
      lt1=adr(il+4,1)
c
c     parametres optionnels rtol et atol
      top2=top2+1
      rtol=1.0d-7
      atol=1.0d-9
      nr=1
      na=1
      jobtol=kytop-top2+1
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
         il=adr(lstk(top2),0)
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
         lrt=adr(il+4,1)
         call dcopy(nr,stk(lrt),1,stk(lr),1)
         la=lr+nr
c     atol
         if(jobtol.eq.2) then
            stk(la)=atol
         else
            top2=top2+1
            il=adr(lstk(top2),0)
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
            lat=adr(il+4,1)
            call dcopy(na,stk(lat),1,stk(la),1)
         endif
      endif
      lw=la+na
c     top pointe sur sa valeur a l'entree
      if(achaud) top=top+2
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
         if(mf.eq.0) then
            lsavs=lc+lrwp-241
            lsavi=lci+liwp-50
            liwp1=liwp-50
            call rscma1(stk(lsavs),stk(lsavi))
         elseif(mf.lt.30) then
            lsavs=lc+lrwp-219
            lsavi=lci+liwp-41
            liwp1=liwp-41
            call rscom1(stk(lsavs),stk(lsavi))
         else
            lsavs=lc+lrwp-246
            lsavi=lci+liwp-59
            liwp1=liwp-59
            call rscar1(stk(lsavs),stk(lsavi))
         endif
c     restauration du tableau entier
         do 40 k=1,liwp1
            istk(ilc+k-1)=int(stk(lci+k-1))
 40      continue
      endif
c
c     calcul des pointeurs ili,lyp
c     tableaux  de travail:w reel   debut lw  taille lrw
c     w entier debut ili (pile istk) taille liw entiers
      if(mf.eq.0) then
c     lsoda
         lrw=22+ny*max(16,ny+9)
         liw=20+ny
         nsizd=241
         nsizi=50
      elseif(mf.lt.30) then
c     lsode
         if(mf.eq.10) lrw=20+16*ny
         if(mf.gt.10) lrw=22+9*ny+ny*ny
         liw=20+ny
         nsizd=219
         nsizi=41
      elseif(mf.eq.30) then
c     lsodar
         ilroot=adr(lw,0)
         lw=adr(ilroot+nsurf,1)
         lrw= 22 + ny * max(16, ny + 9) + 3*nsurf
         liw=20+ny
         nsizd=246
         nsizi=59
      elseif(mf.eq.40) then
c     lsdisc
         lrw=ny
         liw=1
      elseif(mf.eq.50) then
c     lsrgk
         lrw=3*ny
         liw=1
      endif
c     on demande w et iw en sortie
      if(lhs.gt.1) then
         lrw=lrw+nsizd
         liw=liw+nsizi
      endif
c
      li=lw+lrw
      ili=adr(li,0)
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
      call xsetf(1)
      call xsetun(wte)
c
      if(.not.achaud) then
         lc=lw
         ilc=ili
      endif
c
c     definition de la structure de donne relative aux  pointeurs pour 
c     les externals
c
      ilw1=adr(lw1,0)
      istk(ilw1)=3
      istk(ilw1+1)=ilw1+4
      istk(ilw1+2)=ilw1+7
      istk(ilw1+3)=ilw1+10
      istk(ilw1+4)=kydot
      istk(ilw1+5)=kttop
      istk(ilw1+6)=kynew
      istk(ilw1+7)=kjac
      istk(ilw1+8)=kttop
      istk(ilw1+9)=kynew
      istk(ilw1+10)=ksurf
      istk(ilw1+11)=kttop
      istk(ilw1+12)=kynew
c     
      do 50 k=1,nn
         t1=stk(lt1+k-1)
         if(mf.eq.0) then
            call lsoda(bydot,ny,stk(ly),t0,t1,itol,stk(lr),
     1           stk(la),itask,istate,iopt,stk(lc),lrw,istk(ilc),
     2           liw,bjac,jt)
         elseif(mf.lt.30) then
            call lsode(bydot,ny,stk(ly),t0,t1,itol,stk(lr),
     1           stk(la),itask,istate,iopt,stk(lc),lrw,istk(ilc),
     2           liw,bjac,mf)
         elseif(mf.eq.30) then
            call lsodar(bydot,ny,stk(ly),t0,t1,itol,stk(lr),
     1           stk(la),itask,istate,iopt,stk(lc),lrw,istk(ilc),
     2           liw,bjac,jt,bsurf,nsurf,istk(ilroot))
         elseif(mf.eq.40) then
            call lsdisc(bydot,ny,stk(ly),t0,t1, stk(lc),lrw,
     1           istate)
         elseif(mf.eq.50) then
            call lsrgk(bydot,ny,stk(ly),t0,t1,itol,stk(lr),
     1           stk(la),itask,istate,iopt,stk(lc),lrw,istk(ilc),
     2           liw,bjac,mf)
         endif         
         if(err.gt.0) return
         if(istate.lt.0) then
            call msgs(4,ierr)
            nn=k-1
            goto 500
         endif
         if(it.eq.0) then
            lys=lyp+(k-1)*ny
            call dcopy(ny,stk(ly),1,stk(lys),1)
         else
            lys=lyp+(k-1)*nys2
            call dcopy(nys2,stk(ly),1,stk(lys),1)
            call dcopy(nys2,stk(ly+nys2),1,stk(lys+nn*nys2),1)
         endif
         if(mf.eq.30.and.istate.eq.3) then
            nn=k
            goto 500
         endif
 50   continue
 500  continue
c
c     sortie des resultats
      ils=adr(lstk(kynew),0)
      top=tope-rhs+1
      call icopy(hsize,istk(ils),1,istk(ile),1)
      nel=istk(ile+1)*istk(ile+2)
      istk(ile+2)=nn*istk(ile+2)
      ly=adr(ile+hsize,1)
      if(istk(ile).eq.2) ly=adr(ile+9+nel*nn,1)
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
      if(mf.eq.30) then
         top=top+1
         il=adr(lstk(top),0)
         istk(il)=1
         istk(il+3)=0
         l=adr(il+4,1)
         if(istate.eq.3) then
            istk(il+1)=1
            istk(il+2)=1
            stk(l)=t0
            do 53 i=0,nsurf-1
               if(istk(ilroot+i).ne.0) then
                  l=l+1
                  istk(il+2)=istk(il+2)+1
                  stk(l)=i+1
               endif
 53         continue
         else
            istk(il+1)=0
            istk(il+2)=0
         endif
         lstk(top+1)=l+1
      endif
         
      if(lhs.eq.2.and.mf.eq.30.or.lhs.eq.1) return
c     w
      top=top+1
      il=adr(lstk(top),0)
      istk(il)=1
      istk(il+1)=1
      istk(il+2)=lrw
      istk(il+3)=0
      l=adr(il+4,1)
      lstk(top+1)=l+lrw
      call dcopy(lrw-nsizd,stk(lc),1,stk(l),1)
      lsvs=l+lrw-nsizd
c     iw
      top=top+1
      il=adr(lstk(top),0)
      istk(il)=1
      istk(il+1)=1
      istk(il+2)=liw
      istk(il+3)=0
      l=adr(il+4,1)
      lstk(top+1)=l+liw
      do 60 k=1,liw-nsizi
         stk(l+k-1)=dble(istk(ilc+k-1))
 60   continue
      lsvi=l+liw-nsizi
      if(mf.eq.0) then
         call svcma1(stk(lsvs),stk(lsvi))
      elseif(mf.lt.30) then
         call svcom1(stk(lsvs),stk(lsvi))
      else
         call svcar1(stk(lsvs),stk(lsvi))
      endif
      return
c     fin de ode.....
c
c     intg
c
 120  call intg('intg')
      return
c     feval; evaluation d'une macro f(x1) ou f(x1,x2)
c
 130  call feval('feval')
      return
 140  call bva('bva')
      return
      end

      subroutine intg(fname)
c      implicit undefined (a-z)
      character*(*) fname
      character*6   namef
      include '../stack.h'
      integer adr
      integer iero 
      common/ierajf/iero
      common/cintg/namef
      external bintg,fintg
      double precision epsa,epsr,a,b,val,abserr
      logical getexternal, getscalar,type ,cremat
      integer topk,lr,katop,kydot,top2,lra,lrb,lc
      integer ipal,lpal,lw,liw,lpali,ifail
      if(rhs.lt.3) then
         call error(39)
         return
      endif
      type=.false.
      top2=top
      topk=top
      if(rhs.eq.5) then
         if (.not.getscalar(fname,topk,top,lr)) return
         epsr=stk(lr)
         top=top-1
      else
         epsr=1.0d-8
      endif
      if (rhs.ge.4) then 
         if (.not.getscalar(fname,topk,top,lr)) return
         epsa=stk(lr)
         top=top-1
      else
         epsa=0.0d+0
      endif
c     cas standard
      if (.not.getexternal(fname,topk,top,namef,type)) return
      kydot=top
      top=top-1
      if (.not.getscalar(fname,topk,top,lrb)) return
      b=stk(lrb)
      top=top-1
      katop=top
      if (.not.getscalar(fname,topk,top,lra)) return
      a=stk(lra)
c     tableaux de travail 
      top=top2+1
      lw=3000
      if (.not.cremat(fname,top,0,1,lw,lpal,lc)) return
      top=top+1
c     tableau de travail entier necessaire 
      liw=3000/8+2
      if (.not.cremat(fname,top,0,1,adr(liw,0)+1,lpali,lc)) return
      top=top+1
c
c     external scilab
c
      ipal=adr(lstk(top),0)
      istk(ipal)=1
      istk(ipal+1)=ipal+2
      istk(ipal+2)=kydot
      istk(ipal+3)=katop
      lstk(top+1)=adr(ipal+4,0)
      if(type) then 
         call dqag0(fintg,a,b,epsa,epsr,val,abserr,
     +        stk(lpal),lw,stk(lpali),liw,ifail)
      else
         call dqag0(bintg,a,b,epsa,epsr,val,abserr,
     +        stk(lpal),lw,stk(lpali),liw,ifail)
      endif
      if(err.gt.0)return
      if(ifail.gt.0) then
         call error(24)
         return
      endif
      top=top2-rhs+1
      stk(lra)=val
      if(lhs.eq.2) then
         top=top+1
         stk(lrb)=abserr
         return
      endif
      return
      end

      subroutine feval(fname)
C     feval(x1,x2,external) -> external(x1(i),x2(j))
C     feval(x1,external)    -> external(x1(i))
c      implicit undefined (a-z)
      include '../stack.h'
      character*(*) fname
      character*6   ename
      integer m1,n1,lb,m2,n2,la,i,j,nn,lr,lc,lb1,lbc1,lrr,lcr
      integer topk,itype,kx1top,kx2top,lr1,iero,kfeval,gettype
      double precision x1,x2,fval(2)
      logical type,getexternal,getrmat,cremat
C     External names (colname), Position in stack (coladr), type (coltyp)
      common / fevalname / ename
      common / fevaladr / kfeval,kx1top,kx2top
      common / fevaltyp / itfeval
      common/  ierfeval/iero
      if(rhs.lt.2) then
         call error(39)
         return
      endif
      itype=0
      type=.false.
      kfeval=top
      topk=top
      if (.not.getexternal(fname,topk,top,ename,type)) return
      itfeval=gettype(top)
      top=top-1
      if (.not.getrmat(fname,topk,top,m1,n1,lb))  return
      x2=stk(lb)
      nn=1
      if (rhs.eq.3) then 
         nn=2
         top=top-1
         if (.not.getrmat(fname,topk,top,m2,n2,la))  return
         x1=stk(la)
      endif
C     place pour le resultat si on a deux arguments 
      top=topk+1
      if (nn.eq.2) then 
         if (.not.cremat(fname,top,1,m1*n1,m2*n2,lr,lc)) return
      else
         if (.not.cremat(fname,top,0,m1,n1,lb1,lbc1)) return
      endif
c     external scilab
C     une variable de taille 1 qui permet de gerer le type d'argument
      top=top+1
      kx1top=top
      if (.not.cremat(fname,top,0,1,1,lrr,lcr)) return
      if (nn.eq.2) then 
         top=top+1
         kx2top=top
         if (.not.cremat(fname,top,0,1,1,lrr,lcr)) return
      endif
      iero=0
      if(type) then 
         if (nn.eq.2) then 
            do 182 i=1,m2*n2
               do 192 j=1,m1*n1
                  call ffeval(nn,stk(la+i-1),stk(lb+j-1),
     $                 fval,itype,ename)
                  if(err.gt.0) return
                  if(iero.gt.0) then
                     call error(24)
                     Return
                  endif
                  stk(lr+i-1+m2*n2*(j-1))=fval(1)
                  if (itype.eq.1) stk(lc+i-1+m2*n2*(j-1))=fval(2)
 192           continue
 182        continue
         else
            do 183 i=1,m1*n1
               call ffeval(nn,stk(lb+i-1),1.0d0,fval,itype,ename)
               if(err.gt.0) return
               if(iero.gt.0) then
                  call error(24)
                  Return
               endif
               stk(lb+i-1)=fval(1)
               if (itype.eq.1) stk(lb1+i-1)=fval(2)
 183        continue
         endif
      else
         if (nn.eq.2) then 
            do 172 i=1,m2*n2
               do 174 j=1,m1*n1
                  call bfeval(nn,stk(la+i-1),stk(lb+j-1),
     $                 fval,itype,ename)
                  if(err.gt.0) return
                  if(iero.gt.0) then
                     call error(24)
                     Return
                  endif
                  stk(lr+i-1+m2*n2*(j-1))=fval(1)
                  if (itype.eq.1) stk(lc+i-1+m2*n2*(j-1))=fval(2)
 174           continue
 172        continue
         else
            do 173 i=1,m1*n1
               call bfeval(nn,stk(lb+i-1),1.0D0,fval,itype,ename)
               if(err.gt.0) return
               if(iero.gt.0) then
                  call error(24)
                  Return
               endif
               stk(lb+i-1)=fval(1)
               if (itype.eq.1) stk(lb1+i-1)=fval(2)
 173        continue
         endif
      endif
 162  continue
      top=topk-rhs+1
      if (nn.eq.2) then 
         if (.not.cremat(fname,top,itype,m2*n2,m1*n1,lr1,lc)) return
         call dcopy(m1*n1*m2*n2*(itype+1),stk(lr),1,stk(lr1),1)
      else
         if (itype.eq.1)then 
            if (.not.cremat(fname,top,itype,m1,n1,lr,lc)) return
            call dcopy(m1*n1,stk(lb1),1,stk(lc),1)
         endif
      endif
      return
      end

