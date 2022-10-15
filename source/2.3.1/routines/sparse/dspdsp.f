      subroutine dspdsp(ne,ind,x,m,n,maxc,mode,ll,lunit,cw)
c!but
c     dspdsp visualise une matrice  creuse
c!liste d'appel
c
c     subroutine dspdsp(ne,ind,x,m,n,maxc,mode,ll,lunit,cw)
c
c     double precision x(*)
c     integer ind(*)
c     integer nx,m,n,maxc,mode,ll,lunit
c     character cw*(*)
c
c     c : nombre d'elements nons nuls de la matrice
c     ind : indices specifiant la position des elements non nuls
c     x : tableau contenant les elements non nuls
c     m : nombre de ligne de la matrice
c     n : nombre de colonnes de la matrice
c     maxc : nombre de caracteres maximum autorise pour
c            representer un nombre
c     mode : si mode=1 representation variable
c            si mode=0 representation d(maxc).(maxc-7)
c     ll : longueur de ligne maximum admissible
c     lunit : etiquette logique du support d'edition
c     cw : chaine de caracteres de travail de longueur au moins ll
c!
      double precision x(*),a,a1,a2,fact,eps,dlamch
      integer maxc,mode,fl,typ
      integer ind(*)
      character cw*(*),sgn*1,dl*1
      character*10 form(2)
c
      if(ne.eq.0) then
         write(cw,'(''('',i5,'','',i5,'') zero sparse matrix'')') m,n
         call basout(io,lunit,cw(1:32))
         call basout(io,lunit,' ')
         goto 99
      else
         write(cw,'(''('',i5,'','',i5,'') sparse matrix'')') m,n
         call basout(io,lunit,cw(1:27))
         call basout(io,lunit,' ')
         if(io.eq.-1) goto 99
      endif
      ilr=1
      ilc=m+1
      nx=1
      eps=dlamch('p')
      cw=' '
      write(form(1),130) maxc,maxc-7
      dl=' '
      if(m*n.gt.1) dl='!'
      
c
c facteur d'echelle
c
      fact=1.0d+0
      a1=0.0d+0
      if(ne.eq.1) goto 10
      a2=abs(x(1))
      do 05 i=1,ne
         a=abs(x(i))
         if(a.eq.0.0d+0.or.a.gt.dlamch('o')) goto 05
         a1=max(a1,a)
         a2=min(a2,a)
   05 continue
      imax=0
      imin=0
      if(a1.gt.0.0d+0) imax=int(log10(a1))
      if(a2.gt.0.0d+0) imin=int(log10(a2))
      if(imax*imin.le.0) goto 10
      imax=(imax+imin)/2
      if(abs(imax).ge.maxc-2)  fact=10.0d+0**(-imax)
   10 continue
      eps=a1*fact*eps
c
      if(fact.ne.1.0d+0) then
         write(cw(1:12),'(1x,1pd9.1,'' *'')')  1.0d+0/fact
         call basout(io,lunit,cw(1:12))
         call basout(io,lunit,' ')
         if(io.eq.-1) goto 99
      endif
      i0=0
      i1=i0
      l=1
      do 20 k=1,ne
         cw=' '
 11      i0=i0+1
         if(i0-i1.gt.ind(l)) then
            i1=i0
            l=l+1
            goto 11
         endif
         i=l
         j=ind(ilc-1+k)
         write(cw,'(''('',i5,'','',i5,'')'')') i,j
         l1=14
          a=x(k)*fact
         if(abs(a).lt.eps.and.mode.ne.0) a=0.0d+0
         sgn=' '
         if(a.lt.0.0d+0) sgn='-'
         a=abs(a)

c     determination du format devant representer a
         typ=1
         if(mode.eq.1) call fmt(a,maxc,typ,n1,n2)
         if(typ.eq.2) then
            fl=n1
            ifmt=n2+32*n1
         elseif(typ.lt.0) then
            ifmt=typ
            fl=3
         else
            ifmt=1
            fl=maxc
            n2=maxc-7
         endif
         cw(l1:l1+6)='      '//sgn
         l1=l1+7
         if(ifmt.eq.1) then
            nf=1
            fl=maxc
            n2=1
            write(cw(l1:l1+fl-1),form(nf)) a
         elseif(ifmt.ge.0) then
            nf=2
            n1=ifmt/32
            n2=ifmt-32*n1
            fl=n1
            write(form(nf),120) fl,n2
            write(cw(l1:l1+fl-1),form(nf)) a
         elseif(ifmt.eq.-1) then
c     Inf
            fl=3
            cw(l1:l1+fl-1)='Inf'
         elseif(ifmt.eq.-2) then
c     Nan
            fl=3
            cw(l1:l1+fl-1)='Nan'
         endif
         l1=l1+fl
         call basout(io,lunit,cw(1:l1) )
         if (io.eq.-1) goto 99

   20 continue
 99   continue
c
  120 format('(f',i2,'.',i2,')')
  130 format('(1pd',i2,'.',i2,')')
      end
