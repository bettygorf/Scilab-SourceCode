C------------------------------------------------
C     Routines JPC pour cour d'automatique 
C	Tout ce qui suit est appelle par fydot 
C------------------------------------------------
C     Equation d'arnold
      subroutine arnol (neq, t, y, ydot)
      double precision t, y, ydot,aa(6)
      common / aac / aa
      dimension y(3), ydot(3)
      data aa  /1.0 ,1.0 ,1.0 ,1.0 ,1.0 ,1.0 /
c     exemple de fonction second membre pour ode
      ydot(1)=aa(1)*cos(y(2)) +aa(2)*sin(y(3))
      ydot(2)=aa(3)*cos(y(3)) +aa(4)*sin(y(1))
      ydot(3)=aa(5)*cos(y(1)) +aa(6)*sin(y(2))
      return
      end
C------------------------------------------------
C     Routines JPC pour cour d'automatique 
C     Equation d'arnold initialisation
C
      subroutine arset (aa1)
      common / aac / aa(6)
      dimension aa1(6)
C       carte rajoutee par FD (sinon aa1 est external?)
      double precision aa,aa1
      do 10 i=1,6
         aa(i)=aa1(i)
 10      continue
      return 
      end 
C--------------------------------------------------
C------------------------------------------------
C     Routines JPC pour cour d'automatique 
C     Equation de lorentz 
      subroutine loren (neq, t, y, ydot)
      double precision t, y, ydot,sig,ro,beta
      common / lorentz / sig,ro,beta 
      dimension y(3), ydot(3)
      data sig,ro,beta  /10.0 ,28.0, 2.6666667 /
c     exemple de fonction second membre pour ode
      ydot(1)=sig*(y(2)-y(1))
      ydot(2)=ro*y(1) -y(2)-y(1)*y(3)
      ydot(3)=-beta*y(3)+y(1)*y(2)
      return
      end
C------------------------------------------------
C     Routines JPC pour cour d'automatique 
C     Equation de lorentz initialisation
C
      subroutine loset (sig1,ro1,beta1)
      common / lorentz / sig,ro,beta 
      real sig1,ro1,beta1
      double precision sig,ro,beta
      sig= sig1
      ro = ro1
      beta=beta1
      return 
      end 
C--------------------------------------------------
C     modele de competition boucle avec observateur
C     Routine d'initialisation 
C     
      subroutine icomp(xe1,ue1,f1,g1,h1,k1,l1,br1,pas1,nn1,pp,ii)
C      implicit undefined (a-z)
      real br1(nn1),pas1,h1(2),l1(2),xe1(2),k1(2),pp(7)
      real f1(2,2),g1(2),ue1
      integer nn1,i,j,ii 
      real br(1000),pas,ppr,ppk,ppa,ppb,ppm,pps,ppl,
     $     h(2),l(2),k(2),xe(2),f(2,2),g(2),ue
      integer nn 
      common / bcompc/ br,pas,nn,ppr,ppk,ppa,ppb,ppm,pps,ppl,
     $     h,l,k,xe,f,g,ue
      ppr=pp(1)
      ppk=pp(2)
      ppa=pp(3)
      ppb=pp(4)
      ppm=pp(5)
      pps=pp(6)
      ppl=pp(7) 
      do 771 i=1,nn1
        br(i)=br1(i)
c      enddo
 771  continue
      pas=pas1
      nn=nn1
      do 772 i=1,2
      do 773 j=1,2
        f(i,j)=f1(i,j)
c      enddo
 773  continue
        h(i)=h1(i)
        l(i)=l1(i)
        xe(i)=xe1(i)
        k(i)=k1(i)
        g(i)=g1(i)
 772  continue
      ue=ue1
      if (ii.eq.1) then 
         write(06,*) 'pp r,k,a,b,m,s,l', ppr,ppk,ppa,ppb,ppm,pps,ppl
         write(06,*) 'pas=',pas,' n=',nn
         write(06,*) 'h',(h(i),i=1,2)
         write(06,*) 'f',((f(i,j),i=1,2),j=1,2)
         write(06,*) 'l',(l(i),i=1,2)
         write(06,*) 'xe',(xe(i),i=1,2)
         write(06,*) 'k',(k(i),i=1,2)
         write(06,*) 'g',(g(i),i=1,2)
         write(06,*) 'u',ue
      endif

      return
      end
C---------------------------------------------------------
C     modele non lineaire commande par feedback lineaire 
C     construit sur un observateur (on bruite la sortie)
C----------------------------------------------------------
      subroutine bcomp (neq, t, x, xdot)
C      implicit undefined (a-z)
      double precision t, x, xdot
      dimension x(4), xdot(4)
      real br(1000),pas,ppr,ppk,ppa,ppb,ppm,pps,ppl,
     $     h(2),l(2),k(2),xe(2),f(2,2),g(2),ue
      integer nn 
      common / bcompc/ br,pas,nn,ppr,ppk,ppa,ppb,ppm,pps,ppl,
     $     h,l,k,xe,f,g,ue
      real u ,brui,y
      integer nnn,neq
c      nnn=nint(min(1+t/pas,nn)) old
      nnn=int(min(1+t/pas,dble(nn)))
      if ( nnn.le.0 .or. nnn.gt.nn) then 
         write(06,*) ' depassement ds vbruit'
      endif
      brui=br(nnn)
      u=ue- k(1)*(x(3)-xe(1))-k(2)*(x(4)-xe(2))
      y=h(1)*x(1)+h(2)*x(2)+brui
C     xdot=compet(t,x,u) composantes 1 et 2 
      xdot(1) = ppr*x(1)*(1-x(1)/ppk) - u*ppa*x(1)*x(2)
      xdot(2) = pps*x(2)*(1-x(2)/ppl) - u*ppb*x(1)*x(2)
C     observateur 
      xdot(3) = f(1,1)*(x(3)-xe(1))+f(1,2)*(x(4)-xe(2))
      xdot(4) = f(2,1)*(x(3)-xe(1))+f(2,2)*(x(4)-xe(2))
      xdot(3) = xdot(3) + g(1)*(u-ue) - l(1)*(h(1)*x(3)+h(2)*x(4)-y)
      xdot(4) = xdot(4) + g(2)*(u-ue) - l(2)*(h(1)*x(3)+h(2)*x(4)-y)
      return
      end 
C---------------------------------------------------------
C     modele de competition linearise observe-controle
C----------------------------------------------------------
      subroutine lcomp (neq, t, x, xdot)
C      implicit undefined (a-z)
      double precision t, x, xdot
      dimension x(4), xdot(4)
      real br(1000),pas,ppr,ppk,ppa,ppb,ppm,pps,ppl,
     $     h(2),l(2),k(2),xe(2),f(2,2),g(2),ue
      integer nn 
      common / bcompc/ br,pas,nn,ppr,ppk,ppa,ppb,ppm,pps,ppl,
     $     h,l,k,xe,f,g,ue
      real u ,brui,y
      integer nnn,neq
c      nnn=nint(min(1+t/pas,nn))
      nnn=int(min(1+t/pas,dble(nn)))
      if ( nnn.le.0 .or. nnn.gt.nn) then 
         write(06,*) ' depassement ds vbruit'
      endif
      brui=br(nnn)
      u=ue- k(1)*(x(3)-xe(1))-k(2)*(x(4)-xe(2))
      y=h(1)*x(1)+h(2)*x(2)+brui
C     xdot=lincomp autour de xe ue 
      xdot(1) = f(1,1)*(x(1)-xe(1))+f(1,2)*(x(4)-xe(2))+g(1)*(u-ue)
      xdot(2) = f(2,1)*(x(1)-xe(1))+f(2,2)*(x(4)-xe(2))+g(2)*(u-ue)
C    observateur 
      xdot(3) = f(1,1)*(x(3)-xe(1))+f(1,2)*(x(4)-xe(2))
      xdot(4) = f(2,1)*(x(3)-xe(1))+f(2,2)*(x(4)-xe(2))
      xdot(3) = xdot(3) + g(1)*(u-ue) - l(1)*(h(1)*x(3)+h(2)*x(4)-y)
      xdot(4) = xdot(4) + g(2)*(u-ue) - l(2)*(h(1)*x(3)+h(2)*x(4)-y)
      return
      end 
