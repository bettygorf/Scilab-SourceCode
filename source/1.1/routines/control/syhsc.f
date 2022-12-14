      subroutine syhsc(n,m,a,na,b,mb,c,z,eps,wrk1,nwrk1,
     +                 wrk2,nwrk2,iwrk,niwrk,ierr)
c
c! calling sequence
c        subroutine syhsc(n,m,a,na,b,mb,c,z,wrk1,nwrk1,wrk2,nwrk2,
c     +                   iwrk,niwrk,ierr)
c
c        integer n,m,na,mb,nwrk1,nwrk2,niwrk,ierr
c        integer iwrk(niwrk)
c        double precision a(na,n),b(mb,m),c(na,m)
c        double precision z(mb,m),wrk1(nwrk1),wrk2(nwrk2)
c
c arguments in
c
c        n       integer
c                -order of the matrix  a.
c
c        m       integer
c                -order of the matrix  b.
c
c        a       double precision(n,n)
c                -the coefficient matrix  a  of the equation.
c                n.b.  a  is overwritten by this routine.
c
c        na      integer
c                -the declared first dimension of  a and c .
c
c        b       double precision(m,m)
c                -the coefficient matrix  b  of the equation.
c                n.b.  b  is overwritten by this routine.
c
c        mb      integer
c                -the declared first dimension of  b .
c
c        c       double precision(n,m)
c                -the coefficient matrix  c  of the equation.
c                n.b.  c  is overwritten by this routine.
c
c        nwrk1   integer
c                -the length of the internal vector  wrk1
c                nwrk1  must be at least  2*n**2  +  7*n
c
c        nwrk2   integer
c                -the length of the internal vector  wrk2
c                nwrk2  must be at least  max(n,m)
c
c        niwrk   integer
c                -the length of the internal vector  iwrk
c                niwrk  must be at least  4*n
c
c arguments out
c
c        c       double precision(n,m)
c                -on return, the solution matrix, x  is contained in c
c
c        z       double precision(m,m)
c                -on return, z  contains the orthogonal matrix used
c                to transform  transpose(b) to real upper schur form.
c
c        ierr    integer
c                -error indicator
c
c                ierr = 0        successful return
c
c                ierr in (1,m   ierr-th eigenvalue of  b  has not been
c                                determined after 30 iterations.
c
c                ierr > m   a singular matrix was encountered whilst
c                           solving for the (ierr-m)th column of  x
c
c!working space
c
c        wrk1    double precision(nwrk1)
c                -where  nwrk1 .ge. 2*n**2 + 7*n
c
c        wrk2    double precision(nwrk2)
c                -where  nwrk2 .ge. max(n,m)
c
c        iwrk    integer(niwrk)
c                -where  niwrk .ge. 4*n
c
c!purpose
c
c        to solve the continuous-time sylvester equation
c                ax + xb = c
c
c!method
c
c        a  is transformed to upper hessenberg form, and the transpose
c        of  b is transformed to real upper schur form using orthogonal
c        transformations. the matrix  c  is also multiplied by these
c        transformation matrices, and the solution of this transformed
c        system is computed. this solution is then multiplied by the
c        transformation matrices in order to obtain the solution to
c        the original problem.
c
c!reference
c
c        g.golub, s.nash, and c.f.vanloan," a hessenberg-schur method
c        for the problem  ax + xb = c ",ieee trans. auto. control,
c        vol. ac-24, no. 6, pp. 909-912 (1979).
c
c!auxiliary routines
c
c       orthes,ortran (eispack)
c       hqror2,transf,nsolve,hesolv,backsb,n2solv,h2solv,backs2
c       irow1,irow2,lrow2
c
c!origin:
c
c                g.golub,s.nash,c.van loan, dept.comp.sci.,stanford
c                university,california                january 1982
c
c!
c********************************************************************
c
        integer n,m,na,mb,nwrk1,nwrk2,niwrk,ierr
        integer iwrk(niwrk)
      double precision a(na,n),b(mb,m),c(na,m),z(mb,m)
      double precision wrk1(nwrk1),wrk2(nwrk2)
c
c
      double precision eps,t,swop,reps

        do 5 i = 1,m
                do 5 j = i,m
                        swop = b(i,j)
                        b(i,j) = b(j,i)
                        b(j,i) = swop
 5      continue
c
      call orthes(mb,m,1,m,b,wrk2)
      call ortran(mb,m,1,m,b,wrk2,z)
       call hqror2(mb,m,1,m,b,t,t,z,ierr,11)
c
        call orthes(na,n,1,n,a,wrk2)
c
        call transf(a,wrk2,1,c,z,0,n,m,na,mb,wrk1,nwrk1)
c
        reps = eps*m*m*n*n
        ind = m - 1
        if(ind.eq.0) go to 40
10      if(abs(b(ind+1,ind)).le.reps) go to 20
c
        call n2solv(a,b,c,wrk1,nwrk1,mb,m,na,n,ind,iwrk,niwrk,
     +              reps,ierr)
c
        if(ierr.ne.0) return
        go to 30
c
20      call nsolve(a,b,c,wrk1,nwrk1,mb,m,na,n,ind,iwrk,niwrk,
     +              reps,ierr)
c
        if(ierr.ne.0) return
30      if (ind.gt.0) go to 10
c
40      if(ind.eq.0)call nsolve(a,b,c,wrk1,nwrk1,mb,m,na,n,ind,
     +                              iwrk,niwrk,reps,ierr)
c
        call transf(a,wrk2,0,c,z,1,n,m,na,mb,wrk1,nwrk1)
c
        return
        end

        subroutine transf(a,ort,it1,c,v,it2,m,n,mdim,ndim,d,nwrk1)
c!
        integer i,it1,it2,j,k,k1,k2,kk,m,mdim,n,nwrk1
        double precision v(ndim,n),c(mdim,n),a(mdim,m),ort(m),d(nwrk1)
        double precision g
        m2=m-2
        if(m2.le.0) go to 45
        do 40 kk=1,m2
        k=m2-kk+1
        if(it1.eq.1) k=kk
        k1=k+1
        if(a(k1,k).eq.0.0d+0) go to 40
        d(k1)=ort(k1)
        k2=k+2
        do 10 i=k2,m
        d(i)=a(i,k)
10      continue
        do 30 j=1,n
        g=0.0d+0
        do 20 i=k1,m
        g=g+d(i)*c(i,j)
20      continue
        g=g/ort(k1)/a(k1,k)
        do 30 i=k1,m
        c(i,j)=c(i,j)+g*d(i)
30      continue
40      continue
45      do 60 i=1,m
        do 50 j=1,n
        d(j)=0.0d+0
        do 50 k=1,n
        if(it2.eq.0) d(j)=d(j)+c(i,k)*v(k,j)
        if(it2.eq.1) d(j)=d(j)+c(i,k)*v(j,k)
50      continue
        do 60 j=1,n
        c(i,j)=d(j)
60      continue
        return
        end
        subroutine nsolve(a,b,c,d,nwrk1,ndim,n,mdim,m,ind,ipr,niwrk,
     +            reps,ierr)
c% calling sequence
c       subroutine nsolve(a,b,c,d,nwrk1,ndim,n,mdim,m,ind,ipr,niwrk,
c     +           reps,ierr)
c       integer nwrk1,niwrk
c       integer i,i1,ierr,ind,ipr(niwrk),irow1,j,m,m1,mdim,n,ndim,mfin
c       double precision a(mdim,m),b(ndim,n),c(mdim,n),d(nwrk1),reps
c% purpose
c      this routine is only to be called from syhsc
c%
        integer nwrk1,niwrk
        integer i,i1,ierr,ind,ipr(niwrk),irow1,j,m,m1,mdim,n,ndim,mfin
        double precision a(mdim,m),b(ndim,n),c(mdim,n),d(nwrk1),reps
c
        if(ind.lt.n-1) call backsb(c,b,ind,n,m,mdim,ndim)
c
        mfin=(m*(m+1))/2+m
        do 20 i=1,m
        m1=irow1(i,m)
        i1=i-1
        if(i.eq.1)i1=1
        do 10 j=i1,m
                ip = m1+j - i1 + 1
                d(ip)=a(i,j)
10      continue
        j=m1+2
        if(i.eq.1)j=j-1
        d(j)=d(j)+b(ind+1,ind+1)
        ip = mfin + i
        d(ip)=c(i,ind+1)
20      continue
c
        call hesolv(d,nwrk1,ipr,niwrk,m,reps,ierr)
c
        if(ierr.ne.0) go to 40
        do 30 i=1,m
        ip = ipr(i)
        c(i,ind+1)=d(ip)
30      continue
        ind=ind-1
        return
40      ierr=n+ind-1
        return
        end
        subroutine hesolv(d,nwrk1,ipr,niwrk,m,reps,ierr)
        integer i,i1,i2,ierr,ipr(niwrk),irow1,j,j1,k,mfin
        double precision d(nwrk1),mult,reps
        ierr=0
        mfin=(m*(m+1))/2+m
        do 10 i=1,m
        ip = m + i
        ipr(ip)=irow1(i,m)
        ipr(i)=i+mfin
10      continue
        m1=m-1
        if(m.eq.1) go to 35
        do 30 i=1,m1
        ip = m + i
        ipl = ipr(ip)
        ipi = ipr(ip+1)
        if(abs(d(ipl+1)).gt.abs(d(ipi+1)))go to 20
        ipr(ip)=ipr(ip+1)
        ipr(ip+1)=ipl
        k=ipr(i)
        ipr(i)=ipr(i+1)
        ipr(i+1)=k
20      if(abs(d(ipr(m+i)+1)).lt.reps) go to 60
        ipr(m+i+1)=ipr(m+i+1)+1
        mult=d(ipr(m+i+1))/d(ipr(m+i)+1)
        d(ipr(i+1))=d(ipr(i+1))-mult*d(ipr(i))
        i1=i+1
        do 30 j=i1,m
        d(ipr(m+i+1)+j-i)=d(ipr(m+i+1)+j-i)-
     *                  mult*d(ipr(m+i)+j+1-i)
30      continue
35      if(abs(d(ipr(m+m)+1)).lt.reps) go to 60
        d(ipr(m))=d(ipr(m))/d(ipr(m+m)+1)
        if(m1.eq.0) return
        do 50 i1=1,m1
        i=m-i1
        i2=i+1
        mult=0.0d+0
        do 40 j1=i2,m
        j=j1-i2+2
        mult=mult+d(ipr(j1))*d(ipr(m+i)+j)
40      continue
        d(ipr(i))=(d(ipr(i))-mult)/d(ipr(m+i)+1)
50      continue
        return
60      ierr=-1
        return
        end
        subroutine backsb(c,b,ind,n,m,mdim,ndim)
        integer i,ind,ind1,ind2,j,m,mdim,n,ndim
        double precision b(ndim,n),c(mdim,n)
        ind1=ind+1
        ind2=ind+2
        do 10 i=ind2,n
        do 10 j=1,m
        c(j,ind1)=c(j,ind1)-b(ind1,i)*c(j,i)
10      continue
        return
        end
        subroutine n2solv(a,b,c,d,nwrk1,ndim,n,mdim,m,ind,ipr,niwrk,
     +                    reps,ierr)
c% calling sequence
c       subroutine n2solv(a,b,c,d,nwrk1,ndim,n,mdim,m,ind,ipr,niwrk,
c    +                    reps,ierr)
c       integer i,i1,ierr,ind,nwrk1,niwrk,irow2,j,j1,j2,k,lrow2,m,m1
c       integer mdim,n,ndim,mfin,ipr(niwrk)
c       double precision a(mdim,m),b(ndim,n),c(mdim,n),d(nwrk1),reps
c%purpose
c      this routine is only to be called from syhsc
c%
c
        integer i,i1,ierr,ind,nwrk1,niwrk,irow2,j,j1,j2,k,lrow2,m,m1
        integer mdim,n,ndim,mfin,ipr(niwrk)
        double precision a(mdim,m),b(ndim,n),c(mdim,n),d(nwrk1),reps
c
        if(ind.lt.n-1) call backs2(c,b,ind,n,m,mdim,ndim)
c
        m2=2*m
        mfin=(m2*(m2+1))/2+4*m
        do 20 i=1,m
        m1=irow2(2*i-1,m)
        k=lrow2(2*i-1,m)
        i1=i-1
        if(i.eq.1) i1=1
        do 10 j=i1,m
        j1=2*(j-i1+1)+m1
        j2=1
        if(m1.eq.0) j2=0
        j2=j1+k-j2
        d(j1-1)=a(i,j)
        d(j1)=0.0d+0
        d(j2)=a(i,j)
        d(j2-1)=0.0d+0
10      continue
        j1=m1+3
        if(i.eq.1) j1=j1-2
        d(j1)=d(j1)+b(ind,ind)
        d(j1+1)=d(j1+1)+b(ind,ind+1)
        if(i.ne.1) j1=m1+2
        j1 = j1 + k
        d(j1)=d(j1)+b(ind+1,ind)
        d(j1+1)=d(j1+1)+b(ind+1,ind+1)
        ip = 2*i + mfin
        d(ip)=c(i,ind+1)
        d(ip-1)=c(i,ind)
20      continue
c
        call h2solv(d,nwrk1,ipr,niwrk,m,reps,ierr)
c
        if(ierr.ne.0) go to 40
        do 30 i=1,m
        c(i,ind)=d(ipr(2*i-1))
        c(i,ind+1)=d(ipr(2*i))
30      continue
        ind=ind-2
        return
40      ierr=-ind-1
        return
        end
        subroutine h2solv(d,nwrk1,ipr,niwrk,m,reps,ierr)
        integer i,i1,i2,ierr,ipr(niwrk),irow2,j,j1,k,k1,l,m21,mfin
        double precision d(nwrk1),ddmax,reps
        ierr=0
        m2=2*m
        mfin=(m2*(m2+1))/2+4*m
        do 10 i=1,m2
        ipr(m2+i)=irow2(i,m)
        ipr(i)=i+mfin
10      continue
        m21=m2-1
        do 40 i=1,m21
        i1=2
        if(i.eq.m21) i1=1
        l=0
        ddmax=abs(d(ipr(m2+i)+1))
        do 20 j=1,i1
        if(abs(d(ipr(m2+j+i)+1)).le.ddmax)go to 20
        ddmax=abs(d(ipr(m2+j+i)+1))
        l=j
20      continue
        if(ddmax.le.reps)go to 80
        if(l.eq.0) go to 30
        k=ipr(m2+i)
        ipr(m2+i)=ipr(m2+l+i)
        ipr(m2+l+i)=k
        k=ipr(i)
        ipr(i)=ipr(i+l)
        ipr(i+l)=k
30      continue
        ipr(m2+i+1)=ipr(m2+i+1)+1
        if(i.ne.m21) ipr(m2+i+2)=ipr(m2+i+2)+1
        ip1=i+1
        do 40 j=1,i1
        ddmax=d(ipr(m2+i+j))/d(ipr(m2+i)+1)
        d(ipr(i+j))=d(ipr(i+j))-ddmax*d(ipr(i))
        do 40 k1=ip1,m2
        k=k1-i
        d(ipr(m2+i+j)+k)=d(ipr(m2+i+j)+k)-
     *                  ddmax*d(ipr(m2+i)+1+k)
40      continue
        if(abs(d(ipr(m2+m2)+1)).le.reps) go to 80
        d(ipr(m2))=d(ipr(m2))/d(ipr(m2+m2)+1)
        do 60 i1=1,m21
        i=m2-i1
        i2=i+1
        ddmax=0.0d+0
        do 50 j1=i2,m2
        j=j1-i2+2
        ddmax=ddmax+d(ipr(j1))*d(ipr(m2+i)+j)
50      continue
        d(ipr(i))=(d(ipr(i))-ddmax)/d(ipr(m2+i)+1)
60      continue
70      return
80      ierr=-1
        go to 70
        end
        subroutine backs2(c,b,ind,n,m,mdim,ndim)
        integer i,ind,ind1,ind2,j,m,mdim,n,ndim
        double precision b(ndim,n),c(mdim,n)
        ind1=ind+1
        ind2=ind+2
        do 10 i=ind2,n
        do 10 j=1,m
        c(j,ind1)=c(j,ind1)-b(ind1,i)*c(j,i)
        c(j,ind)=c(j,ind)-b(ind,i)*c(j,i)
10      continue
        return
        end
