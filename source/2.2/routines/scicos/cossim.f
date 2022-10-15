      subroutine cossim(x0,neq,told,tf,tevts,evtspt,nevts,pointi,pointf,
     &     inpptr,outptr,stptr,clkptr,
     &     cmat,ordptr,nptr,execlk,nexecl,ordclk,
     &     nordcl,cord,iord,oord,zord,critev,rpar,rptr,ipar,iptr,funptr,
     &     rhot,ihot,
     &     outtb,jroot,w,ierr)
C     
C     
C..   Parameters .. 
c     maximum number of clock output for one block
      integer nts
      parameter (nts=100)
C     
C..   Formal Arguments .. 
      double precision x0(*)
C     X0 must contain after state values all real data for simblk and grblk
      integer neq(*)
C     neq must contain after #states all integer data for simblk and grblk
      double precision told
      double precision tf
      integer nevts,nptr,nordcl,nexecl
      double precision tevts(nevts)
      integer evtspt(nevts)
      integer pointi
      integer pointf
      integer inpptr(*)
      integer outptr(*)
      integer stptr(*)
      integer clkptr(*)
      integer cmat(ninp)
      integer ordptr(nptr,2)
      integer execlk(nexecl,2),ordclk(*),cord(*),iord(*),oord(*),zord(*)
      integer critev(*)
      double precision rpar(*)
      integer rptr(*)
      integer ipar(*)
      integer iptr(*)
      integer funptr(*)
      double precision rhot(nrwp)
      integer ihot(*)
      double precision outtb(nout)
      integer jroot(*)
      integer ierr
      double precision w(*)
C     
C..   Local Scalars .. 
      logical hot
      integer i,k,ierr1,iopt,istate,itask,j,jdum,jt,kfun,
     &     ksz,flag,keve,kpo
      external grblk,simblk
      double precision t
C
      integer otimer,ntimer,stimer
      external stimer
C     
C..   Local Arrays .. 
      double precision ts(nts)
C     
C..   External Functions .. 
C     
C..   Common Blocks .. 
C...  Variables in Common Block ... 
      integer nblk,nxblk,ncblk,ndblk,nout,ncout,ninp,ncinp,ncst,ng,nrwp,
     &     niwp,ncord,niord,noord,nzord
      common /cossiz/ nblk,nxblk,ncblk,ndblk,nout,ncout,ninp,ncinp,
     &     ncst,ng,nrwp,niwp,ncord,niord,noord,nzord
      integer halt
      common /coshlt/ halt
C     
C...  Variables in Common Block ... 
      double precision atol,rtol,ttol
      common /costol/ atol,rtol,ttol
      save otimer
      data otimer/0/

C     
C     ... Executable Statements ...
C     
      ierr = 0
      hot = .false.
      call xscion(inxsci)
C     initialization
      call dset(nout,0.0d0,outtb,1)
      call inout(told,x0,outtb,inpptr,outptr,stptr,
     &     cmat,funptr,rpar,rptr,ipar,iptr,ninp,nout,
     &     iord,niord,w,nblk,ierr)
C     main loop on time
 10   continue
      if (told .ge. tf) return
      if (inxsci.eq.1) then
         ntimer=stimer()
         if (ntimer.ne.otimer) then
            call sxevents()
            otimer=ntimer
            if (halt.ne.0) then
               halt=0
               return
            endif
         endif
      endif
      if (pointi.eq.pointf) then
         t = tf
      else
         t = tevts(pointi)
      endif
      if (abs(t-told) .lt. ttol) then
         told = t
      endif
      if (told .gt. t) then
C     !  scheduling problem
         ierr = 1
         return
      endif
      if (told .ne. t) then
         if (ncst .eq. 0) then
C     no continuous state
            told = t
         else
C     integrate
            if (hot) then
               istate = 2
            else
               istate = 1
            endif
            itask = 4
C      Compute tcrit (rhot(1))
            rhot(1)=tf+ttol
            kpo=pointi
            if(pointf.eq.0) then
 20            if(critev(kpo).eq.1) then
                  rhot(1)=tevts(kpo)
                  goto 30
               endif
               kpo=evtspt(kpo)
               if(kpo.ne.0) goto 20
c     30            continue
            else
 21            if(critev(evtspt(kpo)).eq.1) then
                  rhot(1)=tevts(kpo)
                  goto 30
               endif
c     
               kpo=kpo+1
               if(kpo.eq.(nevts+1)) kpo=1
               if(kpo.ne.pointf) goto 21
            endif
 30         continue

c
            iopt = 0
            jt = 2
            t=min(t,tf+ttol)
c     !     save initial signs of zero crossing surface
            iz=1
            if (ng.gt.0) then
               do 35 i = inpptr(ncblk+ndblk+1),inpptr(nblk+1)-1
                  if (outtb(cmat(i)).gt.0) then
                     jroot(ng+iz) = 1
                  else
                     jroot(ng+iz) = 0
                  endif
                  iz=iz+1
 35            continue
            endif

            call lsodar(simblk,neq,x0,told,t,1,rtol,atol,itask,
     &           istate,iopt,rhot,nrwp,ihot,niwp,jdum,jt,grblk,
     &           ng,jroot)
            if (istate .le. 0) then
               if (istate .eq. -3) then
                  itask = 2
                  istate = 1
                  call lsoda(simblk,neq,x0,told,t,
     &                 1,rtol,atol,itask,
     &                 istate,iopt,rhot,nrwp,ihot,niwp,jdum,jt)
                  hot = .false.
                  if (istate .gt. 0) goto 38
               endif
C     !        integration problem
               ierr = 100-istate
               return
            endif
            hot = .true.
 38         call inout(told,x0,outtb,inpptr,outptr,stptr,
     &           cmat,funptr,rpar,rptr,ipar,iptr,ninp,nout,
     &           cord,ncord,w,nblk,ierr)
            if(ierr.ne.0) return
            if (istate .eq. 3) then
C     at a least one root has been found
               iz = 1
               do 50 i = ncblk+ndblk+1,nblk
                  ksz = inpptr(i+1) - inpptr(i)
c     !           kev is a base 2 coding of reached zero crossing surfaces
                  kev=0
                  do 40 j = 1,ksz
                     kev=2*kev+jroot(iz+ksz-j)
 40               continue
                  jjflg=1
                  if (kev.eq.0) jjflg=0
                  do 41 j = 1,ksz
                     kev=2*kev+jroot(ng+iz+ksz-j)
 41               continue
                  iz=iz+ksz
                  if (jjflg .ne. 0) then
                     flag=3
c     !              call corresponding block to determine output event (kev)
                     call callf(funptr(i),told,
     &                    x0(stptr(i)),stptr(i+1)-stptr(i),
     &                    x0(stptr(i+nblk)),
     &                    stptr(i+1+nblk)-stptr(i+nblk),w,0,
     &                    kev,
     &                    rpar(rptr(i)),rptr(i+1)-rptr(i),
     &                    ipar(iptr(i)),iptr(i+1)-iptr(i),
     &                    ts,clkptr(i+1)-clkptr(i),flag)
                     if(flag.lt.0) then
                        ierr=5-flag
                        return
                     endif
c     !              update event agenda
                     do 42 k=1,clkptr(i+1)-clkptr(i)
                        if (ts(k).ge.told) then
                           if (critev(k+clkptr(i)-1).eq.1)  hot=.false.
                           if(pointf.eq.0) then
                              call addevs(tevts,evtspt,nevts,pointi,
     &                             ts(k),k+clkptr(i)-1,ierr1)
                           else
                              call addevt(tevts,evtspt,nevts,pointi,
     &                             pointf,ts(k),k+clkptr(i)-1,
     &                             ttol,ierr1)
                           endif
                           if (ierr1 .ne. 0) then
C     !                       nevts too small
                              ierr = 3
                              return
                           endif
                        endif
 42                  continue
                  endif
 50            continue
            endif
         endif
      else
C     t==told
         if(pointf.eq.0) then
            keve = pointi
c     a verifier
            pointi=evtspt(keve)
            evtspt(keve)=-1
         else
            keve = evtspt(pointi)
c     a verifier
            pointi=pointi+1
            if (pointi.gt.nevts) pointi=1
         endif
c
         do 300 ii=ordptr(keve,1),ordptr(keve+1,1)-1
            kfun=execlk(ii,1)
            ksz = inpptr(kfun+1) - inpptr(kfun)
C     Compute inputs
            if(ksz.eq.0) goto 111
            do 110 ji=1,ksz
               w(ji)=outtb(cmat(inpptr(kfun)-1+ji))
 110        continue
 111        continue
C     update events
            if(clkptr(kfun+1)-clkptr(kfun).gt.0) then
               flag=3
               call callf(funptr(kfun),told,
     &              x0(stptr(kfun)),stptr(kfun+1)-stptr(kfun),
     &        x0(stptr(kfun+nblk)),stptr(kfun+1+nblk)-stptr(kfun+nblk),
     &              w,ksz,
     &              execlk(ii,2),
     &              rpar(rptr(kfun)),rptr(kfun+1)-rptr(kfun),
     &              ipar(iptr(kfun)),iptr(kfun+1)-iptr(kfun),
     &              ts,clkptr(kfun+1)-clkptr(kfun),flag)
               if(flag.lt.0) then
                  ierr=5-flag
                  return
               endif
               do 200 i = 1,clkptr(kfun+1)-clkptr(kfun)
                  if (ts(i) .ge. t) then
                     if(pointf.eq.0) then
                        call addevs(tevts,evtspt,nevts,pointi,
     &                       ts(i),i+clkptr(kfun)-1,ierr1)
                     else
                        call addevt(tevts,evtspt,nevts,pointi,pointf,
     &                    ts(i),i+clkptr(kfun)-1,ttol,ierr1)
                     endif
                     if (ierr1 .ne. 0) then
C     !            nevts too small
                        ierr = 3
                        return
                     endif
                  endif
 200           continue
            endif
C     update state
            if((stptr(kfun+1)-stptr(kfun)+stptr(kfun+1+nblk)-
     &           stptr(kfun+nblk)).gt.0) then
C     If continuous state jumps, do cold restart
               if(kfun.le.nxblk) hot=.false.
               flag=2
               call callf(funptr(kfun),told,
     &              x0(stptr(kfun)),stptr(kfun+1)-stptr(kfun),
     &        x0(stptr(kfun+nblk)),stptr(kfun+1+nblk)-stptr(kfun+nblk),
     &              w,ksz,execlk(ii,2),
     &              rpar(rptr(kfun)),rptr(kfun+1)-rptr(kfun),
     &              ipar(iptr(kfun)),iptr(kfun+1)-iptr(kfun),
     &              w(ksz+1),max(stptr(kfun+1)-stptr(kfun),
     &              stptr(kfun+1+nblk)-stptr(kfun+nblk)),flag)
               if(flag.lt.0) then
                  ierr=5-flag
                  return
               endif
            endif
 300     continue
C     update output part
         call inout(told,x0,outtb,inpptr,outptr,stptr,
     &        cmat,funptr,rpar,rptr,ipar,iptr,ninp,nout,
     &        ordclk(ordptr(keve,2)),
     &        ordptr(keve+1,2)-ordptr(keve,2),w,nblk,ierr)
         if(ierr.ne.0) return
C     end of main loop on time
      endif
      goto 10
      end 
