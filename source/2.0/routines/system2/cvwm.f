      subroutine cvwm(xr,xi,nx,m,n,maxc,mode,str,istr)
c!but 
c     cvwm transcrit une matrice reelle en une matrice de chaines
c     de caracteres scilab
c!liste d'appel
c     
c     subroutine cvwm(xr,xi,nx,m,n,maxc,mode,str,istr)
c     
c     double precision x(*)
c     integer nx,m,n,maxc,mode,str(*),istr(m*n+1)
c     
c     xr,xi : tableau contenant les coefficients de la matrice x
c     nx : entier definissant le rangement dans x
c     m : nombre de ligne de la matrice
c     n : nombre de colonnes de la matrice
c     maxc : nombre de caracteres maximum autorise pour
c     representer un nombre
c     mode : si mode=1 representation variable
c     si mode=0 representation d(maxc).(maxc-7)
c     str : tableau contenant apres execution la suite des codes scilab
c     des caracteres.taille >= m*n*maxc
c     istr : tableau donnant la structure de str
c!    
      double precision xr(*),xi(*),a,eps,d1mach
      integer maxc,mode,fl,typ
      integer str(*),istr(*)
      character cw*256,sgn*1
      character*10 form(2)
c     
      eps=d1mach(4)
      write(form(1),130) maxc,maxc-7
c     
      lstr=1
      istr(1)=1
      lp=-nx
      do 20 k=1,n
         lp=lp+nx
         do 20 l=1,m
c     
c     traitement du coeff (l,k)
            a=xr(lp+l)
            l1=1
            l0=1
c     
            lb=0
            do 15 i=1,2
               if(m*n.gt.1.and.abs(a).lt.eps.and.mode.ne.0) a=0.0d+0
c     determination du format devant representer a
               typ=1
               if(mode.eq.1) call fmt(abs(a),maxc,typ,n1,n2)
               if(typ.ne.2) then
                  nf=1
                  fl=maxc
               else
                  fl=n1
                  nf=2
                  write(form(nf),120) fl,n2
               endif
c     
               write(cw(l1:l1+fl-1),form(nf)) a
               l1=l1+fl
               if(n2.eq.0) l1=l1-1
               if(i.eq.1) then
                  if(a.ge.0.0d+0) l0=2
                  a=xi(lp+l)
                  if(abs(a).le.eps) goto 16
                  sgn='+'
                  if(a.lt.0) sgn='-'
                  a=abs(a)
                  cw(l1:l1+3)=sgn//'%i*'
                  l1=l1+4
                  lb=l1
               endif
 15         continue
c     
 16         continue
            if(lb.gt.0 .and. cw(lb:lb).eq.' ') then
               l1=l1-1
               cw(lb:l1-1)=cw(lb+1:l1)
               cw(l1:l1)=' '
            endif
            call cvstr(l1-l0,str(lstr),cw(l0:l1-1),0)
            lstr=lstr+l1-l0
            istr((k-1)*m+l+1)=lstr
 20      continue
         return
 120     format('(f',i2,'.',i2,')')
 130     format('(1pd',i2,'.',i2,')')
         end
