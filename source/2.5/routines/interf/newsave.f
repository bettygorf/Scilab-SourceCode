      
      subroutine intsave
c     Copyright INRIA
      include '../stack.h'
      logical opened,ptover,cremat
      integer fd,vol,top0,srhs
      double precision res
      integer iadr,sadr
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if(rstk(pt).eq.905) goto 24
      if(rhs.lt.1) then
         call error(42)
         return
      endif
      if(lhs.gt.1) then
         call error(41)
         return
      endif
      top0=top-rhs


      call v2cunit(top0+1,'wb',fd,opened,ierr) 
      if(ierr.gt.0) return
      if(ierr.lt.0) then
c     file has been opened by fortran, use oldsave (compatibility)
         call oldsave
         return
      endif

      if(rhs.eq.1) then
c     .  save all variables
         if(bot.gt.bbot-1) goto 40
         kmin=bot
         kmax=bbot-1
      else
         kmin=top0+2
         kmax=top
      endif

c     loop on variables to save
      k=kmin-1
 20   k=k+1
      il=iadr(lstk(k))
      vol=lstk(k+1)-lstk(k)
 21   call savevar(fd,idstk(1,k),il,vol,ierr)
      if(fun.ge.0) goto 25
c     overloaded save function
      if ( ptover(1,psiz)) return
      ilrec         = iadr(lstk(top+1))
      err=sadr(ilrec+7)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      istk(ilrec)   = lstk(top+1)
      istk(ilrec+1) = fd
      istk(ilrec+2) = kmin
      istk(ilrec+3) = kmax
      istk(ilrec+4) = k
      istk(ilrec+5) = top0
      istk(ilrec+6) = vol
      lstk(top+1)=sadr(ilrec+7)
      rstk(pt)=905
      pstk(pt)=ilrec
      ilv=-fun
      vol=fin
      call funnam(ids(1,pt+1),'save',ilv)
      call copyvar(ilv,vol)
c     create a variable with fd
      top=top+1
      if(.not.cremat('save',top,0,1,1,lr,lc)) return
      stk(lr)=fd
      rhs=2
      fun=-1
      return
c     *call* parse
 24   continue
      ilrec=pstk(pt)
      lstk(top+1)= istk(ilrec)  
      fd         = istk(ilrec+1)
      kmin       = istk(ilrec+2)
      kmax       = istk(ilrec+3)
      k          = istk(ilrec+4)
      top0       = istk(ilrec+5)
      vol        = istk(ilrec+6)
      pt=pt-1 
      if(rstk(pt).eq.911) goto 21

 25   if(k.lt.kmax) goto 20


 40   if (.not.opened) then
         call mclose (fd,res)
      endif
c     return a nul variable
      top=top0+1
      il=iadr(lstk(top))
      istk(il)=0
      lstk(top+1)=lstk(top)+1
      return
      end

      subroutine intload(id1,k1)
c     Copyright INRIA
c     Loads variables stored in a file. if id1 is a valid variable name
c     (id1(1).ne.blank) and if this variable if loaded k1 ist set to its
c     index in the stack
c
      include '../stack.h'
      integer id1(nsiz),k1
      logical opened,cremat,ptover,eqid
      integer fd,id(nsiz),semi,blank,top0,endian,getendian,it,ssym
      double precision res
      integer iadr,sadr
      data semi/43/,blank/40/
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      if (rstk(pt).eq.906) goto 24
      k1=0
c
      if(rhs.lt.1) then
         call error(42)
         return
      endif
      if(lhs.gt.1) then
         call error(41)
         return
      endif
      top0=top
      top=top-rhs+1
      
      call v2cunit(top,'rb',fd,opened,ierr)
      if(ierr.gt.0) return
      if(ierr.lt.0) then
c     compatibility (file opened by fortran)
         top=top0
         call oldload
         k1=fin
         return
      endif
c     test for compatibility
      endian=getendian()
      call mgetnc (fd,it,1,'il'//char(0),ierr)
      if(endian.eq.1.and.it.eq.28.or.
     $     endian.eq.0.and.it.eq.469762048) then
c     .  old mode
         if(.not.opened)  call mclose (fd,res)
         call oldload
         k1=fin
         return
      else
         call mseek(fd,0,'set'//char(0),ierr)
      endif

      
      if(rhs.gt.1) then
         ilt=iadr(lstk(top0+1))
         err=sadr(ilt+nsiz*rhs-1)-lstk(bot)
         if(err.gt.0) then
            call error(17)
            return
         endif
c     .  get table of requested variable names
         do 01 i=1,rhs-1
            il=iadr(lstk(top+i))
            if(istk(il).lt.0) il=iadr(istk(il+1))
            if(istk(il).ne.10) then
               err=i+1
               call error(55)
               return
            endif
            lc=il+5+istk(il+1)*istk(il+2)
            nc=min(nlgh,istk(il+5)-1)
            call namstr(istk(ilt+(i-1)*nsiz),istk(lc),nc,0)
 01      continue
         il=iadr(lstk(top))
         call icopy(nsiz*rhs,istk(ilt),1,istk(il),1)
         lstk(top+1)=sadr(il+nsiz*rhs)
         ilt=il
      endif

      top=top+1

c     load all variables stored in a file
      il=iadr(lstk(top))
      kvar=0
 10   continue
 21   call loadvar(fd,id,il,nn,ierr)
      if(ierr.gt.0) return
      if(ierr.lt.0) goto 50
      if(fun.ge.0) then
         lstk(top+1)=sadr(il+nn)
         goto 26
      endif
c     overloaded save function
      if ( ptover(1,psiz)) return
      rstk(pt)=906
      pstk(pt)=rhs
      ids(1,pt)=kvar
      ilv=-fun
      call funnam(ids(1,pt+1),'load',ilv)
c     create a variable with fd
      top=top+1
      if(.not.cremat('load',top,0,1,1,lr,lc)) return
      stk(lr)=fd
      rhs=1
      fun=-1
      return
c     *call* parse
 24   continue
      rhs=pstk(pt)
      kvar=ids(1,pt)
      pt=pt-1 
      if(rstk(pt).eq.912) goto 21
      goto 26

 26   continue
      if(rhs.gt.1) then
c     .  check if loaded variable is required
         do 27 i=1,rhs-1
            if(eqid(id,istk(ilt+(i-1)*nsiz))) then
c     .        yes, remove it out of the table and save it
               istk(ilt+(i-1)*nsiz)=0
c     .        rewind the file
               if(.not.opened)  call mseek(fd,0,'set'//char(0),ierr)
               goto 30
            endif
 27      continue
c     .  no skip it
         goto 10
      endif  

 30   ssym=sym
      sym = semi
      srhs=rhs
      rhs = 0
      call stackp(id,1)
      if (id1(1).ne.blank) then
         if(eqid(id,id1)) k1=fin
      endif
      rhs=srhs
      sym=ssym
      kvar=kvar+1
      top = top + 1
      if(kvar.eq.rhs-1) goto 50
      goto 10

c     close the file if necessary
 50   if (.not.opened) then
         call mclose (fd,res)
      endif
      top=top-1
c     return a nul variable
      il=iadr(lstk(top))
      istk(il)=0
      lstk(top+1)=lstk(top)+1
      return
      end

      subroutine savevar(fd,id,il,vol,ierr)
c     Copyright INRIA
      include '../stack.h'
c
      integer fd,id(nsiz),vol
      integer iadr
      logical cremat
      character*3 fmti,fmtd
c
c
      iadr(l)=l+l-1
c      sadr(l)=(l/2)+1
c

      fmti='il'//char(0)
      fmtd='dl'//char(0)
c
      if(rstk(pt).eq.911) then
         il1=il
         if(istk(il1).lt.0) il1=iadr(istk(il1+1))
         call savelist(fd,il1,ierr)
         return
      endif

      il1=il
      if(istk(il1).lt.0) il1=iadr(istk(il1+1))

c     write id and type
      call mputnc (fd,id,nsiz,fmti,ierr)
      if(ierr.ne.0) return
      call mputnc (fd,istk(il1),1,fmti,ierr)
      if(ierr.ne.0) return

      if(istk(il1).eq.1) then
         call savemat(fd,il1,ierr)
      elseif(istk(il1).eq.2.or.istk(il1).eq.129) then
         call savepol(fd,il1,ierr)
      elseif(istk(il1).eq.4) then
         call savebool(fd,il1,ierr)
      elseif(istk(il1).eq.5) then
         call savesparse(fd,il1,ierr)
      elseif(istk(il1).eq.6) then
         call savespb(fd,il1,ierr)
      elseif(istk(il1).eq.7) then
         call savemsp(fd,il1,ierr)
      elseif(istk(il1).eq.8) then
         call saveint(fd,il1,ierr)
      elseif(istk(il1).eq.10) then
         call savestr(fd,il1,ierr)
      elseif(istk(il1).eq.11) then
         call savefun(fd,il1,ierr)
      elseif(istk(il1).eq.13) then
         call savecfun(fd,il1,ierr)
      elseif(istk(il1).eq.14) then 
         call savelib(fd,il1,ierr)
      elseif(istk(il1).ge.15.and.istk(il1).le.17) then
 10      call savelist(fd,il1,ierr)
      elseif(istk(il1).eq.128) then 
         call saveptr(fd,il1,ierr)
      else
c     .  call an external function
         fun=-il1
         fin=vol
      endif
      return
      end

      subroutine loadvar(fd,id,il,nn,ierr)
c     Copyright INRIA
      include '../stack.h'
c
      integer fd,id(nsiz),vol
      integer iadr
      logical cremat
      character*3 fmti,fmtd
c
c
      iadr(l)=l+l-1
c      sadr(l)=(l/2)+1
c

      fmti='il'//char(0)
      fmtd='dl'//char(0)
c
      if(rstk(pt).eq.912) then
         il1=il
         if(istk(il1).lt.0) il1=iadr(istk(il1+1))
         call loadlist(fd,il1,nn,ierr)
         return
      endif
c

      il1=il
c     read id and type
      call mgetnc (fd,id,nsiz,fmti,ierr)
      if(ierr.ne.0) return
      call mgetnc (fd,istk(il1),1,fmti,ierr)
      if(ierr.ne.0) return

      if(istk(il1).eq.1) then
         call loadmat(fd,il1,nn,ierr)
      elseif(istk(il1).eq.2.or.istk(il1).eq.129) then
         call loadpol(fd,il1,nn,ierr)
      elseif(istk(il1).eq.4) then
         call loadbool(fd,il1,nn,ierr)
      elseif(istk(il1).eq.5) then
         call loadsparse(fd,il1,nn,ierr)
      elseif(istk(il1).eq.6) then
         call loadspb(fd,il1,nn,ierr)
      elseif(istk(il1).eq.7) then
         call loadmsp(fd,il1,nn,ierr)
      elseif(istk(il1).eq.8) then
         call loadint(fd,il1,nn,ierr)
      elseif(istk(il1).eq.10) then
         call loadstr(fd,il1,nn,ierr)
      elseif(istk(il1).eq.11) then
         call loadfun(fd,il1,nn,ierr)
      elseif(istk(il1).eq.13) then
         call loadcfun(fd,il1,nn,ierr)
      elseif(istk(il1).eq.14) then 
         call loadlib(fd,il1,nn,ierr)
      elseif(istk(il1).ge.15.and.istk(il1).le.17) then   
         call loadlist(fd,il1,nn,ierr)
      elseif(istk(il1).eq.128) then 
         call loadptr(fd,il1,nn,ierr)
      else
         fun=-il1
      endif
      if(err.gt.0) ierr=1
      return
      end

      subroutine savelist(fd,il,ierr)
c     Copyright INRIA
c     Save a matrix of numbers
      include '../stack.h'
c
      integer fd
      logical ptover,cremat
      integer iadr,sadr
      character*3 fmti,fmtd
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      fmti='il'//char(0)
      fmtd='dl'//char(0)
      if(rstk(pt).eq.911) then
c     .  manage recursion
         n=ids(1,pt)
         il=ids(2,pt)
         i=ids(3,pt)
         pt=pt-1
         l=sadr(il+n+3)
         il1=iadr(l-1+istk(il+1+i))
         if(istk(il1).lt.0) il1=iadr(istk(il1+1))
         goto 20
      endif
c
 10   n=istk(il+1)
c     write list header
      call mputnc (fd,istk(il+1),n+2,fmti,ierr)
      if(ierr.ne.0) return
c     write the elements
      l=sadr(il+n+3)
      i=0
 20   continue
      i=i+1
      if(i.gt.n) goto 30
      if(istk(il+2+i)-istk(il+1+i).eq.0) goto 20
      il1=iadr(l-1+istk(il+1+i))
      if(istk(il1).lt.0) il1=iadr(istk(il1+1))
c     write type
      call mputnc (fd,istk(il1),1,fmti,ierr)
      if(ierr.ne.0) return

      if(istk(il1).eq.1) then
         call savemat(fd,il1,ierr)
      elseif(istk(il1).eq.2.or.istk(il1).eq.129) then
         call savepol(fd,il1,ierr)
      elseif(istk(il1).eq.4) then
         call savebool(fd,il1,ierr)
      elseif(istk(il1).eq.5) then
         call savesparse(fd,il1,ierr)
      elseif(istk(il1).eq.6) then
         call savespb(fd,il1,ierr)
      elseif(istk(il1).eq.7) then
         call savemsp(fd,il1,ierr)
      elseif(istk(il1).eq.8) then
         call saveint(fd,il1,ierr)
      elseif(istk(il1).eq.10) then
         call savestr(fd,il1,ierr)
      elseif(istk(il1).eq.11) then
         call savefun(fd,il1,ierr)
      elseif(istk(il1).eq.13) then
         call savecfun(fd,il1,ierr)
      elseif(istk(il1).eq.14) then 
         call savelib(fd,il1,ierr)
      elseif(istk(il1).ge.15.and.istk(il1).le.17) then   
c     .  a sublist
         if(istk(il1).lt.0) il1=iadr(istk(il1+1))
         if (ptover(1,psiz)) return
         rstk(pt)=408
         ids(1,pt)=n
         ids(2,pt)=il
         ids(3,pt)=i
         il=il1
         goto 10
      elseif(istk(il1).eq.128) then 
         call saveptr(fd,il1,ierr)
      else
c     .  call an external function
         if (ptover(1,psiz)) return
         rstk(pt)=911
         ids(1,pt)=n
         ids(2,pt)=il
         ids(3,pt)=i

         fun=-il1
         fin=istk(il+2+i)-istk(il+1+i)
         return
      endif
      if(ierr.ne.0) return
      goto 20
c     
 30   continue
c     end of current list reached
      if(rstk(pt).ne.408) goto 40
      n=ids(1,pt)
      il=ids(2,pt)
      i=ids(3,pt)
      pt=pt-1
      l=sadr(il+n+3)
      il1=iadr(l-1+istk(il+1+i))
      if(istk(il1).lt.0) il1=iadr(istk(il1+1))
      goto 20
 40   continue
c     finish
      return
      end

      subroutine loadlist(fd,il,nn,ierr)
c     Copyright INRIA
c     Save a matrix of numbers
      include '../stack.h'
c
      integer fd
      logical ptover,cremat
      integer iadr,sadr
      character*3 fmti,fmtd
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      fmti='il'//char(0)
      fmtd='dl'//char(0)
c
      il1=il
      if(rstk(pt).eq.912) then
c     .  manage recursion
         n=ids(1,pt)
         il=ids(2,pt)
         i=ids(3,pt)
         il0=ids(4,pt)
         pt=pt-1
         l=sadr(il+n+3)
         il1=iadr(l-1+istk(il+1+i))
         lt=lstk(top)
         l1=sadr(il1)
         nne=lstk(top+1)-lt
         if(l1.ne.lt) call dcopy(lstk(top+1)-lt,stk(lt),1,stk(l1),1)
         istk(il+2+i)=istk(il+1+i)+nne
         nne=2*nne
         top=top-1
         goto 20
      endif

      
 10   il0=il
c     read list header without type
      err=sadr(il+3)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call mgetnc (fd,istk(il+1),2,fmti,ierr)
      if(ierr.ne.0) return
      n=istk(il+1)
      err=sadr(il+3+n)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call mgetnc (fd,istk(il+3),n,fmti,ierr)
      if(ierr.ne.0) return
      il1=il+3+n
c     read the elements
      l=sadr(il1)
      nne=0
      i=0
 20   continue
      i=i+1

      if(i.gt.n) goto 30
      if(istk(il+2+i)-istk(il+1+i).eq.0) goto 20
      il1=iadr(l-1+istk(il+1+i))

c     read  type
      call mgetnc (fd,istk(il1),1,fmti,ierr)
      if(ierr.ne.0) return

      if(istk(il1).eq.1) then
         call loadmat(fd,il1,nne,ierr)
      elseif(istk(il1).eq.2.or.istk(il1).eq.129) then
         call loadpol(fd,il1,nne,ierr)
      elseif(istk(il1).eq.4) then
         call loadbool(fd,il1,nne,ierr)
      elseif(istk(il1).eq.5) then
         call loadsparse(fd,il1,nne,ierr)
      elseif(istk(il1).eq.6) then
         call loadspb(fd,il1,nne,ierr)
      elseif(istk(il1).eq.7) then
         call loadmsp(fd,il1,nne,ierr)
      elseif(istk(il1).eq.8) then
         call loadint(fd,il1,nn,ierr)
      elseif(istk(il1).eq.10) then
         call loadstr(fd,il1,nne,ierr)
      elseif(istk(il1).eq.11) then
         call loadfun(fd,il1,nne,ierr)
      elseif(istk(il1).eq.13) then
         call loadcfun(fd,il1,nne,ierr)
      elseif(istk(il1).eq.14) then 
         call loadlib(fd,il1,nne,ierr)
      elseif(istk(il1).ge.15.and.istk(il1).le.17) then   
c     .  a sublist 
         if (ptover(1,psiz)) return
         rstk(pt)=408
         ids(1,pt)=n
         ids(2,pt)=il
         ids(3,pt)=i
         ids(4,pt)=il0
         il=il1
         goto 10
      elseif(istk(il1).eq.128) then 
         call loadptr(fd,il1,nne,ierr)
      else
c     .  call an external function
         if (ptover(1,psiz)) return
         rstk(pt)=912
         ids(1,pt)=n
         ids(2,pt)=il
         ids(3,pt)=i
         ids(4,pt)=il0
         fun=-il1
c     *call* parse
         return
      endif
      istk(il+2+i)=sadr(il1+nne)-l+1
      if(err.gt.0) ierr=1
      if(ierr.ne.0) return
      goto 20
c     
 30   continue
c     end of current list reached
      if(rstk(pt).ne.408) goto 40
      ll=sadr(il+n+3)
      nne=iadr(ll-1+istk(il+2+n))-il
c
      n=ids(1,pt)
      il=ids(2,pt)
      i=ids(3,pt)
      il0=ids(4,pt)
      pt=pt-1
      l=sadr(il+n+3)
      goto 20

 40   continue
c     finish
      nn=il1+nne-il0
      return
      end

      subroutine savemat(fd,il,ierr)
c     Copyright INRIA
c     Save a matrix of numbers
      include '../stack.h'
c
      integer fd
      character*3 fmti,fmtd
      integer sadr
c
c      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      fmti='il'//char(0)
      fmtd='dl'//char(0)
c
c     write matrix header type excluded
      call mputnc (fd,istk(il+1),3,fmti,ierr)
      if(ierr.ne.0) return
c     write matrix elements
      mn=istk(il+1)*istk(il+2)*(istk(il+3)+1)
      call mputnc(fd,stk(sadr(il+4)),mn,fmtd,ierr)
      return
      end

      subroutine loadmat(fd,il,n,ierr)
c     Copyright INRIA
c     Save a matrix of numbers
      include '../stack.h'
      integer fd
      character*3 fmti,fmtd
      integer sadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      fmti='il'//char(0)
      fmtd='dl'//char(0)

c     read matrix header without type
      err=sadr(il+4)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call mgetnc (fd,istk(il+1),3,fmti,ierr)
      if(ierr.ne.0) return
c     read matrix elements
      mn=istk(il+1)*istk(il+2)*(istk(il+3)+1)
      err=sadr(il+4)+mn-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      l=sadr(il+4)
      call mgetnc(fd,stk(l),mn,fmtd,ierr)
      n=iadr(l+mn)-il
c      n=4+2*mn
      return
      end

      subroutine savepol(fd,il,ierr)
c     Copyright INRIA
c     Save a matrix of polynomials
      include '../stack.h'
c
      integer fd
      character*3 fmti,fmtd
      integer sadr
c
c      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      fmti='il'//char(0)
      fmtd='dl'//char(0)
c
c     write matrix header without type
      mn=istk(il+1)*istk(il+2)
      call mputnc (fd,istk(il+1),8+mn,fmti,ierr)
      if(ierr.ne.0) return
c     write polynomials coefficients
      mn1=(istk(il+8+mn)-1)*(istk(il+3)+1)
      call mputnc(fd,stk(sadr(il+9+mn)),mn1,fmtd,ierr)
      return
      end

      subroutine loadpol(fd,il,n,ierr)
c     Copyright INRIA
c     Load a matrix of polynomials
      include '../stack.h'
      integer fd
      character*3 fmti,fmtd
      integer sadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      fmti='il'//char(0)
      fmtd='dl'//char(0)

c     read matrix header without type
      err=sadr(il+7)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif

      call mgetnc (fd,istk(il+1),7,fmti,ierr)
      if(ierr.ne.0) return
c
      mn=istk(il+1)*istk(il+2)
      err=sadr(il+8+mn)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call mgetnc (fd,istk(il+8),1+mn,fmti,ierr)
      if(ierr.ne.0) return

c     read polynomials coefficients
      mn1=(istk(il+8+mn)-1)*(istk(il+3)+1)
      err=sadr(il+9+mn)+mn1-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      l=sadr(il+9+mn)
      call mgetnc(fd,stk(l),mn1,fmtd,ierr)
      n=iadr(l+mn1)-il
c      n=9+mn+2*mn1
      return
      end


      subroutine savestr(fd,il,ierr)
c     Copyright INRIA
c     Save a matrix of strings
      include '../stack.h'
c
      integer fd

      character*2 fmti,fmtc
c
c      iadr(l)=l+l-1
c      sadr(l)=(l/2)+1
c
      fmti='il'//char(0)
      fmtc='c'//char(0)
c
c     write matrix header  without type
      mn=istk(il+1)*istk(il+2)
      call mputnc (fd,istk(il+1),4+mn,fmti,ierr)
      if(ierr.ne.0) return
c     write characters
      mn1=istk(il+4+mn)-1
      call mputnc(fd,istk(il+5+mn),mn1,fmti,ierr)
      return
      end

      subroutine loadstr(fd,il,n,ierr)
c     Copyright INRIA
c     Load a matrix of strings
      include '../stack.h'
      integer fd
      character*2 fmti,fmtd
      integer sadr
c
c      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      fmti='il'//char(0)
c     
c     read matrix header without type
      err=sadr(il+4)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call mgetnc (fd,istk(il+1),3,fmti,ierr)
      if(ierr.ne.0) return

      mn=istk(il+1)*istk(il+2)
      err=sadr(il+5+mn)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call mgetnc (fd,istk(il+4),mn+1,fmti,ierr)
      if(ierr.ne.0) return

c     read characters
      mn1=istk(il+4+mn)-1
      err=sadr(il+5+mn+mn1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call mgetnc(fd,istk(il+5+mn),mn1,fmti,ierr)
      n=5+mn+mn1
      return
      end

      subroutine savebool(fd,il,ierr)
c     Copyright INRIA
c     Save a matrix of boolean
      include '../stack.h'
c
      integer fd
      character*2 fmti,fmtd
c
c      iadr(l)=l+l-1
c      sadr(l)=(l/2)+1
c
      fmti='il'//char(0)
c
c     write matrix header without type
      call mputnc (fd,istk(il+1),2,fmti,ierr)
      if(ierr.ne.0) return
c     write matrix elements
      mn=istk(il+1)*istk(il+2)
      call mputnc(fd,istk(il+3),mn,fmti,ierr)
      return
      end

      subroutine loadbool(fd,il,n,ierr)
c     Copyright INRIA
c     Load a matrix of boolean
      include '../stack.h'
      integer fd
      character*2 fmti,fmtd
      integer sadr
c
c      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      fmti='il'//char(0)

c     read matrix header without type
      err=sadr(il+3)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call mgetnc (fd,istk(il+1),2,fmti,ierr)
      if(ierr.ne.0) return

c     read matrix elements
      mn=istk(il+1)*istk(il+2)
      err=sadr(il+3+mn)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call mgetnc(fd,istk(il+3),mn,fmti,ierr)
      n=3+mn
      return
      end


      subroutine savefun(fd,il,ierr)
c     Copyright INRIA
c     Save  a function
      include '../stack.h'
c
      integer fd
      character*2 fmti,fmtd
c
c      iadr(l)=l+l-1
c      sadr(l)=(l/2)+1
c
      fmti='il'//char(0)
c
c     write function header without type
      il1=il
      nout=istk(il1+1)
      il1=il1+1+nout*nsiz
      nin=istk(il1+1)
      il1=il1+1+nin*nsiz
      n=istk(il1+1)
      call mputnc (fd,istk(il+1),3+(nout+nin)*nsiz+n,fmti,ierr)
      if(ierr.ne.0) return
      return
      end

      subroutine loadfun(fd,il,n,ierr)
c     Copyright INRIA
c     Load a function
      include '../stack.h'
c
      integer fd
      character*2 fmti,fmtd
      integer sadr
c
c      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      fmti='il'//char(0)
c
c     read function  without type
      il1=il
      err=sadr(il1+2)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call mgetnc (fd,istk(il1+1),1,fmti,ierr)
      if(ierr.ne.0) return

      nout=istk(il1+1)
      il1=il1+2
      err=sadr(il1+nout*nsiz+1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call mgetnc (fd,istk(il1),nout*nsiz+1,fmti,ierr)
      if(ierr.ne.0) return

      nin=istk(il1+nout*nsiz)
      il1=il1+nout*nsiz+1
      err=sadr(il1+nin*nsiz+1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call mgetnc (fd,istk(il1),nin*nsiz+1,fmti,ierr)
      if(ierr.ne.0) return

      n=istk(il1+nin*nsiz)
      il1=il1+nin*nsiz+1
      err=sadr(il1+n)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call mgetnc (fd,istk(il1),n,fmti,ierr)
      if(ierr.ne.0) return
      n=4+(nout+nin)*nsiz+n
      return
      end

      subroutine savecfun(fd,il,ierr)
c     Copyright INRIA
c     Save a compiled function
      include '../stack.h'
c
      integer fd
      character*2 fmti,fmtd
c
c      iadr(l)=l+l-1
c      sadr(l)=(l/2)+1
c
      fmti='il'//char(0)
c
c     write function header without type
      il1=il
      nout=istk(il1+1)
      il1=il1+1+nout*nsiz
      nin=istk(il1+1)
      il1=il1+1+nin*nsiz
      n=istk(il1+1)
      call mputnc (fd,istk(il+1),3+(nout+nin)*nsiz+n,fmti,ierr)
      if(ierr.ne.0) return
      return
      end

      subroutine loadcfun(fd,il,n,ierr)
c     Copyright INRIA
c     Load a compiled function
      include '../stack.h'
c
      integer fd
      integer sadr
      character*2 fmti,fmtd
c
c      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      fmti='il'//char(0)
c
c     read function  without type
      il1=il
      err=sadr(il1+2)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call mgetnc (fd,istk(il1+1),1,fmti,ierr)
      if(ierr.ne.0) return

      nout=istk(il1+1)
      il1=il1+2
      err=sadr(il1+nout*nsiz+1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call mgetnc (fd,istk(il1),nout*nsiz+1,fmti,ierr)
      if(ierr.ne.0) return

      nin=istk(il1+nout*nsiz)
      il1=il1+nout*nsiz+1
      err=sadr(il1+nin*nsiz+1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call mgetnc (fd,istk(il1),nin*nsiz+1,fmti,ierr)
      if(ierr.ne.0) return

      n=istk(il1+nin*nsiz)
      il1=il1+nin*nsiz+1
      err=sadr(il1+n)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call mgetnc (fd,istk(il1),n,fmti,ierr)
      if(ierr.ne.0) return
      n=4+(nout+nin)*nsiz+n
      return
      end


      subroutine savesparse(fd,il,ierr)
c     Copyright INRIA
c     Save a sparse matrix of numbers
      include '../stack.h'
c
      integer fd
      character*3 fmti,fmtd
      integer sadr
c
c      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      fmti='il'//char(0)
      fmtd='dl'//char(0)
c
c     write matrix header type excluded
      call mputnc (fd,istk(il+1),4,fmti,ierr)
      if(ierr.ne.0) return
      m=istk(il+1)
      nel=istk(il+4)
c     write matrix elements
      call mputnc(fd,istk(il+5),m+nel,fmti,ierr)
      if(ierr.ne.0) return
      mn=nel*(istk(il+3)+1)
      call mputnc(fd,stk(sadr(il+5+m+nel)),mn,fmtd,ierr)
      return
      end

      subroutine loadsparse(fd,il,n,ierr)
c     Copyright INRIA
c     load a sparse matrix of numbers
      include '../stack.h'
      integer fd
      character*3 fmti,fmtd
      integer sadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      fmti='il'//char(0)
      fmtd='dl'//char(0)

c     read matrix header without type
      err=sadr(il+5)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call mgetnc (fd,istk(il+1),4,fmti,ierr)
      if(ierr.ne.0) return

      m=istk(il+1)
      nel=istk(il+4)
c     read matrix elements
      il1=il+5
      err=sadr(il1+m+nel)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call mgetnc(fd,istk(il1),m+nel,fmti,ierr)
      if(ierr.ne.0) return

      il1=il1+m+nel
      mn=nel*(istk(il+3)+1)
      err=sadr(il1)+mn-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      l=sadr(il+5+m+nel)
      call mgetnc(fd,stk(l),mn,fmtd,ierr)
      n=iadr(l+mn)-il
c      n=5+m+nel+2*mn
      return
      end

      subroutine savespb(fd,il,ierr)
c     Copyright INRIA
c     Save a sparse matrix of boolean
      include '../stack.h'
c
      integer fd
      character*3 fmti,fmtd
c
      fmti='il'//char(0)
      fmtd='dl'//char(0)
c
c     write matrix header type excluded
      call mputnc (fd,istk(il+1),4,fmti,ierr)
      if(ierr.ne.0) return
      m=istk(il+1)
      nel=istk(il+4)
c     write matrix elements
      call mputnc(fd,istk(il+5),m+nel,fmti,ierr)
      return
      end

      subroutine loadspb(fd,il,n,ierr)
c     Copyright INRIA
c     Load a sparse matrix of boolean
      include '../stack.h'
      integer fd
      character*3 fmti,fmtd
      integer sadr 

c
c      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      fmti='il'//char(0)
      fmtd='dl'//char(0)

c     read matrix header without type
      err=sadr(il+5)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call mgetnc (fd,istk(il+1),4,fmti,ierr)
      if(ierr.ne.0) return

      m=istk(il+1)
      nel=istk(il+4)
c     read matrix elements
      err=sadr(il+5+m+nel)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call mgetnc(fd,istk(il+5),m+nel,fmti,ierr)
      n=5+m+nel
      return
      end

      subroutine savelib(fd,il,ierr)
c     [14,n,codagedupath(n),nombre-de-nom,nclas+1 cases,suite des noms]
c     Copyright INRIA
c     Save a sparse matrix of numbers
      include '../stack.h'
c
      integer fd
      character*3 fmti,fmtd
      data nclas/29/
c
      fmti='il'//char(0)
      fmtd='dl'//char(0)
c
      np=istk(il+1)
      nn=istk(il+2+np)
      call mputnc (fd,istk(il+1),3+np+nclas+nn*nsiz,fmti,ierr)
      return
      end

      subroutine loadlib(fd,il,n,ierr)
c     [14,n,codagedupath(n),nombre-de-nom,nclas+1 cases,suite des noms]
c     Copyright INRIA
c     Save a sparse matrix of numbers
      include '../stack.h'
c
      integer fd
      character*3 fmti,fmtd
      integer sadr
      data nclas/29/
c
c      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      fmti='il'//char(0)
      fmtd='dl'//char(0)
c
      il1=il+1
      err=sadr(il1+1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call mgetnc (fd,istk(il1),1,fmti,ierr)
      if(ierr.ne.0) return

      np=istk(il1)
      il1=il1+1
      err=sadr(il1+np+1+nclas+1)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call mgetnc (fd,istk(il1),np+1+nclas+1,fmti,ierr)
      if(ierr.ne.0) return

      il1=il1+np+1+nclas+1
      nn=istk(il+2+np)
      err=sadr(il1+nn*nsiz)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call mgetnc (fd,istk(il1),nn*nsiz,fmti,ierr)
      n=il1+nn*nsiz-il
      return
      end

      subroutine savemsp(fd,il,ierr)
c     Copyright INRIA
c     Save a sparse matrix of numbers
      include '../stack.h'
c
      integer fd
      character*3 fmti,fmtd
      integer sadr
c
c      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      fmti='il'//char(0)
      fmtd='dl'//char(0)
c
c     write matrix header type excluded
      call mputnc (fd,istk(il+1),4,fmti,ierr)
      if(ierr.ne.0) return
      n=istk(il+2)
      nel=istk(il+4)
c     write matrix elements
      call mputnc(fd,istk(il+5),n+nel+1,fmti,ierr)
      if(ierr.ne.0) return
      mn=nel*(istk(il+3)+1)
      call mputnc(fd,stk(sadr(il+6+n+nel)),mn,fmtd,ierr)
      return
      end

      subroutine loadmsp(fd,il,n,ierr)
c     Copyright INRIA
c     load a sparse matrix of numbers
      include '../stack.h'
      integer fd
      character*3 fmti,fmtd
      integer sadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      fmti='il'//char(0)
      fmtd='dl'//char(0)

c     read matrix header without type
      err=sadr(il+5)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif

      call mgetnc (fd,istk(il+1),4,fmti,ierr)
      if(ierr.ne.0) return

      n=istk(il+2)
      nel=istk(il+4)
c     read matrix elements
      il1=il+5
      err=sadr(il1+n+nel)-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call mgetnc(fd,istk(il1),n+nel+1,fmti,ierr)
      if(ierr.ne.0) return

      il1=il1+n+nel+1
      mn=nel*(istk(il+3)+1)
      err=sadr(il1)+mn-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      l=sadr(il1)
      call mgetnc(fd,stk(l),mn,fmtd,ierr)
      n=iadr(l+mn)-il
c      n=5+n+nel+2*mn
      return
      end

      subroutine saveptr(fd,il,ierr)
c     Copyright INRIA
c     Save a pointer on sparse lu factorization
      include '../stack.h'
c
      integer fd
      character*3 fmti,fmtd
      integer sadr
c
c      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      fmti='il'//char(0)
      fmtd='dl'//char(0)
c
c     write  header type excluded
      call mputnc (fd,istk(il+1),3,fmti,ierr)
      if(ierr.ne.0) return
c     write pointer
      call mputnc(fd,stk(sadr(il+4)),1,fmtd,ierr)
      return
      end

      subroutine loadptr(fd,il,n,ierr)
c     Copyright INRIA
c     Save a pointer on sparse lu factorization
      include '../stack.h'
      integer fd
      character*3 fmti,fmtd
      integer sadr
c
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      fmti='il'//char(0)
      fmtd='dl'//char(0)

c     read matrix header without type
      err=sadr(il+4)+1-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call mgetnc (fd,istk(il+1),3,fmti,ierr)
      if(ierr.ne.0) return
c     read pointer
      l=sadr(il+4)
      call mgetnc(fd,stk(l),1,fmtd,ierr)
      n=iadr(l+1)-il
c      n=4+2*1
      return
      end

      subroutine saveint(fd,il,ierr)
c     Copyright INRIA
c     Save a pointer on sparse lu factorization
      include '../stack.h'
c
      integer fd
      character*3 fmti,fmtd
      integer sadr
c
c      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      fmti='il'//char(0)
      fmtd='dl'//char(0)
c
c     write  header type excluded
      call mputnc (fd,istk(il+1),3,fmti,ierr)
      if(ierr.ne.0) return
      mn=istk(il+1)*istk(il+2)
      it=istk(il+3)

      if(it.eq.4) then
         call mputnc(fd,istk(il+4),mn,fmti,ierr)
      elseif(it.eq.2) then
         call mputnc(fd,istk(il+4),mn,'sl'//char(0),ierr)
      elseif(it.eq.1) then
         call mputnc(fd,istk(il+4),mn,'c'//char(0),ierr)
      elseif(it.eq.14) then
         call mputnc(fd,istk(il+4),mn,'uil'//char(0),ierr)
      elseif(it.eq.12) then
         call mputnc(fd,istk(il+4),mn,'usl'//char(0),ierr)
      elseif(it.eq.11) then
         call mputnc(fd,istk(il+4),mn,'uc'//char(0),ierr)
      endif
      return
      end

      subroutine loadint(fd,il,n,ierr)
c     Copyright INRIA
c     Save a pointer on sparse lu factorization
      include '../stack.h'
      integer fd
      character*3 fmti,fmtd
      integer sadr
c
c      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      fmti='il'//char(0)
      fmtd='dl'//char(0)

c     read matrix header without type
      err=sadr(il+4)+1-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call mgetnc (fd,istk(il+1),3,fmti,ierr)
      if(ierr.ne.0) return
      mn=istk(il+1)*istk(il+2)
      it=istk(il+3)
      err=sadr(il+4+memused(it,mn))-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      if(it.eq.4) then
         call mgetnc(fd,istk(il+4),mn,fmti,ierr)
         n=4+mn
      elseif(it.eq.2) then
         call mgetnc(fd,istk(il+4),mn,'sl'//char(0),ierr)
         n=4+(mn+1)/2
      elseif(it.eq.1) then
         call mgetnc(fd,istk(il+4),mn,'c'//char(0),ierr)
         n=4+(mn+3)/4
      elseif(it.eq.14) then
         call mgetnc(fd,istk(il+4),mn,'uil'//char(0),ierr)
         n=4+mn
      elseif(it.eq.12) then
         call mgetnc(fd,istk(il+4),mn,'usl'//char(0),ierr)
         n=4+(mn+1)/2
      elseif(it.eq.11) then
         call mgetnc(fd,istk(il+4),mn,'uc'//char(0),ierr)
         n=4+(mn+3)/4
      endif
      return
      end


      subroutine v2cunit(k,mode,fd,opened,ierr)
c     given variable #k (scalar or string) and mode 
c     v2unit return a  logical unit attached to corresponding file

      INCLUDE '../stack.h'
c
      logical opened
      integer fd
      character*2 mode
      character*3 status
      double precision w
      integer iadr,sadr
c     
      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
c
      ierr=0
      il=iadr(lstk(k))
      if(istk(il).lt.0) il=iadr(istk(il+1))
      if (istk(il).eq.1) then
         fd = int(stk(sadr(il+4)))
         if (istk(il+1)*istk(il+2).ne.1.or.istk(il+3).ne.0.or.
     $        fd .lt. 0) then
            err=1
            ierr=1
            call error(36)
            return
         endif
         call getfileinfo(fd,ifa,iswap,ltype,mod,buf,lb,info)
         if(info.eq.0.and.ltype.eq.1) then
c     ierr=-1 line used for compatibility instead of error
            ierr=-1
            opened=.true.
c            call error(244)
            return
         endif
         opened=.true.
      elseif(istk(il).eq.10) then
         if(istk(il+1)*istk(il+2).ne.1) then
            err=1
            ierr=1
            call error(36)
            return
         endif
         mn=istk(il+5)-1
         call cvstr(mn,istk(il+5+istk(il+1)*istk(il+2)),buf,1)
         call cluni0(buf(1:mn), buf(mn+2:),mn1)
         lunit = 0
         buf(mn+mn1+2:mn+mn1+2)=char(0)
         l=lnblnk(mode)
         call mopen(fd,buf(mn+2:),mode(1:l)//char(0),1,w,ierr)

         if(ierr.gt.0) then
            if(ierr.eq.2) then
               if(mode(1:1).eq.'r') then
                  err=241
               else
                  err=240
               endif
            elseif(ierr.eq.1) then
               err=66
            endif
            buf(mn+1:)=' '
            call error(err)
            return
         endif
         opened=.false.
      else
         err=1
         ierr=1
         call error(36)
         return
      endif
      end
