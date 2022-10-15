      subroutine doit(neq,x,xptr,z,zptr,iz,izptr,told,tf
c     Copyright INRIA
     $     ,tevts,evtspt,nevts,pointi,inpptr,inplnk,outptr
     $     ,outlnk,lnkptr,clkptr,ordptr,nptr
     $     ,ordclk,nordcl,cord,iord,niord,oord,zord,critev,
     $     rpar,rpptr,ipar
     $     ,ipptr,funptr,funtyp,outtb,w,hot,urg,ierr) 
C     
C     
C..   Parameters .. 
c     maximum number of clock output for one block
      integer nts
      parameter (nts=100)
C     
      integer neq(*)
C     neq must contain after #states all integer data for simblk and grblk
      double precision x(*),z(*),told,tf,tevts(*),rpar(*),outtb(*)
      double precision w(*)
C     X must contain after state values all real data for simblk and grblk
      integer xptr(*),zptr(*),iz(*),izptr(*),evtspt(nevts),nevts,pointi
      integer inpptr(*),inplnk(*),outptr(*),outlnk(*),lnkptr(*)
      integer clkptr(*),ordptr(nptr),nptr
      integer ordclk(nordcl,2),nordcl,cord(*),iord(*),oord(*),zord(*)
      integer critev(*),rpptr(*),ipar(*),ipptr(*),funptr(*),funtyp(*)
      integer ierr
c     
      logical hot,urg
      integer i,ierr1,flag,keve,nord,nclock
      double precision tvec(nts)
c     
      integer         nblk,nordptr,nout,ng,nrwp,niwp,ncord,
     &     noord,nzord
      common /cossiz/ nblk,nordptr,nout,ng,nrwp,niwp,ncord,
     &     noord,nzord
C     
      integer halt
      common /coshlt/ halt
c     
      integer kfun
      common /curblk/ kfun
c     
      double precision atol,rtol,ttol,deltat
      common /costol/ atol,rtol,ttol,deltat
c     
c     
      urg=.false.
      keve = pointi
      pointi=evtspt(keve)
      evtspt(keve)=-1
c     
      nord=ordptr(keve+1)-ordptr(keve)
      if(nord.eq.0) return
c
      do 80 ii=ordptr(keve),ordptr(keve+1)-1
         kfun=ordclk(ii,1)
         if(outptr(kfun+1)-outptr(kfun).gt.0) then
            nclock=ordclk(ii,2)
            flag=1
            call callf(kfun,nclock,funptr,funtyp,told,w,x,xptr,z,
     $           zptr,iz,izptr,rpar,rpptr,ipar,ipptr,tvec,
     $           ntvec,inpptr,inplnk,outptr,outlnk,lnkptr,
     $           outtb,flag) 
            if(flag.lt.0) then
               ierr=5-flag
               return
            endif
         endif
 80   continue
c     
      do 60 ii=ordptr(keve),ordptr(keve+1)-1
         kfun=ordclk(ii,1)
c     .     Initialize tvec
         ntvec=clkptr(kfun+1)-clkptr(kfun)
         if(ntvec.gt.0) then
            call dset(ntvec,told-1.0d0,tvec,1)
c     
            flag=3
            call callf(kfun,ordclk(ii,2),funptr,funtyp,told,w,x,
     $           xptr,z,zptr,iz,izptr,rpar,rpptr,ipar,ipptr,tvec,
     $           ntvec,inpptr,inplnk,outptr,outlnk,lnkptr,
     $           outtb,flag) 
            if(flag.lt.0) then
               ierr=5-flag
               return
            endif
c     
            if (ntvec.ge.1) then
               if(funtyp(kfun).eq.-1) then
                  urg=.true.
                  call putevs(tevts,evtspt,nevts,pointi,
     &                 told,ntvec+clkptr(kfun)-1,ierr1)
                  if (ierr1 .ne. 0) then
C     !                 event conflict
                     ierr = 3
                     return
                  endif
               endif
            endif
         endif
 60   continue
      end








      subroutine cdoit(neq,x,xptr,z,zptr,iz,izptr,told,tf
     $     ,tevts,evtspt,nevts,pointi,inpptr,inplnk,outptr
     $     ,outlnk,lnkptr,clkptr,ordptr,nptr
     $     ,ordclk,nordcl,cord,iord,niord,oord,zord,critev,
     $     rpar,rpptr,ipar
     $     ,ipptr,funptr,funtyp,outtb,w,hot,ierr) 
C     

C     
C..   Parameters .. 
c     maximum number of clock output for one block
      integer nts
      parameter (nts=100)
C     
      integer neq(*)
C     neq must contain after #states all integer data for simblk and grblk
      double precision x(*),z(*),told,tf,tevts(*),rpar(*),outtb(*)
      double precision w(*)
C     X must contain after state values all real data for simblk and grblk
      integer xptr(*),zptr(*),iz(*),izptr(*),evtspt(nevts),nevts,pointi
      integer inpptr(*),inplnk(*),outptr(*),outlnk(*),lnkptr(*)
      integer clkptr(*),ordptr(nptr),nptr
      integer ordclk(nordcl,2),nordcl,cord(*),iord(*),oord(*),zord(*)
      integer critev(*),rpptr(*),ipar(*),ipptr(*),funptr(*),funtyp(*)
      integer ierr
c     
      logical hot,urg
      integer i,ierr1,flag,nclock
      double precision t
      double precision tvec(nts)
c     
      integer         nblk,nordptr,nout,ng,nrwp,niwp,ncord,
     &     noord,nzord
      common /cossiz/ nblk,nordptr,nout,ng,nrwp,niwp,ncord,
     &     noord,nzord
C     
      integer halt
      common /coshlt/ halt
c     
      integer kfun
      common /curblk/ kfun
c     
      double precision atol,rtol,ttol,deltat
      common /costol/ atol,rtol,ttol,deltat
c     
      urg=.false.
      do 19 jj=1,ncord
         kfun=cord(jj)
         nclock = cord(jj+ncord)
         if(outptr(kfun+1)-outptr(kfun).gt.0) then
            flag=1
            call callf(kfun,nclock,funptr,funtyp,told,
     $           x,x,xptr,z,zptr,iz,izptr,rpar,
     $           rpptr,ipar,ipptr,tvec,ntvec,inpptr,
     $           inplnk,outptr,outlnk,lnkptr,outtb,flag) 
            if (flag .lt. 0) then
               ierr = 5 - flag
               return
            endif
         endif
c     
         ntvec=clkptr(kfun+1)-clkptr(kfun)
         if(ntvec.gt.0) then
            call dset(ntvec,told-1.0d0,tvec,1)
c     
            flag=3
            call callf(kfun,nclock,funptr,funtyp,told,w,x,
     $           xptr,z,zptr,iz,izptr,rpar,rpptr,ipar,ipptr,tvec,
     $           ntvec,inpptr,inplnk,outptr,outlnk,lnkptr,
     $           outtb,flag) 
            if(flag.lt.0) then
               ierr=5-flag
               return
            endif
c     
            if (ntvec.ge.1) then
               if(funtyp(kfun).eq.-1) then
                  urg=.true.
                  call putevs(tevts,evtspt,nevts,pointi,
     &                 told,ntvec+clkptr(kfun)-1,ierr1)
                  if (ierr1 .ne. 0) then
C     !                 event conflict
                     ierr = 3
                     return
                  endif
               endif
            endif
         endif
 19   continue
      if (.not.urg)  return
 20   call doit(neq,x,xptr,z,zptr,iz,izptr,told,tf
     $     ,tevts,evtspt,nevts,pointi,inpptr,inplnk,outptr
     $     ,outlnk,lnkptr,clkptr,ordptr,nptr
     $     ,ordclk,nordcl,cord,iord,niord,oord,zord,critev,
     $     rpar,rpptr,ipar
     $     ,ipptr,funptr,funtyp,outtb,w,hot,urg,ierr) 
      if (urg) goto 20
      return
      end





      subroutine ddoit(neq,x,xptr,z,zptr,iz,izptr,told,tf
     $     ,tevts,evtspt,nevts,pointi,inpptr,inplnk,outptr
     $     ,outlnk,lnkptr,clkptr,ordptr,nptr
     $     ,ordclk,nordcl,cord,iord,niord,oord,zord,critev,
     $     rpar,rpptr,ipar
     $     ,ipptr,funptr,funtyp,outtb,w,iwa,hot,ierr) 
C     
C     
C..   Parameters .. 
c     maximum number of clock output for one block
      integer nts
      parameter (nts=100)
C     
      integer neq(*)
C     neq must contain after #states all integer data for simblk and grblk
      double precision x(*),z(*),told,tf,tevts(*),rpar(*),outtb(*)
      double precision w(*)
      integer iwa(*)
C     X must contain after state values all real data for simblk and grblk
      integer xptr(*),zptr(*),iz(*),izptr(*),evtspt(nevts),nevts,pointi
      integer inpptr(*),inplnk(*),outptr(*),outlnk(*),lnkptr(*)
      integer clkptr(*),ordptr(nptr),nptr
      integer ordclk(nordcl,2),nordcl,cord(*),iord(*),oord(*),zord(*)
      integer critev(*),rpptr(*),ipar(*),ipptr(*),funptr(*),funtyp(*)
      integer ierr

c     
      logical hot,urg
      integer i,k,ierr1,j,flag,keve,nord,nclock
      double precision t
      double precision tvec(nts)
c     
      integer         nblk,nordptr,nout,ng,nrwp,niwp,ncord,
     &     noord,nzord
      common /cossiz/ nblk,nordptr,nout,ng,nrwp,niwp,ncord,
     &     noord,nzord
C     
      integer halt
      common /coshlt/ halt
c     
      integer kfun
      common /curblk/ kfun
c     
      double precision atol,rtol,ttol,deltat
      common /costol/ atol,rtol,ttol,deltat
c     
c     
      urg=.false.
      keve = pointi
      pointi=evtspt(keve)
      evtspt(keve)=-1
c     
      nord=ordptr(keve+1)-ordptr(keve)
      if(nord.eq.0) return
c     
      call iset(nblk,-1,iwa,1)
      do 11 ii=ordptr(keve),ordptr(keve+1)-1
         kfun=ordclk(ii,1)
         iwa(kfun)=ordclk(ii,2)
 11   continue

      do 80 ii=ordptr(keve),ordptr(keve+1)-1
         kfun=ordclk(ii,1)
         if(outptr(kfun+1)-outptr(kfun).gt.0) then
            nclock=ordclk(ii,2)
            flag=1
            call callf(kfun,nclock,funptr,funtyp,told,w,x,xptr,z,
     $           zptr,iz,izptr,rpar,rpptr,ipar,ipptr,tvec,
     $           ntvec,inpptr,inplnk,outptr,outlnk,lnkptr,
     $           outtb,flag) 
            if(flag.lt.0) then
               ierr=5-flag
               return
            endif
         endif
 80   continue
c     
      do 60 ii=ordptr(keve),ordptr(keve+1)-1
         kfun=ordclk(ii,1)
c     .     Initialize tvec
         ntvec=clkptr(kfun+1)-clkptr(kfun)
         if(ntvec.gt.0) then
            call dset(ntvec,told-1.0d0,tvec,1)
c     
            flag=3
            call callf(kfun,ordclk(ii,2),funptr,funtyp,told,w,x,
     $           xptr,z,zptr,iz,izptr,rpar,rpptr,ipar,ipptr,tvec,
     $           ntvec,inpptr,inplnk,outptr,outlnk,lnkptr,
     $           outtb,flag) 
            if(flag.lt.0) then
               ierr=5-flag
               return
            endif
c     
            if (ntvec.ge.1) then
               if(funtyp(kfun).ne.-1) then
                  do 70 i = 1,ntvec
                     if (tvec(i) .ge. told) then
                        call addevs(tevts,evtspt,nevts,pointi,
     &                       tvec(i),i+clkptr(kfun)-1,ierr1)
                        if (ierr1 .ne. 0) then
C     !                 event conflict
                           ierr = 3
                           return
                        endif
                     endif
 70               continue
               else
                  urg=.true.
                  call putevs(tevts,evtspt,nevts,pointi,
     &                 told,ntvec+clkptr(kfun)-1,ierr1)
                  if (ierr1 .ne. 0) then
C     !                 event conflict
                     ierr = 3
                     return
                  endif
               endif
            endif
         endif
 60   continue
      if (urg)  then
 43      call edoit(neq,x,xptr,z,zptr,iz,izptr,told,tf
     $        ,tevts,evtspt,nevts,pointi,inpptr,inplnk,outptr
     $        ,outlnk,lnkptr,clkptr,ordptr,nptr
     $        ,ordclk,nordcl,cord,iord,niord,oord,zord,critev,
     $        rpar,rpptr,ipar
     $        ,ipptr,funptr,funtyp,outtb,w,hot,urg,ierr,iwa) 
         if(urg) goto 43
      endif

c     .  update continuous and discrete states on event
      do 61 kfun=1,nblk
         if(iwa(kfun).ne.-1) then
            if(xptr(kfun+1)-xptr(kfun)+zptr(kfun+1)-zptr(kfun)
     $           .gt.0) then
C     .     If continuous state jumps, do cold restart
               if(xptr(kfun+1)-xptr(kfun).gt.0) hot=.false.
               flag=2
               call callf(kfun,iwa(kfun),funptr,funtyp,told,w,x,
     $            xptr,z,zptr,iz,izptr,rpar,rpptr,ipar,ipptr,tvec,
     $            ntvec,inpptr,inplnk,outptr,outlnk,lnkptr,
     $            outtb,flag) 
               if(flag.lt.0) then
                  ierr=5-flag
                  return
               endif
            endif
         endif
 61   continue
      end






      subroutine edoit(neq,x,xptr,z,zptr,iz,izptr,told,tf
     $     ,tevts,evtspt,nevts,pointi,inpptr,inplnk,outptr
     $     ,outlnk,lnkptr,clkptr,ordptr,nptr
     $     ,ordclk,nordcl,cord,iord,niord,oord,zord,critev,
     $     rpar,rpptr,ipar
     $     ,ipptr,funptr,funtyp,outtb,w,hot,urg,ierr,iwa) 
C     
C     
C..   Parameters .. 
c     maximum number of clock output for one block
      integer nts
      parameter (nts=100)
C     
      integer neq(*),iwa(*)
C     neq must contain after #states all integer data for simblk and grblk
      double precision x(*),z(*),told,tf,tevts(*),rpar(*),outtb(*)
      double precision w(*)
C     X must contain after state values all real data for simblk and grblk
      integer xptr(*),zptr(*),iz(*),izptr(*),evtspt(nevts),nevts,pointi
      integer inpptr(*),inplnk(*),outptr(*),outlnk(*),lnkptr(*)
      integer clkptr(*),ordptr(nptr),nptr
      integer ordclk(nordcl,2),nordcl,cord(*),iord(*),oord(*),zord(*)
      integer critev(*),rpptr(*),ipar(*),ipptr(*),funptr(*),funtyp(*)
      integer ierr
c     
      logical hot,urg
      integer i,ierr1,flag,keve,nord,nclock
      double precision tvec(nts)
c     
      integer         nblk,nordptr,nout,ng,nrwp,niwp,ncord,
     &     noord,nzord
      common /cossiz/ nblk,nordptr,nout,ng,nrwp,niwp,ncord,
     &     noord,nzord
C     
      integer halt
      common /coshlt/ halt
c     
      integer kfun
      common /curblk/ kfun
c     
      double precision atol,rtol,ttol,deltat
      common /costol/ atol,rtol,ttol,deltat
c     
c     
      urg=.false.
      keve = pointi
      pointi=evtspt(keve)
      evtspt(keve)=-1
c     
      nord=ordptr(keve+1)-ordptr(keve)
      if(nord.eq.0) return
c

      do 12 ii=ordptr(keve),ordptr(keve+1)-1
         kfun=ordclk(ii,1)
         iwa(kfun)=ordclk(ii,2)
 12   continue
c
      do 80 ii=ordptr(keve),ordptr(keve+1)-1
         kfun=ordclk(ii,1)
         if(outptr(kfun+1)-outptr(kfun).gt.0) then
            nclock=ordclk(ii,2)
            flag=1
            call callf(kfun,nclock,funptr,funtyp,told,w,x,xptr,z,
     $           zptr,iz,izptr,rpar,rpptr,ipar,ipptr,tvec,
     $           ntvec,inpptr,inplnk,outptr,outlnk,lnkptr,
     $           outtb,flag) 
            if(flag.lt.0) then
               ierr=5-flag
               return
            endif
         endif
 80   continue
c     
      do 60 ii=ordptr(keve),ordptr(keve+1)-1
         kfun=ordclk(ii,1)
c     .     Initialize tvec
         ntvec=clkptr(kfun+1)-clkptr(kfun)
         if(ntvec.gt.0) then
            call dset(ntvec,told-1.0d0,tvec,1)
c     
            flag=3
            call callf(kfun,ordclk(ii,2),funptr,funtyp,told,w,x,
     $           xptr,z,zptr,iz,izptr,rpar,rpptr,ipar,ipptr,tvec,
     $           ntvec,inpptr,inplnk,outptr,outlnk,lnkptr,
     $           outtb,flag) 
            if(flag.lt.0) then
               ierr=5-flag
               return
            endif
c     

            if (ntvec.ge.1) then
               if(funtyp(kfun).ne.-1) then
                  do 70 i = 1,ntvec
                     if (tvec(i) .ge. told) then
                        call addevs(tevts,evtspt,nevts,pointi,
     &                       tvec(i),i+clkptr(kfun)-1,ierr1)
                        if (ierr1 .ne. 0) then
C     !                 event conflict
                           ierr = 3
                           return
                        endif
                     endif
 70               continue
               else
                  urg=.true.
                  call putevs(tevts,evtspt,nevts,pointi,
     &                 told,ntvec+clkptr(kfun)-1,ierr1)
                  if (ierr1 .ne. 0) then
C     !                 event conflict
                     ierr = 3
                     return
                  endif
               endif
            endif
         endif
 60   continue
      end


