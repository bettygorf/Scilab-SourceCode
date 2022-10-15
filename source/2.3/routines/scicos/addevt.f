      subroutine addevs(tevts,evtspt,nevts,pointi,t,evtnb,ierr)
C 
      double precision tevts(nevts)
      integer evtspt(nevts)
      integer nevts
      integer pointi
      double precision t
      integer evtnb
      integer ierr
C 
C.. Local Scalars .. 
      integer i,j
C 
C
      ierr = 0
      if (evtspt(evtnb).ne.-1) then
         ierr=1
         return
      else
         evtspt(evtnb)=0
         tevts(evtnb)=t
      endif
      if(pointi.eq.0) then
         pointi=evtnb
         return
      endif
      if (t.le.tevts(pointi)) then
         evtspt(evtnb)=pointi
         pointi=evtnb
         return
      endif
      i = pointi
      itest=0
C     
 100  itest=itest+1
      if(itest.gt.nevts) then
         ierr=1
         return
      endif
      if(evtspt(i).eq.0) then
         evtspt(i)=evtnb
         return
      endif
      if (t.gt.tevts(evtspt(i))) then
        j = evtspt(i)
        if(evtspt(j).eq.0) then
           evtspt(j)=evtnb
           return
        endif
        i=j
        goto 100
      else 
         evtspt(evtnb)=evtspt(i)
         evtspt(i)=evtnb
      endif
      end 


      subroutine addevt(tevts,evtspt,nevts,pointi,pointf,t,evtnb,
     &                  ttol,ierr)
C 
      double precision tevts(nevts)
      integer evtspt(nevts)
      integer nevts
      integer pointi
      integer pointf
      double precision t
      integer evtnb
      double precision ttol
      integer ierr
C 
C.. Local Scalars .. 
      integer i,lasti
C 
C
      ierr = 0
      i = pointf
C     
 100  lasti = i
      i = i - 1
      if (i .eq. 0) then
        i = nevts
      endif
      if (t-ttol .ge. tevts(i)) then
        i = lasti
        goto 200
      else
        tevts(lasti) = tevts(i)
        evtspt(lasti) = evtspt(i)
        if (i .eq. pointi) goto 200
      endif
      goto 100
C
 200  tevts(i) = t
      evtspt(i) = evtnb
      pointf = pointf + 1
      if (pointf .eq. nevts+1) then
        pointf = 1
      endif
      if (pointf .eq. pointi) then
        ierr = 1
      endif
      end 
