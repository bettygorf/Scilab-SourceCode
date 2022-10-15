      subroutine ddpow(n,v,iv,dpow,ierr)
c!but
c     eleve a une puissance reelle les elements d'un vecteur de flottants
c     double precision
c!liste d'appel
c     subroutine ddpow(n,v,iv,dpow,ierr)
c     integer n,iv,ierr
c     double precision v(n*iv),dpow
c
c     n : nombre d'element du vecteur
c     v : tableau contenant les elements du vecteur
c     iv : increment entre deux element consecutif du vecteur dans le
c          tableau v
c     dpow : puissance a la quelle doivent etre eleves les elements du
c            vecteur
c     ierr : indicateur d'erreur
c            ierr=0 si ok
c            ierr=1 si 0**0
c            ierr=2 si 0**k avec k<0
c!origine
c Serge Steer INRIA 1989
c!
      integer n,iv,ierr
      double precision v(*),dpow
c
      ierr=0
c
      if(dble(int(dpow)).ne.dpow) goto 01
c puissance entiere
      call dipow(n,v,iv,int(dpow),ierr)
      return
c
   01 continue
      if(dpow.lt.0.0d+0) then
c puissance negative
      ii=1
      do 20 i=1,n
        if(v(ii).ne.0.0d+0) then
                          v(ii)=v(ii)**dpow
                          ii=ii+iv
                      else
                          ierr=2
                          return
        endif
   20 continue
      else
c puissance  positive
      ii=1
      do 30 i=1,n
                          v(ii)=v(ii)**dpow
                          ii=ii+iv
   30 continue
      endif
c
      return
      end
