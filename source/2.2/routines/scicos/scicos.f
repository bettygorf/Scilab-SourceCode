      subroutine scicos(x0,t0,tf,tevts,evtspt,nevts,pointi,pointf,
     &                  inpptr,outptr,stptr,clkptr,cmat,ordptr,nclkp1,
     &                  execlk,ordclk,cord,ncord1,iord,niord1,oord,
     &                  noord1,zord,nzord1,critev,rpar,
     &                  rpptr,ipar,ipptr,funptr,ncblk1,nxblk1,ndblk1,
     &                  ndcbl1,simpar,w,iw,flag,ierr) 
C
      double precision x0(*)
      double precision t0
      double precision tf
      integer nevts,nclkp1
      double precision tevts(nevts)
      integer evtspt(nevts)
      integer pointi
      integer pointf
      integer inpptr(*),outptr(*),stptr(*),clkptr(*)
      integer cmat(*)
      integer ordptr(nclkp1,2),execlk(*),ordclk(*)
      double precision rpar(*)
      integer rpptr(*)
      integer ipar(*)
      integer ipptr(*)
      integer funptr(*)
      integer ncblk1,nxblk1,ndblk1,ndcbl1
      integer cord(ncord1)
      integer iord(niord1)
      integer oord(noord1)
      integer zord(nzord1)
      integer critev(*)
      double precision simpar(3)
      double precision w(*)
      integer iw(*)
      integer flag,ierr
C
C 
C.. Local Scalars .. 
      integer liw,lncst,lw,lx0,ndcblk,ndout,nst
C 
C... Variables in Common Block ... 
      integer lrpar,lrptr,lipar,liptr,louttb,lcmat,lrhot,linppt,loutpt,
     &        lstpt,lfunpt,lihot,ljroot,lclkpt,lcord,loord,lzord
      common /cosptr/ lrpar,lrptr,lipar,liptr,louttb,lcmat,lrhot,linppt,
     &                loutpt,lstpt,lfunpt,lclkpt,lihot,ljroot,lww,lcord,
     &                loord,lzord
C... Variables in Common Block ... 
      integer nblk,nxblk,ncblk,ndblk,nout,ncout,ninp,ncinp,ncst,ng,nrwp,
     &     niwp,ncord,niord,noord,nzord
      common /cossiz/ nblk,nxblk,ncblk,ndblk,nout,ncout,ninp,ncinp,
     &     ncst,ng,nrwp,niwp,ncord,niord,noord,nzord
C 
C... Variables in Common Block ... 
      double precision atol,rtol,ttol
      common /costol/ atol,rtol,ttol
C
      atol = simpar(1)
      rtol = simpar(2)
      ttol = simpar(3)
C
      ncblk = ncblk1
      nxblk = nxblk1
      ndblk = ndblk1
      ndcblk = ndcbl1
      ncord = ncord1
      niord = niord1
      noord = noord1
      nzord = nzord1
C
      ierr = 0
C
      nblk = ncblk + ndblk + ndcblk
C
C     computes number of continuous outputs
      ncout = outptr(ncblk+1) - 1
C     computes number of dicrete outputs
      ndout = outptr(ncblk+ndblk+1) - outptr(ncblk+1)
C     total number of outputs
      nout = ncout + ndout
C     computes of zero crossing surfaces
      ng = inpptr(nblk+1) - inpptr(ncblk+ndblk+1)
C
C     computes number of continuous inputs
      ncinp = inpptr(ncblk+1) - 1
      ninp = inpptr(nblk+1) - 1
C
C     number of  states
      nst = stptr(2*nblk+1) - 1
C     number of continuous states
      ncst = stptr(nblk+1) - 1
C     hotstart work size
      nrwp = 22 + ncst*max(16,ncst+9) + 3*ng
      niwp = 20 + ncst
C     number of rows in execlk is ordptr(nclkp1,1)-1
C     number of rows in ordclk is ordptr(nclkp1,2)-1
C     maximum block state and input sizes      
      maxst = 0
      maxinp = 0
      do 10 i = 1,ncblk+ndblk
        maxst = max(maxst,max(stptr(i+1)-stptr(i),stptr(nblk+i+1)
     &        -stptr(nblk+i)))
        maxinp = max(maxinp,inpptr(i+1)-inpptr(i))
 10   continue
C     split working areas into pieces
      lw = 1
C     lx0 must be equal to one
      lx0 = lw
      lw = lx0 + nst
      lrpar = lw
      lw = lrpar + rpptr(nblk+1) - 1
      louttb = lw
      lw = louttb + nout
      lrhot = lw
      lw = lrhot + nrwp
      lww = lw
      lw = lww + maxinp + maxst
C
      liw = 1
C     lncst must be equal to 1
      lncst = liw
      iw(lncst) = ncst
      liw = lncst + 1
      linppt = liw
      liw = linppt + nblk + 1
      loutpt = liw
      liw = loutpt + nblk + 1
      lstpt = liw
      liw = lstpt + 2*nblk + 1
      lclkpt = liw
      liw = lclkpt + nblk + 1
      lcmat = liw
      liw = lcmat + ninp
      lfunpt = liw
      liw = lfunpt + nblk
      lrptr = liw
      liw = lrptr + nblk + 1
      lipar = liw
      liw = lipar + ipptr(nblk+1) - 1
      lcord = liw
      liw = lcord + ncord
      loord = liw
      liw = loord + noord
      lzord = liw
      liw = lzord + nzord
      liptr = liw
      liw = liptr + nblk + 1
      lihot = liw
      liw = lihot + niwp
      ljroot = liw
      liw = ljroot + ng*2
C
      call dcopy(nst,x0,1,w(lx0),1)
      call icopy(nblk+1,inpptr,1,iw(linppt),1)
      call icopy(nblk+1,outptr,1,iw(loutpt),1)
      call icopy(2*nblk+1,stptr,1,iw(lstpt),1)
      call icopy(nblk+1,clkptr,1,iw(lclkpt),1)
      call icopy(ninp,cmat,1,iw(lcmat),1)
      call dcopy(rpptr(nblk+1)-1,rpar,1,w(lrpar),1)
      call icopy(nblk+1,rpptr,1,iw(lrptr),1)
      call icopy(ipptr(nblk+1)-1,ipar,1,iw(lipar),1)
      call icopy(nblk+1,ipptr,1,iw(liptr),1)
      call icopy(nblk,funptr,1,iw(lfunpt),1)
      call icopy(ncord,cord,1,iw(lcord),1)
      call icopy(noord,oord,1,iw(loord),1)
      call icopy(nzord,zord,1,iw(lzord),1)
      if(flag.eq.1) then
c     initialisation des blocks
         call cosini(w(lx0),t0,iw(linppt),iw(loutpt),iw(lstpt),
     &        iw(lclkpt),w(lrpar),iw(lrptr),iw(lipar),iw(liptr),
     &        iw(lfunpt),ierr)
      elseif(flag.eq.2) then
c     integration
         call cossim(w(lx0),iw(lncst),t0,tf,tevts,evtspt,nevts,pointi,
     &        pointf,iw(linppt),iw(loutpt),iw(lstpt),iw(lclkpt),
     &        iw(lcmat),ordptr,nclkp1,execlk,ordptr(nclkp1,1)-1,
     &        ordclk,ordptr(nclkp1,2)-1,iw(lcord),iord,oord,zord,
     &        critev,w(lrpar),
     &        iw(lrptr),iw(lipar),iw(liptr),iw(lfunpt),w(lrhot),
     &        iw(lihot),w(louttb),iw(ljroot),w(lww),ierr)
      elseif(flag.eq.3) then
c     fermeture des blocks
         call cosend(w(lx0),tf,iw(linppt),iw(loutpt),iw(lstpt),
     &        iw(lclkpt),w(lrpar),iw(lrptr),iw(lipar),iw(liptr),
     &        iw(lfunpt),ierr)
      endif
      call dcopy(nst,w(lx0),1,x0,1)
      end

