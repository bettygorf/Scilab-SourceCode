      subroutine clunit( lunit, name, mode)
c ====================================================================
c
c     system dependent routine to allocate files
c
c ====================================================================
c
c     lunit   logical unit number
c     name    file name
c     mode    attach mode
c             recl = mode(2) ( direct file )
c             mode(1) definit le mode d'ouverture
c             le chiffre des centaines definit le format
c                0  ->  formatted
c             le chiffre des dizaines  definit l' acces
c                0  ->  sequential
c             le chiffre des unites    definit le status
c                0  ->  new
c                1  ->  old
c                2  ->  scratch
c                3  ->  unknown
c             si mode est negatif, on ouvre en read seulement (vax/vms)
c
c
c sur apollo, pour les fichiers binaires sequentiels, on met un recl a
c 250000 si celui-ci n'est pas donne par l'utilisateur. Pour ce faire,
c il suffit de remplacer la chaine 'cap' par trois blancs.
c
c
c reference externe : cluni0
c           fortran : len
c
c ====================================================================
c
      include '../stack.h'
      integer       lunit,mode(*)
      character*(*) name
c
      integer        nunit,unit(50)
      common /units/ nunit,unit
c
      integer       iacc,ifor,ista,k,rec
      character*11  for,sta
      character*800  nomfic
c
      if ( lunit.eq.rte .or. lunit.eq.wte ) then
c
c ----------------------------------------
c attach units  rte  and  wte  to terminal
c ----------------------------------------
c
         unit(lunit)=1
         goto 100
      elseif ( lunit.eq.-rte .or. lunit.eq.-wte ) then
         goto 100
      endif
c
      if ( lunit.lt.0 ) then
c
c ----------
c close file
c ----------
c
         if(unit(-lunit).gt.0) close( -lunit )
         unit(-lunit) = 0
      else
c
c ---------
c open file
c ---------
c
         k = abs(mode(1))
c
c ------------------------
c definition des attributs
c ------------------------
c
         rec  = mode(2)
         ifor = k / 100
         k    = k - 100 *ifor
         iacc = k / 10
         ista = k - 10  *iacc
c
         if ( ifor.eq.0 ) then
            for='formatted'
         else
            for='unformatted'
         endif
c
         if ( ista.eq.0 ) then
            sta='new'
         elseif ( ista.eq.1 ) then
            sta='old'
         elseif ( ista.eq.2 ) then
            sta='scratch'
         elseif ( ista.eq.3 ) then
            sta='unknown'
         else
            err = 67
            goto 100
         endif
c
         if ( lunit.ne.0 ) then
c
c -----------------------
c unite definie par lunit
c -----------------------
c
            if ( unit(lunit).ne.0 ) goto 40
            if ( mode(1).ge.0 ) then
c
c ouverture sans preciser les droits
c ----------------------------------
c
            if ( iacc.ne.0 ) then
               open( lunit, form=for, status=sta, access='direct',
     1                      recl=rec, err=30)
capollo . fichier binaire
c           elseif ( ifor.ne.0 ) then
c              if(rec.le.0) rec = 250 000
c              open( lunit, form=for, status=sta, access='sequential',
c    1                   recl=rec, err=30)
capollo
cvax . fichier formatte
c           elseif ( ifor.eq.0 ) then
c              open( lunit, form=for, status=sta, access='sequential',
c    1                      carriagecontrol='list',
c    2                      err=30)
cvax
            else
               open( lunit, form=for, status=sta, access='sequential',
     1                      err=30)
            endif
c
            else
c
c ouverture en read seulement
c ---------------------------
c
            if ( iacc.ne.0 ) then
cstandard
               open( lunit, form=for, status=sta, access='direct',
     1                      recl=rec, err=31)
cstandard
cvax
c              open( lunit, form=for, status=sta, access='direct',
c    1                      readonly,
c    2                      recl=rec, err=31)
cvax
capollo . fichier binaire
c           elseif ( ifor.ne.0 ) then
c              if(rec.le.0) rec = 250 000
c              open( lunit, form=for, status=sta, access='sequential',
c    1                      recl=rec, err=31)
capollo
cvax . fichier formatte
c           elseif ( ifor.eq.0 ) then
c              open( lunit, form=for, status=sta, access='sequential',
c    1                      carriagecontrol='list',
c    2                      readonly,
c    3                      err=31)
cvax
            else
cstandard
               open( lunit, form=for, status=sta, access='sequential',
     1                      err=31)
cstandard
cvax
c              open( lunit, form=for, status=sta, access='sequential',
c    1                      readonly,
c    2                      err=31)
cvax
            endif
c
         endif
         else
c
c -----------------
c unite non definie
c -----------------
c
            do 04 k=1,nunit
               if ( unit(k).ne.0 ) goto 04
               goto 05
   04       continue
            err = 66
            goto 100
   05       lunit = k
c
            if ( ista.ne.2 ) then
c
c nom du fichier
c --------------
c
               call cluni0( name, nomfic, k,ierr)
               if( ierr.ne.0) goto 30
c
c open avec status different de scratch sans preciser de droit
c ------------------------------------------------------------
c
               if (mode(1).ge.0 ) then
               if ( iacc.ne.0 ) then
                  open( lunit, file=nomfic(1:k), form=for,
     1                         access='direct' , status=sta,
     2                         recl=rec, err=30)
capollo . fichier binaire
c              elseif ( ifor.ne.0 ) then
c                 if(rec.le.0) rec = 250 000
c                 open( lunit, file=nomfic(1:k), form=for,
c    1                         access='sequential', status=sta,
c    2                         recl=rec, err=30)
capollo
cvax . fichier formatte
c              elseif ( ifor.eq.0 ) then
c                 open( lunit, file=nomfic(1:k), form=for,
c    1                         carriagecontrol='list',
c    2                         access='sequential' ,status=sta, err=30)
cvax
               else
                  open( lunit, file=nomfic(1:k), form=for,
     1                         access='sequential' ,status=sta, err=30)
               endif
c
               else
c
c open avec status different de scratch en read seulement
c -------------------------------------------------------
c
               if ( iacc.ne.0 ) then
cstandard
                  open( lunit, file=nomfic(1:k), form=for,
     1                         access='direct' , status=sta,
     2                         recl=rec, err=31)
cstandard
cvax
c                 open( lunit, file=nomfic(1:k), form=for,
c    1                         access='direct' , status=sta,
c    2                         readonly,
c    3                         recl=rec, err=31)
cvax
capollo . fichier binaire
c              elseif ( ifor.ne.0 ) then
c                 if(rec.le.0) rec = 250 000
c                 open( lunit, file=nomfic(1:k), form=for,
c    1                         access='sequential', status=sta,
c    2                         recl=rec, err=31)
capollo
cvax . fichier formatte
c              elseif ( ifor.eq.0 ) then
c                 open( lunit, file=nomfic(1:k), form=for,
c    1                         carriagecontrol='list',
c    2                         readonly,
c    3                         access='sequential' ,status=sta, err=31)
cvax
               else
cstandard
                  open( lunit, file=nomfic(1:k), form=for,
     1                         access='sequential' ,status=sta, err=31)
cstandard
cvax
c                 open( lunit, file=nomfic(1:k), form=for,
c    1                         readonly,
c    2                         access='sequential' ,status=sta, err=31)
cvax
               endif
c
            endif
c
            else
c
c open avec status scratch, on ouvre sans nom de fichier
c ------------------------------------------------------
c
               if ( iacc.ne.0 ) then
                  open( lunit, form=for, status=sta, access='direct',
     1                         recl=rec, err=30)
capollo . fichier binaire
c              elseif ( ifor.ne.0 ) then
c                 rec = 250 000
c                 open( lunit, form=for, status=sta,
c    1                         access='sequential', recl=rec, err=30)
capollo
cvax . fichier formatte
c              elseif ( ifor.eq.0 ) then
c                 open( lunit, form=for, status=sta,
c    1                         carriagecontrol='list',
c    2                         access='sequential', err=30)
cvax
               else
                  open( lunit, form=for, status=sta,
     1                         access='sequential', err=30)
               endif
            endif
         endif
         unit(lunit) = 1
         rewind lunit
      endif
c
      goto 100
c
c ----------
c error open
c ----------
c
   30 continue
      err = 240
      goto 100
   31 continue
      err = 241
      goto 100
c
   40 continue
      err = 65
      goto 100
c
c --------------
c end of program
c --------------
c
  100 continue
      end
