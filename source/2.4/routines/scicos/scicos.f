      subroutine scicos(x,xptr,z,zptr,iz,izptr,t0,tf,tevts,evtspt,
c     Copyright INRIA
     $     nevts,pointi,outtb,nout1,funptr,funtyp,inpptr,outptr,inplnk,
     $     outlnk,lnkptr,nlnkptr,rpar,rpptr,ipar,ipptr,clkptr,ordptr,
     $     nordptr1,ordclk,cord,ncord1,iord,niord,oord,noord1,
     $     zord,nzord1,
     $     critev,nblk1,ztyp,ng1,subscr,nsubs,simpar,w,iw,iwa,
     $     flag,ierr)
c iz,izptr are used to pass block labels
      double precision x(*),z(*),t0,tf,tevts(nevts),outtb(*),rpar(*)
      double precision simpar(4),w(*)

      integer xptr(*),zptr(*),iz(*),izptr(*),evtspt(nevts),nevts
      integer pointi,funptr(*),funtyp(*),inpptr(*),outptr(*)
      integer inplnk(*),outlnk(*),lnkptr(*),nlnkptr,rpptr(*),ipar(*)
      integer ipptr(*),clkptr(*),ordptr(nordptr1),ordclk(*)
      integer cord(ncord1,2),ncord1,iord(niord,2),niord,oord(noord1,2)
      integer noord1,zord(nzord1,2),nzord1,critev(*)
      integer subscr(*),nsubs,iw(*),iwa(*),flag,ierr,ztyp(nblk1)
c
      integer louttb
c
      integer         nblk,nordptr,nout,ng,nrwp,niwp,ncord,
     &     noord,nzord
      common /cossiz/ nblk,nordptr,nout,ng,nrwp,niwp,ncord,
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
      nordptr=nordptr1
      nblk = nblk1
      ncord = ncord1
      noord = noord1
      nzord = nzord1
      nout = nout1
c
      ierr = 0
c
c      nblk = ncblk + ndblk + ndcblk
c

c     computes number of zero crossing surfaces
      ng=ng1
c
c     number of  discrete real states
      nz = zptr(nblk+1) - 1
c     number of continuous states
      nx = xptr(nblk+1) - 1
c     hotstart work size
      nrwp = 22 + nx*max(16,nx+9) + 3*ng 
      niwp = 20 + nx 
c     number of rows in ordclk is ordptr(nclkp1)-1
c     maximum block state and input sizes      

c     split working areas into pieces
      lw = 1
c     lx must be equal to one
      louttb = lw
      lw = louttb + nout
      lrhot = lw
      lw = lrhot + nrwp
c     reserved for futher use
      lww =lw
      lw = lww +1 
c
      liw = 1
      lihot = liw
      liw = lihot + niwp
      ljroot = liw
      liw = ljroot + ng*2
c
      do 10 i=1,nblk
         funtyp(i)=mod(funtyp(i),1000)
 10   continue
c

      call makescicosimport(x,xptr,z,zptr,iz,izptr,
     $     inpptr,inplnk,outptr,outlnk,lnkptr,nlnkptr,
     $     rpar,rpptr,ipar,ipptr,
     $     nblk,outtb,nout,subscr,nsubs,tevts,evtspt,nevts,pointi,
     $     oord,zord,funptr,funtyp,ztyp,cord,ordclk,clkptr,ordptr,
     $     critev)

      if(flag.eq.1) then
c     initialisation des blocks

         call cosini(x,xptr,z,zptr,iz,
     $        izptr,t0,inpptr,inplnk,outptr,
     $        outlnk,lnkptr,cord,rpar,rpptr,
     $        ipar,ipptr,funptr,funtyp,outtb,
     $        w(louttb),w(lww),ierr) 

      elseif(flag.eq.2) then
c     integration
         call cossim(nx,x,xptr,z,zptr,
     $        iz,izptr,t0,tf,tevts,evtspt,nevts,pointi,
     $        inpptr,inplnk,outptr,outlnk,
     $        lnkptr,clkptr,ordptr,nordptr,
     $        ordclk,ordptr(nordptr)-1,ztyp,
     $        cord,iord,niord,oord,zord,critev,
     $        rpar,rpptr,ipar,ipptr,funptr,
     $        funtyp,w(lrhot),iw(lihot),outtb,iw(ljroot),
     $        w(lww),iwa,ierr)
      elseif(flag.eq.3) then
c     fermeture des blocks
         call cosend(x,xptr,z,zptr,iz,
     $        izptr,t0,inpptr,inplnk,outptr,
     $        outlnk,lnkptr,cord,rpar,rpptr,
     $        ipar,ipptr,funptr,funtyp,outtb,
     $        w(lww),ierr) 
      endif
      
      call clearscicosimport()
      end

