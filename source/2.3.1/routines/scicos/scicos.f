      subroutine scicos(x0,xptr,z0,zptr,iz0,izptr,t0,tf,tevts,evtspt,
     $     nevts,pointi,outtb,nout1,funptr,funtyp,inpptr,outptr,inplnk,
     $     outlnk,lnkptr,nlnkptr,rpar,rpptr,ipar,ipptr,clkptr,ordptr,
     $     nordptr,execlk,ordclk,cord,ncord1,iord,niord,oord,noord1,
     $     zord,nzord1,
     $     critev,ncblk1,nxblk1,ndblk1,ndcblk1,subscr,nsubs,simpar,w,iw,
     $     flag,ierr)
c iz,izptr are used to pass block labels
      double precision x0(*),z0(*),t0,tf,tevts(nevts),outtb(*),rpar(*)
      double precision simpar(4),w(*)

      integer xptr(*),zptr(*),iz0(*),izptr(*),evtspt(nevts),nevts
      integer pointi,funptr(*),funtyp(*),inpptr(*),outptr(*)
      integer inplnk(*),outlnk(*),lnkptr(*),nlnkptr,rpptr(*),ipar(*)
      integer ipptr(*),clkptr(*),ordptr(nordptr,2),execlk(*),ordclk(*)
      integer cord(ncord1),ncord1,iord(niord),niord,oord(noord1),noord1
      integer zord(nzord1),nzord1,critev(*),ncblk1,nxblk1,ndblk1,ndcblk1
      integer subscr(*),nsubs,iw(*),flag,ierr
c
      integer         lfunpt,lxptr,lz,lzptr,liz0,lizptr,lrpar,lrpptr,
     &     lipar,lipptr,linpptr,linplnk,loutptr,loutlnk,llnkptr,
     &     louttb,loord,lzord,lfuntyp
      common /cosptr/ lfunpt,lxptr,lz,lzptr,liz0,lizptr,lrpar,lrpptr,
     &     lipar,lipptr,linpptr,linplnk,loutptr,loutlnk,llnkptr,
     &     louttb,loord,lzord,lfuntyp
c
      integer         nblk,nxblk,ncblk,ndblk,nout,ng,nrwp,niwp,ncord,
     &     noord,nzord
      common /cossiz/ nblk,nxblk,ncblk,ndblk,nout,ng,nrwp,niwp,ncord,
     &     noord,nzord
c
      double precision atol,rtol,ttol,deltat
      common /costol/ atol,rtol,ttol,deltat
c
      integer kfun
      common /curblk/ kfun
c
      atol = simpar(1)
      rtol = simpar(2)
      ttol = simpar(3)
      deltat=simpar(4)
c
      ncblk = ncblk1
      nxblk = nxblk1
      ndblk = ndblk1
      ndcblk = ndcblk1
      ncord = ncord1
      noord = noord1
      nzord = nzord1
      nout = nout1
c
      ierr = 0
c
      nblk = ncblk + ndblk + ndcblk
c

c     computes of zero crossing surfaces
      ng=0
c     loop on zero crossing blocks
      if(ndcblk.gt.0) then
         do 02 kfun=ncblk + ndblk+1,nblk
c     .  loop on block input ports
            do 01 kport=inpptr(kfun),inpptr(kfun+1)-1
c     .     get corresponding link pointer 
               klink=inplnk(kport)
               ng=ng+lnkptr(klink+1)-lnkptr(klink)
 01         continue
 02      continue
      endif
c
c     number of  discrete real states
      nz = zptr(nblk+1) - 1
c     number of continuous states
      nx = xptr(nblk+1) - 1
c     hotstart work size
      nrwp = 22 + nx*max(16,nx+9) + 3*ng 
      niwp = 20 + nx 
c     number of rows in execlk is ordptr(nclkp1,1)-1
c     number of rows in ordclk is ordptr(nclkp1,2)-1
c     maximum block state and input sizes      

c     split working areas into pieces
      lw = 1
c     lx0 must be equal to one
      lx0 = lw
      lw = lx0 + nx
      lz = lw
      lw = lz + nz
      lrpar = lw
      lw = lrpar + rpptr(nblk+1) - 1
      louttb = lw
      lw = louttb + nout
      lrhot = lw
      lw = lrhot + nrwp
c     reserved for futher use
      lww =lw
      lw = lww +1 
c
      liw = 1
c     lnx must be equal to 1
      lnx = liw
      iw(lnx) = nx
      liw = lnx + 1
      liz0 = liw 
      liw = liz0 + izptr(nblk+1)-1
      linpptr = liw
      liw = linpptr + nblk + 1
      linplnk = liw 
      liw =linplnk + inpptr(nblk+1)-1
      loutptr = liw
      liw = loutptr + nblk + 1
      loutlnk = liw 
      liw =loutlnk + outptr(nblk+1)-1
      llnkptr = liw 
      liw = llnkptr + nlnkptr
c
      lxptr = liw
      liw = lxptr + nblk + 1
      lzptr = liw
      liw = lzptr + nblk + 1
      lizptr = liw
      liw = lizptr + nblk + 1
      lclkpt = liw
      liw = lclkpt + nblk + 1
      lfunpt = liw
      liw = lfunpt + nblk
      lfuntyp = liw
      liw = lfuntyp + nblk
      lrpptr = liw
      liw = lrpptr + nblk + 1
      lipar = liw
      liw = lipar + ipptr(nblk+1) - 1
      lipptr = liw
      liw = lipptr + nblk + 1
      loord = liw
      liw = loord + noord
      lzord = liw
      liw = lzord + nzord
      lihot = liw
      liw = lihot + niwp
      ljroot = liw
      liw = ljroot + ng*2
c
c      call makescicosimport(x0,xptr,z0,zptr,iz,izptr,
c     $     inpptr,inplnk,outptr,outlnk,lnkptr,nlnkptr,
c     $     rpar,rpptr,ipar,ipptr,
c     $     nblk,outtb,nout,subscr,nsubs,tevts,evtspt,nevts,pointi,
c     $     oord,zord,funptr,funtyp)
c
      call dcopy(nx,x0,1,w(lx0),1)
      call dcopy(nz,z0,1,w(lz),1)
      call dcopy(rpptr(nblk+1)-1,rpar,1,w(lrpar),1)
      call dcopy(nout,outtb,1,w(louttb),1)
c
      iw(lnx) = nx
      call icopy(izptr(nblk+1)-1,iz0,1,iw(liz0),1)
      call icopy(nblk+1,inpptr,1,iw(linpptr),1)
      call icopy(inpptr(nblk+1)-1,inplnk,1,iw(linplnk),1)
      call icopy(nblk+1,outptr,1,iw(loutptr),1)
      call icopy(outptr(nblk+1)-1,outlnk,1,iw(loutlnk),1)
      call icopy(nlnkptr,lnkptr,1,iw(llnkptr),1)
      call icopy(nblk+1,xptr,1,iw(lxptr),1)
      call icopy(nblk+1,zptr,1,iw(lzptr),1)
      call icopy(nblk+1,izptr,1,iw(lizptr),1)
      call icopy(nblk+1,clkptr,1,iw(lclkpt),1)
      call icopy(nblk,funptr,1,iw(lfunpt),1)
      call icopy(nblk,funtyp,1,iw(lfuntyp),1)
      call icopy(nblk+1,rpptr,1,iw(lrpptr),1)
      call icopy(ipptr(nblk+1)-1,ipar,1,iw(lipar),1)
      call icopy(nblk+1,ipptr,1,iw(lipptr),1)
      call icopy(noord,oord,1,iw(loord),1)
      call icopy(nzord,zord,1,iw(lzord),1)

      call makescicosimport(w(lx0),iw(lxptr),w(lz),iw(lzptr),
     $     iw(liz0),iw(lizptr),iw(linpptr),iw(linplnk),iw(loutptr),
     $     iw(loutlnk),iw(llnkptr),nlnkptr,
     $     w(lrpar),iw(lrpptr),iw(lipar),iw(lipptr),
     $     nblk,w(louttb),nout,subscr,nsubs,tevts,evtspt,nevts,
     $     pointi,oord,zord,iw(lfunpt),iw(lfuntyp))

      if(flag.eq.1) then
c     initialisation des blocks

         call cosini(w(lx0),iw(lxptr),w(lz),iw(lzptr),iw(liz0),
     $        iw(lizptr),t0,iw(linpptr),iw(linplnk),iw(loutptr),
     $        iw(loutlnk),iw(llnkptr),cord,w(lrpar),iw(lrpptr),
     $        iw(lipar),iw(lipptr),iw(lfunpt),iw(lfuntyp),outtb,
     $        w(louttb),w(lww),ierr) 

      elseif(flag.eq.2) then
c     integration
         call cossim(iw(lnx),w(lx0),iw(lxptr),w(lz),iw(lzptr),
     $        iw(liz0),iw(lizptr),t0,tf,tevts,evtspt,nevts,pointi,
     $        iw(linpptr),iw(linplnk),iw(loutptr),iw(loutlnk),
     $        iw(llnkptr),clkptr,ordptr,nordptr,execlk,
     $        ordptr(nordptr,1)-1,ordclk,ordptr(nordptr,2)-1,
     $        cord,iord,niord,iw(loord),iw(lzord),critev,
     $        w(lrpar),iw(lrpptr),iw(lipar),iw(lipptr),iw(lfunpt),
     $        iw(lfuntyp),w(lrhot),iw(lihot),w(louttb),iw(ljroot),
     $        w(lww),ierr)
         call dcopy(nout,w(louttb),1,outtb,1)
      elseif(flag.eq.3) then
c     fermeture des blocks
         call cosend(w(lx0),iw(lxptr),w(lz),iw(lzptr),iw(liz0),
     $        iw(lizptr),t0,iw(linpptr),iw(linplnk),iw(loutptr),
     $        iw(loutlnk),iw(llnkptr),cord,w(lrpar),iw(lrpptr),
     $        iw(lipar),iw(lipptr),iw(lfunpt),iw(lfuntyp),outtb,
     $        w(lww),ierr) 
      endif
      call dcopy(nx,w(lx0),1,x0,1)
      call dcopy(nz,w(lz),1,z0,1)
c      call icopy(niz,iw(liz0),1,iz,1)
      
      call clearscicosimport()
      end

