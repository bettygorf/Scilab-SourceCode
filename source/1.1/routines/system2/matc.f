      subroutine matc(chai,lda,m,n,name,job)
c!but
c     matc lit ou ecrit une matrice de chaine de caractere dans
c     la stack de scilab
c
c!liste d'appel
c
c     integer       lda,m,n,job
c     character*(*) chai,name
c
c     chai     :tableau de taille n*lda contenant a l'appel
c               ou au retour la matrice de chaine de caractere
c     lda     : nombre de ligne du tableau chai dans le programme
c               appellant
c     name    : chaine de caractere designant le nom de la
c               variable dans l'environnement scilab
c               (tronquee a 8 carateres)
c     job     : job= 0 passage scilab  -> fortran d'une matrice reelle
c               job= 1 passage fortran -> scilab  d'une matrice reelle
c               job=10 passage scilab  -> fortran d'une matrice complexe
c               job=11 passage fortran -> scilab  d'une matrice complexe
c
c    attention en lecture(i.e.sens scilab->fortran)  m et n
c    sont definis par matc.On doit appeler matc sous la forme
c    call matc(ch,lda,m,n,name,0) et non sous la forme
c    call matc(ch,lda,10,10,name,0) dans le cas ou ch est une
c    matrice 10 lignes 10 colonnes.
c
c!sous programmes appeles
c     adr  cvname cvstr error putid stackg stackp (scilab)
c     len  max    min                             (fortran)
c!
      integer lda,m,n,job
      character*(*) chai(lda,*),name
      character*8 h
      include '../stack.h'
      integer adr
c
      integer i,j,k,k1,m1,n1
      integer il,it,blank,l,l4,lec,nc,srhs,id(nsiz)
      data blank/40/
c
      it=0
      if(job.ge.10) it=1
      lec=job-10*it
c
      nc=min(8,len(name))
      h=name(1:nc)
      call cvname(id,h,0)
      srhs=rhs
      rhs=0
c
      nc=len(chai(1,1))
      if(lec.ge.1) goto 10
c
c lecture : scilab -> fortran
c -------
c
      fin=-1
      call stackg(id)
      if(err.gt.0) return
      if(fin.eq.0) call putid(ids(1,pt+1),id)
      if(fin.eq.0) call error(4)
      if(err.gt.0) return
      il=adr(lstk(fin),0)
      if(istk(il).ne.10) call error(44)
      if(err.gt.0) return
c
      m=istk(il+1)
      n=istk(il+2)
      l=il+5
      k=l+m*n
      do 3 j=1,n
        do 2 i=1,m
          k1=istk(l)-istk(l-1)
          if(i.le.lda) then
            n1=min(k1,nc)
            chai(i,j)=' '
            call cvstr(n1,istk(k),chai(i,j),1)
          endif
          l=l+1
          k=k+k1
    2   continue
    3 continue
      m=min(m,lda)
c
      goto 99
c
c ecriture : fortran -> scilab
c --------
c
   10 continue
      if(top.eq.0) lstk(1)=1
      if(top+2.ge.bot) call error(18)
      if(err.gt.0) return
      top=top+1
      il=adr(lstk(top),0)
c
      m1=max(0,min(lda,m))
      n1=max(0,n)
      l=il+5
      err=l+m1*n1*(nc+1)-lstk(bot)
      if(err.gt.0) call error(17)
      if(err.gt.0) return
      istk(il)=10
      istk(il+1)=m1
      istk(il+2)=n1
      istk(il+4)=1
c
      k1=l+n1*m1
      do 13 j=1,n1
        do 12 i=1,m1
          do 11 k=1,nc
            call cvstr(1,istk(k1),chai(i,j)(k:k),0)
            k1=k1+1
   11     continue
          istk(l)=istk(l-1)+nc
          l=l+1
   12   continue
   13 continue
c
      lstk(top+1)=adr(l+(nc+1)*m1*n1,1)
      l4=lct(4)
      lct(4)=-1
      call stackp(id,0)
      lct(4)=l4
      if(err.gt.0) return
      goto 99
c
c
   99 rhs=srhs
c
      end
