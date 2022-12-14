      subroutine sctree(nb,vec,in,depu,outptr,cmat,ord,nord,ok,kk)
c     inputs:
c     nb: number of regular blocks
c     vec: integer vector of size nb
c     in: integer vector
c     depu: logical vector, first column of dep_ut
c     outptr: integer vector
c     cmat: integer vector
c     kk: integer work area of size nb
c
c     outputs:
c     ok: integer
c     ord: integer vector of size nord (=<nb)
c     nord
c     Copyright INRIA
      integer vec(nb),in(*),outptr(*),cmat(*),ord(*)
      integer nb,i,j,lkk
      integer depu(*),ok
      logical fini
      integer kk(nb)
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
               lkk=0
               do 40 l=outptr(i),outptr(i+1)-1
                  ii=in(cmat(l))
                  if (depu(ii).eq.1) then
                     lkk=lkk+1
                     kk(lkk)=ii
                  endif
 40            continue
               if (lkk.gt.0) then
                  fini=.false.
                  do 45 l=1,lkk
                     vec(kk(l))=j
 45               continue
               endif
            endif
 50      continue
         if (fini) goto 65
 60   continue
 65   continue
      do 70 l=1,nb
         kk(l)=-vec(l)
 70   continue
      call isort(kk,nb,ord)
      nord=0
      do 80 l=1,nb
         if(kk(l).ne.1.and.outptr(ord(l)+1)-outptr(ord(l)).ne.0) then
            nord=nord+1
            ord(nord)=ord(l)
         endif
 80   continue
      end

