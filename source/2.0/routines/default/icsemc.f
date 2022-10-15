      subroutine icsemc(ind,nu,u,co,g,itv,rtv,dtv)
      external mcsec,icsec2,icsei
c      resolution au moindres carres des problemes lineaires quadratiques
      call icse(ind,nu,u,co,g,itv,rtv,dtv,mcsec,icsec2,icsei)
      end

      subroutine mcsec(indf,t,y,uc,uv,f,fy,fu,b,itu,dtu,
     & t0,tf,dti,dtf,ermx,iu,nuc,nuv,ilin,nti,ntf,ny,nea,
     & itmx,nex,nob,ntob,ntobi,nitu,ndtu)
c
c      Second membre de l'equation d'etat :
c       Parametres d'entree :
c        indf     : vaut 1,2,3 suivant qu'on veut calculer f,fy,fu
c        t        : instant courant
c        y(ny)    : etat a un instant donne
c        uc(nuc)  : controle independant du temps
c        uv(nuv)  : controle dependant du temps, a l'instant t
c        b(ny)    : terme constant dans le cas lineaire quadratique
c       Parametres de sortie :
c         indf    : >0 si  le calcul s'est  correctement effectue,<=0
c                   sinon
c        f(ny)    : second membre
c        fy(ny,ny): jacobien de f par rapport a y
c        fu(ny,nuc+nuv) : derivee de f par rapport au controle
c       Tableaux de travail reserves a l'utilisateur :
c        itu(nitu): tableau entier
c        dtu(ndtu): tableau double precision
c       (nitu et ndtu sont initialises par le common icsez).
c!
      implicit double precision (a-h,o-z)
      dimension y(ny),uc(*),uv(*),f(ny),fy(ny,ny),fu(ny,*),
     &     b(ny),itu(*),dtu(*),iu(5)
c
      if (indf.eq.1) then
         do 50 i=1,ny
            fii=b(i)
            do 20 j=1,ny
               fii=fii+fy(i,j)*y(j)
 20         continue
            if(nuc.gt.0) then
               do 30 j=1,nuc
                  fii=fii+fu(i,j)*uc(j)
 30            continue
            endif
            if(nuv.gt.0) then
               jj=0
               do 40 j=1+nuc,nuv+nuc
                  jj=jj+1
                  fii=fii+fu(i,j)*uv(jj)
 40            continue
            endif
            f(i)=fii
 50      continue
         return
      endif
      end

