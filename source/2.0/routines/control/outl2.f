C/MEMBR ADD NAME=OUTL2,SSI=0
      subroutine outl2(ifich,neq,neqbac,tq,v,t,tout)
c%but
c     cette subroutine contient les differents messages
c     a afficher suivant le deroulement de l execution.
c% liste d'appel
c     Entrees :
c     - ifich. est l'indice du message (-1 pour une
c        intersection avec la face, 1 pour une localisation
c        d un minimum local, 2 pour le resultat a un certain
c     degre ...)
c     - neq. est le degre (ou dimension) ou se situe
c        la recherche actuelle.
c     - neqbac. contient la valeur du degre avant le 1er
c        appel de lsoda
c     - tq. est le tableau contenant les coefficients du
c        polynome.
c
c     Sortie  : Aucune .
c%
      implicit double precision (a-h,o-y)
      dimension tq(0:*),tqdot(0:20),pd(400),tlq(0:20),tvq(0:200)
      dimension v(*)
      character*80 buf
      common/no2f/ef2
      common/comall/nall/sortie/nwf,info,ll
c
c
      write(buf(1:3),'(i3)') neq
c
      if(ifich.ge.80) goto 400
      if(ifich.ge.70) goto 350
      if(ifich.ge.60) goto 300
      if(ifich.ge.50) goto 250
      if(ifich.ge.40) goto 200
      if(ifich.ge.30) goto 150
      if(ifich.ge.20) goto 100
      write(buf(1:3),'(i3)') neq
      call basout(ifl,nwf,'----------------- RESULTAT AU DEGRE: '//
     $    buf(1:3)//' ----------------------')
c
      if (ifich.lt.0) then
         call basout(ifl,nwf,' Intersection avec face de degre '//
     $        buf(1:3)//' en :')
      else if (ifich.eq.1) then
         call basout(ifl,nwf,' Localisation d un minimum de degre '//
     $        buf(1:3)//' en Q :')
      else if (ifich.eq.2) then
         call basout(ifl,nwf,' Minimum local de degre '//
     $        buf(1:3)//' en Q :')
      else if (ifich.eq.3) then
         call basout(ifl,nwf,' Localisation d''un maximum de degre '//
     $        buf(1:3)//' en Q :')
      else if (ifich.eq.4) then
         call basout(ifl,nwf,' Maximum local de degre '//
     $        buf(1:3)//' en Q :')
      else if (ifich.eq.14.or.ifich.eq.15) then
         call basout(ifl,nwf,' Le point ou l''on se trouve est:')
      endif
c
      ef=sqrt(ef2)
c
      call dmdspf(tq,1,1,neq+1,15,ll,nwf)
c
      call basout(ifl,nwf,
     $     ' Le polynome numerateur correspondant etant :')
      call lq(neq,tq,tlq,tvq)
      call dscal(neq,ef,tlq,1)
      call dmdspf(tlq,1,1,neq,15,ll,nwf)
c
      call basout(ifl,nwf,
     $     ' Le gradient de la fonction critere y vaut :')
      call feq(neq,t,tq,tqdot)
      call dscal(neq,-ef,tqdot,1)
      call dmdspf(tqdot,1,1,neq,15,ll,nwf)
      phi0= abs(phi(tq,neq))
      write(buf(1:14),'(d14.7)') phi0
      call basout(ifl,nwf,' la valeur du critere             : '//
     $     buf(1:14))
      write(buf(1:14),'(d14.7)') ef
      call basout(ifl,nwf,' la norme de la donnee F          : '//
     $     buf(1:14))
      errel= sqrt(phi0)
      write(buf(1:14),'(d14.7)') errel
      call basout(ifl,nwf,' et l erreur relative             : '//
     $     buf(1:14))
c
      if (ifich.eq.14.or.ifich.eq.15) then
         call basout(ifl,nwf,' Et ou la hessienne vaut')
         call jacl2 (neq,t,tq,ml,mu,pd(1),neq)
         call dmdspf(pd,neq,neq,neq,15,ll,nwf)
      endif
      call basout(ifl,nwf,'------------------'//
     $     '---------------------------------------------')
      call basout(ifl,nwf, ' ')
      call basout(ifl,nwf, ' ')
 100  continue
c     messages du sous programme arl2
      if(ifich.eq.20) then
         call basout(ifl,nwf,'LSODE 1  '//
     $        '------------------------------------------------------')
         write(buf,'('' dg='',i2,''     dgback='',i2)') neq,neqbac
         call basout(ifl,nwf,buf(1:30))
      else if(ifich.eq.21) then
         call basout(ifl,nwf,'LSODE 2  '//
     $        '------------------------------------------------------')
      else if(ifich.eq.22) then
         call basout(ifl,nwf,
     $        ' Boucle indesirable sur 2 dimensions...')
         call basout(ifl,nwf,
     $        ' Arret de l execution !!! ')
      else if(ifich.eq.23) then
         write(buf(1:2),'(i2)') neqbac
         call basout(ifl,nwf,'Il y a eu '//buf(1:2)//
     $        ' retours de face.')
      endif
      return
c
 150  continue
c     messages du sous programme optml2
      if(ifich.eq.30) then
         call basout(ifl,nwf,'Optml2 =========='//
     $        ' parametres d''appel de lsode =================')
         write(buf,'(2d14.7)') t,tout
         call basout(ifl,nwf,' t= '//buf(1:14)//
     $        ' tout= '//buf(15:28))
         call basout(ifl,nwf,' Q initial :')
         call dmdspf(tq,1,1,neq+1,14,ll,nwf)
      else if(ifich.eq.31) then
         call basout(ifl,nwf,'Optml2 =========='//
     $        ' parametres de sortie de lsode ================')
         write(buf,'(d14.7)') v(1)
         call basout(ifl,nwf,' |grad|= '//buf(1:14))
         write(buf,'(i3)') neqbac
         call basout(ifl,nwf,' nbout= '//buf(1:3))
         write(buf,'(2d14.7)') t,tout
         call basout(ifl,nwf,' t= '//buf(1:14)//
     $        ' tout= '//buf(15:28))
         call basout(ifl,nwf,' Q final :')
         call dmdspf(tq,1,1,neq+1,14,ll,nwf)
         call basout(ifl,nwf,'Optml2 ==========='//
     $        ' fin description LSODE ======================')
         call basout(ifl,nwf,' ')
      else if(ifich.eq.32) then
         call basout(ifl,nwf,' Lsode: echec de la '//
     $        'convergence (istate=-5) ' )
         call basout(ifl,nwf,
     $        'nouvel appel avec des tolerances reduites')
      else if(ifich.eq.33) then
         call basout(ifl,nwf,' Lsode: echec de l''integration '//
     $        '(istate=-6) ' )
      else if(ifich.eq.34) then
         write(buf,'(2d14.7)') t,tout
         call basout(ifl,nwf,' t= '//buf(1:14)//
     $        ' tout= '//buf(15:28))
         write(buf,'(i5,d14.7)') neqbac,v(1)
         call basout(ifl,nwf,' itol= '//buf(1:5)//
     $        ' rtol= '//buf(6:19))
         call basout(ifl,nwf,'atol=')
         call dmdspf(tq,1,1,neq,14,ll,nwf)
      else if(ifich.eq.35) then
         write(buf,'(i5,d14.7)') neqbac
         call basout(ifl,nwf,' itol= '//buf(1:5))
         call basout(ifl,nwf,'rtol=')
         call dmdspf(v,1,1,neq,14,ll,nwf)
         call basout(ifl,nwf,'atol=')
         call dmdspf(tq,1,1,neq,14,ll,nwf)
      else if(ifich.eq.36) then
         call  basout(ifl,nwf,
     $        'nouvel appel avec des tolerances augmentees')
      else if(ifich.eq.37) then
         write(buf(1:2),'(i2)') neqbac
         call basout(ifl,nwf,' ARRET dans la routine lsode '//
     $        'pour istate ='//buf(1:2))
      else if(ifich.eq.38) then
         call  basout(ifl,nwf,' Lsode trop de pas '//
     $        'd''integration (istate= -1)')
         call basout(ifl,nwf,'   Nouvel appel pour completer'//
     $        ' l''integration')
      else if(ifich.eq.39) then
         call basout(ifl,nwf,
     $        'Non convergence de LSODE -- ARRET IMMEDIAT DE OPTML2')
      endif
      return
 200  continue
c message relatifs au sous programme domout
      if(ifich.eq.40) then
         call basout(ifl,nwf,' ')
         call basout(ifl,nwf,'******** RECHERCHE DE '//
     $        ' L''INTERSECTION AVEC LA FRONTIERE ********')
         write(buf(1:10),'(i10)') neqbac
         call basout(ifl,nwf,' kmax= '//buf(1:10))
      else if(ifich.eq.41) then
         call basout(ifl,nwf,'Domout =========='//
     $        ' parametres d''appel de lsode =================')
         write(buf,'(2d14.7)') t,tout
         call basout(ifl,nwf,' t= '//buf(1:14)//
     $        ' tout= '//buf(15:28))
         call basout(ifl,nwf,' Q initial :')
         call dmdspf(tq,1,1,neq+1,14,ll,nwf)
      else if(ifich.eq.42) then
         call basout(ifl,nwf,'Domout =========='//
     $        ' parametres de sortie de lsode ===============')
         write(buf,'(i3)') neqbac
         call basout(ifl,nwf,' nbout= '//buf(1:3))
         write(buf,'(2d14.7)') t,tout
         call basout(ifl,nwf,' t= '//buf(1:14)//
     $        ' tout= '//buf(15:28))
         call basout(ifl,nwf,' Q final :')
         call dmdspf(tq,1,1,neq+1,14,ll,nwf)
         call basout(ifl,nwf,'Domout =========='//
     $        ' fin description LSODE =======================')
         call basout(ifl,nwf,' ')
      else if(ifich.eq.43) then
         call basout(ifl,nwf,' Arret de l''integration sur nombre '//
     $        'limite d''iterations (istate=-1)')
         call basout(ifl,nwf,' Poursuite de l''integration par nouvel'//
     $        ' appel de LSODE')
      else if(ifich.eq.44) then
         write(buf(1:9),'(i9)') neqbac
         call basout(ifl,nwf,'nombre de racines a l''exterieur du '//
     $        'disque unite :nbout= '//buf(1:9))
      else if(ifich.eq.45) then
         write(buf(1:3),'(i3)') neqbac
         call basout(ifl,nwf,' Anomalie dans lsode (istate='//
     &        buf(1:3)//') au cours de la recherche de ')
         call basout(ifl,nwf,
     &        ' l''intersection avec une face ... Arret immediat !')
      else if(ifich.eq.46) then
         write(buf(1:9),'(i9)') neqbac
         call basout(ifl,nwf,'watface --> nface= '//buf(1:9))
         write(buf(1:9),'(i9)') neq
         call basout(ifl,nwf,'onface --> neq= '//buf(1:9))
         write(buf,'(2d14.4)') t,tout
         call basout(ifl,nwf,' yi= '//buf(1:14)//
     $        ' yf= '//buf(15:28))
         call dmdspf(tq,1,1,neq+1,14,ll,nwf)
      else if(ifich.eq.47) then
         call basout(ifl,nwf,' goto 314 ===========================')
         call basout(ifl,nwf,' qi = ')
         call dmdspf(v,1,1,neq+1,14,ll,nwf)
      else if(ifich.eq.47) then
         call basout(ifl,nwf,'****** FIN DE LA  RECHERCHE DE '//
     $        ' L''INTERSECTION AVEC LA FRONTIERE ************')
      endif
      return
c
 250  continue
c     messages de deg1l2 et degl2
      if(ifich.eq.50) then
         call basout(ifl,nwf,' Non convergence de la recherche ...')
         call basout(ifl,nwf,'          au suivant   .')
      else if(ifich.eq.51) then
         write(buf(1:3),'(i3)') neq
         call basout(ifl,nwf,'+++++++++++++++++++++++++++++++++++++++'//
     $        '++++++++++++++++++++++++')
         Call basout(ifl,nwf,' Recherche de l''ensemble des minima'//
     $        ' de degre '//buf(1:3))
         call basout(ifl,nwf,'+++++++++++++++++++++++++++++++++++++++'//
     $        '++++++++++++++++++++++++')
      else if(ifich.eq.52) then
         write(buf(1:3),'(i3)') neq
         call basout(ifl,nwf,'+++++++++++++++++++++++++++++++++++++++'//
     $        '++++++++++++++++++++++++')
         Call basout(ifl,nwf,' Fin de la recherche de l''ensemble '//
     $        ' des minima de degre '//buf(1:3))
         call basout(ifl,nwf,'+++++++++++++++++++++++++++++++++++++++'//
     $        '++++++++++++++++++++++++')
         mxsol=tout
         call basout(ifl,nwf,' Q(0) minimaux:')
         call dmdspf(tq,1,1,neq,14,ll,nwf)
         call basout(ifl,nwf,' erreurs relatives correspondantes')
         call dmdspf(tq(mxsol+1),1,1,neqbac,14,ll,nwf)
      else if(ifich.eq.53) then
         write(buf(1:3),'(i3)') neq
         call basout(ifl,nwf,'+++++++++++++++++++++++++++++++++++++++'//
     $        '++++++++++++++++++++++++')
         Call basout(ifl,nwf,' Fin de la recherche de l''ensemble '//
     $        ' des minima de degre '//buf(1:3))
         call basout(ifl,nwf,'+++++++++++++++++++++++++++++++++++++++'//
     $        '++++++++++++++++++++++++')
         mxsol=tout
         call basout(ifl,nwf,' Q minimaux (sans le terme de plus'//
     $        ' haut degre) :')
         call dmdspf(tq,mxsol,neqbac,neq,14,ll,nwf)
         call basout(ifl,nwf,' erreurs relatives correspondantes')
         call dmdspf(tq(mxsol*neq+1),mxsol,neqbac,1,14,ll,nwf)
      endif
      return
c
 300  continue
c messages de roogp
      if(ifich.eq.60) then
         call basout(ifl,nwf,'Rootgp :On ne trouve pas de valeur de'//
     $        ' Beta possible ')
         call basout(ifl,nwf,'        dans la recherche de '//'
     $        l''intersection avec la face complexe.')
         call basout(ifl,nwf,'        ARRET DE L''EXECUTION ')
      endif
      return
c
 350   continue
c messages de onface
      if(ifich.eq.70) then
      write(buf(1:3),'(i2)') neq
         call basout(ifl,nwf,'Frontiere atteinte, Chute de degre: '//
     $        buf(1:3))
      else if(ifich.eq.71) then
         call basout(ifl,nwf,'valeur du reste:')
         call dmdspf(tq,1,1,neq,14,ll,nwf)
      endif
      return
c
 400  continue
      if(ifich.eq.80) then
        call basout(ifl,nwf,'Minimum deja atteint precedement')
      else if(ifich.eq.81) then
        call basout(ifl,nwf,' Min sauvegarde dans tback ')
      endif
      return
      end
