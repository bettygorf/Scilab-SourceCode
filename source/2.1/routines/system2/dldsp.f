      subroutine dldsp(x,nx,m,n,ll,lunit,cw)
c!    but 
c     dldsp ecrit une matrice  de booleens (ou un booleen) sous
c     la forme d'un tableau s, avec gestion automatique de
c     l'espace disponible.
c!    liste  d'appel
c     
c     subroutine dldsp(x,nx,m,n,maxc,mode,ll,lunit,cw,iw)
c     
c     integer x(*)
c     integer nx,m,n,maxc,mode,iw(*),ll,lunit
c     character cw*(*)
c     
c     x : tableau contenant les elements de la matrice x
c     nx : entier definissant le rangement dans x
c     m : nombre de ligne de la matrice
c     n : nombre de colonnes de la matrice
c     ll : longueur de ligne maximum admissible
c     lunit : etiquette logique du support d'edition
c     cw : chaine de caracteres de travail de longueur au moins ll
c!    
      integer x(*),a
      character cw*(*),dl*1,true*1,false*1
      data true/'T'/,false/'F'/
c     
      cw=' '
      dl=' '
      if(m*n.gt.1) dl='!'
c
      nelt=(ll-3)/2
      nbloc=n/nelt
      if(nbloc*nelt.lt.n) nbloc=nbloc+1

c phase d'edition : la chaine de caractere representant la ligne des coeff
c       est constituee puis imprimee.
c
      k1=1
      do 70 ib=1,nbloc
         k2=min(n,k1+nelt)
         if(nbloc.ne.1) then
            if(k1.eq.k2) then
               write(cw(1:4),'(i4)') k1
               call basout(io,lunit,' ')
               call basout(io,lunit,'         column '//cw(1:4))
            else
               write(cw(1:8),'(2i4)') k1,k2
               call basout(io,lunit,' ')
               call basout(io,lunit,'        columns'//cw(1:4)//
     &              ' to'//cw(5:8))
               call basout(io,lunit,' ')
            endif
            call basout(io,lunit,' ')
            if (io.eq.-1) goto 99
         endif
c
         do 60 l=1,m
            cw(1:1)=dl
            l1=2
            do 50 k=k1,k2
               a=x(l+(k-1)*nx)
               cw(l1:l1)=' '
               l1=l1+1
               if(a.eq.0) then
                  cw(l1:l1)=false
               else
                  cw(l1:l1)=true
               endif
               l1=l1+1
 50         continue
            cw(l1:l1+1)=' '//dl
            call basout(io,lunit,cw(1:l1+1) )
            if (io.eq.-1) goto 99
 60      continue
         k1=k2+1
 70   continue
c
 99   return
c

      end
