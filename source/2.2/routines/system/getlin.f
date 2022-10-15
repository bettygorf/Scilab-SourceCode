      subroutine getlin(job)
c ====================================================================
c     get a new line
c ====================================================================
c
      include '../stack.h'
c
      integer lrecl,eol,slash,dot,blank,retu(6)
      integer r,quit(4)
      logical maj

      data eol/99/,dot/51/,blank/40/, retu/27,14,29,30,27,23/
      data slash/48/,lrecl/512/
      data quit/26,30,18,29/
c
      if(ddt.eq.4) then
         write(buf(1:10),'(2i5)') rio,job
         call basout(io,wte,' getlin rio:'//buf(1:5)//' job: '
     &              //buf(6:10))
      endif
c
      n=1
   10 l1=lpt(1)
      lct(8)=lct(8)+1
cxxx  if(job.eq.1) l1=lpt(6)
c     a ete remplace par la ligne suivante pour conserver les
c     delimiteurs de ligne (eol)
      if(job.eq.1) l1=lpt(6)+1
      if(job.eq.-1) then
         if (lpt(6).lt.0) then
            l=-lpt(6)
         else
            l=l1
         endif
      else
         l=l1
      endif
      r=0
      if(pt.gt.0) r=rstk(pt)
      if(job.lt.0) goto 12
      if(r.eq.503) goto 11
      if(macr.gt.0.and.fin.ne.2) then
         k=lpt(1)-(13+nsiz)
         il=lin(k+7)
c        test pour determiner si c'est la macro ou un exec qui appele getlin
         if(il.gt.0) goto 80
      endif
 11   call basin(ierr,rio,buf(1:lrecl),'*')
      if(ierr.ne.0) goto 50
   12 n = lrecl+1
   15 n = n-1
      if(n.le.0) goto 45
      if (buf(n:n) .eq. ' ') go to 15
      if (mod(lct(4),2) .eq. 1.and.rio.ne.rte) then
         call basout(io,wte,buf(1:n))
      endif
      if (rio.eq.rte) then
         if(wio.ne.0) call basout(io,wio,buf(1:n))
         if (hio.gt.0) call basout(io,hio,buf(1:n))
         lct(1)=1
      endif
c
      do 40 j = 1, n
         do 20 k = 1, csiz
         if (buf(j:j).eq.alfa(k)) then
            maj=.false.
            goto 30
         elseif(buf(j:j).eq.alfb(k)) then
            maj=.true.
            go to 30
         endif
   20    continue
         k = eol+1
         call xchar(buf(j:j),k)
         if (k .gt. eol) go to 10
         if (k .eq. eol) go to 45
         if (k .eq. -1) l = l-1
         if (k .le. 0) then
            call basout(io,wte,
     +           buf(j:j)//' is not a scilab character')
            go to 40
         endif
         maj=.false.
 30      k=k-1
c
c cas particuliers    :    //    ..
c        if(k.eq.colon.and.n.eq.1) goto 60
        if(buf(j+1:j+1).ne.buf(j:j)) goto 31
        if(k.eq.slash) goto 45
        if(k.ne.dot) goto 31
        if(j.eq.1) goto 70
c on a trouve ..
c c'est une ligne suite si il n'y a que des points ensuite ou //
        jj=j
 28     continue
        if(jj.eq.n)goto 29
        jj=jj+1
        if(buf(jj:jj).eq.buf(j:j)) goto 28
        if(buf(jj:jj).eq.' ') goto 28
        if(buf(jj:jj).ne.'/') goto 31
        if(jj.eq.n) goto 31
        if(buf(jj+1:jj+1).eq.'/') goto 29
        goto 31
c
 29     continue
c la ligne suivante est une ligne suite
        if(job.ne.-1) goto 11
c gestion des lignes suite dans le cas "scilab appele par fortran"
        fin=-1
        lpt(6)=-l
        return
c il n'y a pas de ligne suite ou alors il y a une erreur de syntaxe
   31 continue

         lin(l) = k
         if(maj) lin(l)=-k
         if (l.lt.lsiz) l = l+1
         if (l.ge.lsiz) then
            call error(108)
            return
         endif
   40 continue
c
   45 continue
      lin(l) = eol
      lin(l+1)=blank
      lpt(6) = l
      lpt(4) = l1
      lpt(3) = l1
      lpt(2) = l1
cc_ex      lct(1) = 0
      fin=0
      call getch
      return
c
   50 if (rio .eq. rte) go to 52
      call icopy(6,retu,1,lin(l),1)
      if(job.eq.1) call error(47)
      if(err.gt.0) return
c     call clunit(-rio,buf,0)
c     rio=rte
      l = l + 6
      go to 45
   52 continue
      call icopy(4,quit,1,lin(l),1)
      l = l + 4
      go to 45
c
c
   70 continue
      if (n.gt.2) then
         call xscion(iflag)
         if(iflag.eq.1) then
            call cvstr(n-2+10,lin(l),'unix_x('''//buf(3:n)//''');',job)
         else
            call cvstr(n-2+10,lin(l),'unix_w('''//buf(3:n)//''');',job)
         endif
         l=l+n-2+10
         call basout(io,wte,' ')
      endif
      goto 45
c
   80 k=lpt(1)-(13+nsiz)
      il=lin(k+7)
   81 if(istk(il).eq.eol) goto 82
      lin(l)=istk(il)
      l=l+1
      if(l.gt.lsiz) call error(26)
      if(err.gt.0) return
      il=il+1
      goto 81
   82 if(istk(il+1).ne.eol) goto 83
      lin(l)=eol
      l=l+1
      il=il+1
   83 lin(k+7)=il+1
      if(ddt .lt. 1 .or. ddt.gt.4) goto 45
      l2=l1
   84 n=l-l2
      n1=n
      if(n.le.lct(5)) then
               call cvstr(n,lin(l2),buf,1)
                      else
               n=lct(5)
               n1=n-3
               call cvstr(n1,lin(l2),buf,1)
               buf(n1+1:n1+3)='...'
               n1=n1-1
      endif
      call basout(io,wte,buf(1:n))
      l2=l2+n1+1
      if(l2.lt.l) goto 84
      goto 45
      end
