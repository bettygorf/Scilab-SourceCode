      subroutine sctree1(nb,wec,outoin1,outoin2,outoinptr,typ_r,
     $     typ_c,ord1,ord2,nord,ok,vec)
c     inputs:
c     nb: number of regular blocks
c     wec: integer vector of size nb
c     vec: integer vector of size nb
c     outoin1,outoin2: integer vectors
c     outoinptr: integer vector of size nb+1 (pointer to outoin's)
c     typ_r: integer (logical) vector of size nb
c     typ_c: integer (logical) vector of size nb
c     ok: integer
c     ord1: integer vector of size (nord)
c     ord2: integer vector of size (nord)
c     nord: integer  (=<nb)
      integer vec(nb),wec(nb),outoin1(*),outoin2(*)
      integer outoinptr(*),ord1(*),ord2(*),typ_r(nb),typ_c(nb)
      integer nord
      integer nb,i,j,l
      integer ok
      logical fini
c
c
      do 20 i=1,nb
         if(wec(i).eq.0) then
            vec(i)=-1
         else
            vec(i)=0
         endif
 20   continue
      ok=1
      do 60 j=1,nb+2
      fini=.true.
         do 50 i=1,nb
            if(vec(i).eq.0) then 
               if(j.eq.nb+2) then 
                  ok=0
                  return
               endif
               if(outoinptr(i).ge.outoinptr(i+1)) goto 42
               do 40 k=outoinptr(i),outoinptr(i+1)-1
                  ii=outoin1(k)
                  if (vec(ii).eq.1.and.(typ_r(ii)+typ_c(ii)).ge.1) then
                     fini=.false.
                     vec(ii)=0
                     if(typ_r(ii).eq.1) wec(ii)=
     $                    wec(ii)-2**(outoin2(k)-1)
                  endif
 40            continue
 42            continue
            endif
 50      continue
         if (fini) goto 65
 60   continue
 65   nord=0
      do 70 l=1,nb
         if(wec(l).ne.0) then
            nord=nord+1
            ord1(nord)=l
            ord2(nord)=wec(l)
         endif
 70   continue
      end





      subroutine sctree2(nb,vec,outoin1,outoin2,outoinptr,dep_u,
     $     ord1,ord2,nord,ok,wec)
c     inputs:
c     nb: number of regular blocks
c     wec: integer vector of size nb
c     vec: integer vector of size nb
c     outoin1,outoin2: integer vectors
c     outoinptr: integer vector of size nb+1 (pointer to outoin's)
c     dep_u: integer (logical) vector of size nb (ist col. of dep_ut)
c     ok: integer
c     ord1: integer vector of size (nord)
c     ord2: integer vector of size (nord)
c     nord: integer  (=<nb)
      integer vec(nb),wec(nb),outoin1(*),outoin2(*)
      integer outoinptr(*),ord1(*),ord2(*),dep_u(nb)
      integer nord
      integer nb,i,j,lkk
      integer ok
      logical fini
c
c
      do 20 i=1,nb
         wec(i)=0
 20   continue
      ok=1
      do 60 j=1,nb+2
         fini=.true.
         do 50 i=1,nb
            if(vec(i).eq.j-1) then 
               if(j.eq.nb+2) then 
                  ok=0
                  return
               endif
               if(outoinptr(i).ge.outoinptr(i+1)) goto 42
               do 40 k=outoinptr(i),outoinptr(i+1)-1
                  ii=outoin1(k)
                  if (dep_ut(ii,1).eq.1) then
                     fini=.false.
                     vec(ii)=j
                     wec(ii)=wec(ii)-2**(outoin2(k)-1)
                  endif
 40            continue
 42            continue
            endif
 50      continue
         if (fini) goto 65
 60   continue
 65   do 70 l=1,nb
         vec(l)=-vec(l)
 70   continue
      call isort(vec,nb,ord1)
      nord=0
      do 80 l=1,nb
         if(vec(l).ne.1) then
            nord=nord+1
            ord1(nord)=ord1(l)
            ord2(nord)=wec(l)
         endif
 80   continue
      end







      subroutine sctree3(nb,vec,bexe,boptr,blnk,blptr,dep_u,
     $     typl,ord,nord,ok)
c     inputs:
c     nb: number of regular blocks
c     wec: integer vector of size nb
c     vec: integer vector of size nb
c     boptr,blptr: integer vectors of size nb+1 (pointers to bexe,blnk)
c     bexe,blnk: integer vectors
c     dep_u: integer (logical) vector of size nb (ist col. of dep_ut)
c     typl: integer (logical) vector of size nb
c     ok: integer
c     ord: integer vector of size (nord)
c     nord: integer  (=<nb)
      integer vec(nb)
      integer bexe(*),boptr(*),blnk(*),blptr(*),ord(*),dep_u(nb)
      integer nord
      integer nb,i,j,k
      integer ok
      logical fini
c
c
      ok=1
      do 60 j=1,nb+2
      fini=.true.
         do 50 i=1,nb
            if(vec(i).eq.j-1) then 
               if(j.eq.nb+2) then 
                  ok=0
                  return
               endif
               if(typl(i).eq.1) then
                  fini=.false.
                  if (boptr(i).ge.boptr(i+1)) goto 35
                  do 30 k=boptr(i),boptr(i+1)-1
                     kk=bexe(k)
                     vec(kk)=j
 30               continue
 35               continue
               else
                  if (blptr(i).ge.blptr(i+1)) goto 39
                  do 38 k=blptr(i),blptr(i+1)-1
                     ii=blnk(k)
                     if(dep_u(ii).eq.1.or.(typl(ii).eq.1
     $                    .and.vec(ii).lt.-1)) then
                        fini=.false.
                        vec(ii)=j
                     endif
 38               continue
 39               continue
               endif
            endif
 50      continue
         if (fini) goto 65
 60   continue
 65   do 70 l=1,nb
         vec(l)=-vec(l)
 70   continue
      call isort(vec,nb,ord)
      nord=0
      do 80 l=1,nb
         if(vec(l).ne.1) then
            nord=nord+1
            ord(nord)=ord(l)
         endif
 80   continue
      end







