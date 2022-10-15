C/MEMBR ADD NAME=CLUNI0,SSI=0
      subroutine cluni0( name, nams, ln,ierr)
c
c ====================================================================
c scilab . librairie vax
c ====================================================================
c
c rechercher un nom logique au debut de la chaine name et donner dans
c nams la chaine de caracteres reelles
c
c programme dependant machine
c
c ====================================================================
c
c
c Au premier  passage, on  recupere les  chaines equivalentes  et leur
c longueur dans les tableaux  chaine et lchain. Aux passages suivants,
c on teste l'utilisation d'une abreviation et si oui, on la  remplace.
c Si on ne peut definir de nom logique, on peut creer des abreviations
c dans ce  sous programme en affectant des valeurs coherentes aux var-
c iables lchain et chaine, lnomlo et nomlog, labrev et abrevi.
c
c Si lchain(i) est nul, chaine(i) est donnee par le nom logique  ou la
c variable nomlog(i). Si lchain(i)  est postif, chaine(i)(1:lchain(i))
c est supposee definie dans le programme. Si lchain(i) est negatif, on
c prend chaine(i) = chaine(abs(lchain(i))
c
c
c apollo    : Sous aegis, on definit un lien par la commande crl et le
c             systeme effectue lui meme le remplacement.
c
c               ex : crl sci /u/scilab
c
c
c cdc/nos-ve: On cree une variable systeme de type chaine  par la com-
c             mande CREV, puis on affecte son contenu.
c
c             ex . crev SCI k=string
c                  SCI='.b36gri.scilab'
c
c
c ibm vn/cms: Pas d arborescence et de nom logique, les  fichiers sont
c             recherches  sur les  "machines"  en lien  avec celle  de
c             l utilisateur. La "machine" SCILAB en fait partie.
c
c
c unix      : Les noms logiques sont definis a  l'aide de  la commande
c             setenv  ou  export. La chaine est  recuperee par l'appel
c             au programme GETENV. Il faut parfois  remplacer les CALL
c             GETENV par un sous programme GETENVC ecrit en C.
c
c             /* getenvc . procedure chargee de recuperer le contenu
c                          d une variable d environnement           */
c             voir getenvc
c             ex : setenv SCI /u/scilab
c             ou : SCI=/u/scilab
c                  export SCI
c
c
c vax/vms   : On definit  les noms  logiques par  la commande  DEFINE.
c             Ceux-ci doivent etre en majuscules. Le directory courant
c             (HOME) est donne par le nom logique SYS$LOGIN.
c
c             ex : define SCI [user.scilab]
c
c
c ====================================================================
c
c
c entree : name    nom de fichier donne eventuellement avec un nom
c                  logique
c
c
c sortie : mans    chaine equivalente en remplacant le nom logique
c          ln      longueur de la chaine en sortie nams
c
c
c interne: nblog   nombre d'abreviations definies
c          abrevi  chaine des abreviations a tester
c          chaine  chaine equivalente
c          nomlog  nom logique associe a chaque abrevation
c          sep     caractere separateur de l arborescence
c
c
c reference fortran : char len
c
c
      character*(*) name,nams
      integer       ln
c
      character*1   nul,sep
      integer       i,l1,l2
c
c
c --------------
c version apollo
c --------------
c Sous aegis, on definit un  lien par la  commande crl  et le  systeme
c effectue lui meme le remplacement.
c
c ex : crl sci /u/scilab
c
c
c     integer       nblog
c     parameter   ( nblog=5 )
c     character*80  abrevi(nblog),chaine(nblog),nomlog(nblog)
c     integer       labrev(nblog),lchain(nblog),lnomlo(nblog)
c     logical       lpas
c     save          lpas, labrev, lchain, lnomlo
c     save                abrevi, chaine, nomlog
c     data lpas   / .false. /
c     data labrev / 4, 4, 5, 5, 2 /
c     data lchain / 0,-1, 0,-3,-4 /
c     data lnomlo / 3, 3, 4, 4, 4 /
c     data abrevi / 'SCI/', 'sci/', 'HOME/', 'home/', '~/'   /
c     data chaine /  ' '  ,  ' '  ,  ' '   ,  ' '   , ' '    /
c     data nomlog / 'SCI' , 'SCI' , 'HOME' , 'HOME' , 'HOME' /
c     data sep    / '/' /
c
c
c ----------
c cdc nos-ve
c ----------
c On cree une variable systeme de  type chaine par  la commande  CREV,
c puis on affecte son contenu.
c
c ex . crev SCI k=string
c      SCI='.b36gri.scilab'
c
c     integer       nblog
c     parameter   ( nblog=5 )
c     character*80  abrevi(nblog),chaine(nblog),nomlog(nblog),buff
c     integer       labrev(nblog),lchain(nblog),lnomlo(nblog)
c     logical       lpas
c     save          lpas, labrev, lchain, lnomlo
c     save                abrevi, chaine, nomlog
c     data lpas   / .false. /
c     data labrev / 4, 4, 5, 5, 2 /
c     data lchain / 0,-1, 5, 5, 5 /
c     data lnomlo / 3, 3, 4, 4, 4 /
c     data abrevi / 'SCI.', 'sci.', 'HOME.', 'home.', '~.'   /
c     data chaine /  ' '  ,  ' '  , '$user', '$user', '$user'/
c     data nomlog / 'SCI' , 'SCI' , 'HOME' , 'HOME' , 'HOME' /
c     data sep    / '.' /
c
c     if ( lpas ) goto 05
c
c premier passage : recuperation des nom logiques
c
c     do 03 i=1,nblog
c        if ( lchain(i).gt.0 ) goto 03
c        l1 =  lchain(i)
c        if ( l1.lt.0 ) then
c          l1=abs(l1)
c          lchain(i)=lchain(l1)
c          if ( lchain(l1).gt.0 ) chaine(i)=chaine(l1)(1:lchain(l1))
c          goto 03
c        endif
c        chaine(i) = ' '
c        lchain(i) =  0
c        if ( abrevi(i).eq.' ' ) labrev(i) =  0
c        if ( labrev(i).eq. 0  ) abrevi(i) = ' '
c        if ( nomlog(i).eq.' ' ) lnomlo(i) =  0
c        if ( lnomlo(i).eq. 0  ) nomlog(i) = ' '
c        if ( lnomlo(i).le. 0  ) goto 03
c        call redcvar( nomlog(i)(1:lnomlo(i)), 1, l1, buff)
c        lchain(i) = max ( l1 , 0 )
c        if ( l1.gt.0 ) chaine(i) = buff(1:l1)
c  03 continue
c
c ------------------
c version ibm vn/cms
c ------------------
c pas d arborescence et de nom logique, les fichiers sont recherches
c sur les "machines" en lien avec celle de l utilisateur. La "machine"
c SCILAB en fait partie.
c
c     integer       nblog
c     parameter   ( nblog=1 )
c     character*80  abrevi(nblog),chaine(nblog),nomlog(nblog)
c     integer       labrev(nblog),lchain(nblog),lnomlo(nblog)
c     logical       lpas
c     save          lpas, labrev, lchain, lnomlo
c     save                abrevi, chaine, nomlog
c     data lpas   / .false. /
c     data labrev /  0  /
c     data lchain /  0  /
c     data lnomlo /  0  /
c     data abrevi / ' ' /
c     data chaine / ' ' /
c     data nomlog / ' ' /
c     data sep    / ' ' /
c
c ------------
c version unix ( sun )
c ------------
c Les noms logiques sont definis par les commandes setenv ou export.
c La chaine est  recuperee par l'appel a GETENV ou GETENVC.
c
c ex : setenv SCI /u/scilab
c ou : SCI=/u/scilab
c      export SCI
c
      integer       nblog
      parameter   ( nblog=5 )
      character*80  abrevi(nblog),chaine(nblog),nomlog(nblog),buff
      integer       labrev(nblog),lchain(nblog),lnomlo(nblog)
      logical       lpas
      save          lpas, labrev, lchain, lnomlo
      save                abrevi, chaine, nomlog
      data lpas   / .false. /
      data labrev / 4, 4, 5, 5, 2 /
      data lchain / 0,-1, 0,-3,-4 /
      data lnomlo / 3, 3, 4, 4, 4 /
      data abrevi / 'SCI/', 'sci/', 'HOME/', 'home/', '~/'   /
      data chaine /  ' '  ,  ' '  ,  ' '   ,  ' '   , ' '    /
      data nomlog / 'SCI' , 'SCI' , 'HOME' , 'HOME' , 'HOME' /
      data sep    / '/' /
c
      ierr=0
      if ( lpas ) goto 05
c
c premier passage : recuperation des nom logiques
c
      nul = char ( 0 )
      do 03 i=1,nblog
         if ( lchain(i).gt.0 ) goto 03
         l1 =  lchain(i)
         if ( l1.lt.0 ) then
           l1=abs(l1)
           lchain(i)=lchain(l1)
           if ( lchain(l1).gt.0 ) chaine(i)=chaine(l1)(1:lchain(l1))
           chaine(i)=chaine(l1)(1:lchain(l1))
           goto 03
         endif
         chaine(i) = ' '
         lchain(i) =  0
         if ( abrevi(i).eq.' ' ) labrev(i) =  0
         if ( labrev(i).eq. 0  ) abrevi(i) = ' '
         if ( nomlog(i).eq.' ' ) lnomlo(i) =  0
         if ( lnomlo(i).eq. 0  ) nomlog(i) = ' '
         if ( lnomlo(i).le. 0  ) goto 03
         buff=' '
c         call getenv( nomlog(i)(1:lnomlo(i)), buff)
         call getenvc(ierr,nomlog(i)(1:lnomlo(i))//char(0), buff)
         if(ierr.ne.0) return
         do 01 l1=80,1,-1
            if ( buff(l1:l1).eq.' ' .or. buff(l1:l1).eq.nul ) goto 01
            goto 02
 01      continue
         l1 = 0
 02      continue
         lchain(i) = l1
         if ( l1.gt.0 ) chaine(i) = buff(1:l1)
 03   continue
c
c ---------------
c version vax-vms
c ---------------
c On definit les noms logiques par la commande DEFINE. Ceux-ci doivent
c etre en majuscules. Le directory courant (HOME) est donne par le nom
c logique SYS$LOGIN.
c
c     ex : define SCI [user.scilab]
c
c      integer       nblog
c      parameter   ( nblog=10 )
c      character*80  abrevi(nblog),chaine(nblog),nomlog(nblog)
c      integer       labrev(nblog),lchain(nblog),lnomlo(nblog)
c      logical       lpas
c      save          lpas, labrev, lchain, lnomlo
c      save                abrevi, chaine, nomlog
c      data lpas   / .false. /
c      data labrev / 4, 4, 4, 4, 5, 5, 5, 5, 2, 2 /
c      data lchain / 0,-1,-1,-1, 0,-5,-5,-5,-5,-5 /
c      data lnomlo / 3, 3, 3, 3, 9, 9, 9, 9, 9, 9 /
c      data abrevi / 'SCI]' , 'sci]' , 'SCI.' , 'sci.' ,
c     +              'HOME]', 'home]', 'HOME.', 'home.',
c     +              '~]'   , '~.'   /
c      data chaine / ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' /
c      data nomlog / 'SCI', 'SCI', 'SCI', 'SCI',
c     +              'SYS$LOGIN', 'SYS$LOGIN',
c     +              'SYS$LOGIN', 'SYS$LOGIN',
c     +              'SYS$LOGIN', 'SYS$LOGIN'/
c      data sep    / ']' /
cc
c      integer sys$trnlnm
c      integer stat,term_chan
c      include '($iodef)'
c      include '($psldef)'
c      include '($lnmdef)'
cc
cc system services
cc
c      structure /itmlst_3/
c         integer*2  buflen, itmcod
c         integer*4  bufadr, retadr ,end_list
c      end structure
c      record /itmlst_3/ trnlnm_list
cc
c      if ( lpas ) goto 05
cc
cc premier passage : recuperation des nom logiques
cc
c      do 03 i=1,nblog
c         if ( lchain(i).gt.0 ) goto 03
c         l1 =  lchain(i)
c         if ( l1.lt.0 ) then
c           l1=abs(l1)
c           lchain(i)=lchain(l1)
c           if ( lchain(l1).gt.0 ) chaine(i)=chaine(l1)(1:lchain(l1))
c           goto 03
c         endif
c         chaine(i) = ' '
c         lchain(i) =  0
c         if ( abrevi(i).eq.' ' ) labrev(i) =  0
c         if ( labrev(i).eq. 0  ) abrevi(i) = ' '
c         if ( nomlog(i).eq.' ' ) lnomlo(i) =  0
c         if ( lnomlo(i).eq. 0  ) nomlog(i) = ' '
c         if ( lnomlo(i).le. 0  ) goto 03
c         trnlnm_list.buflen   = len(chaine(i))
c         trnlnm_list.itmcod   = lnm$_string
c         trnlnm_list.bufadr   = %loc(chaine(i))
c         trnlnm_list.retadr   = %loc(lchain(i))
c         trnlnm_list.end_list = 0
c         stat = sys$trnlnm(,'LNM$FILE_DEV',nomlog(i)(1:lnomlo(i)),
c     +                      psl$c_user,trnlnm_list)
c         lchain(i) = lchain(i) - 1
c   03 continue
c
c
c ------------------------------
c version en cas d'impossibilite
c ------------------------------
c On peut definir des abreviations dans ce  sous programme. Pour cela,
c il suffit d affecter des valeurs coherentes aux  variables lchain et
c chaine
c
c     integer       nblog
c     parameter   ( nblog=5 )
c     character*80  abrevi(nblog),chaine(nblog),nomlog(nblog)
c     integer       labrev(nblog),lchain(nblog),lnomlo(nblog)
c     logical       lpas
c     save          lpas, labrev, lchain, lnomlo
c     save                abrevi, chaine, nomlog
c     data lpas   / .false. /
c     data labrev /  4,  4, 5,  5,  2 /
c     data lchain /  9, -1, 0, -3, -3 /
c     data lnomlo /  3,  3, 4,  4,  4 /
c     data abrevi / 'SCI/', 'sci/' , 'HOME/', 'home/', '~/' /
c     data chaine / '/u/scilab', '/u/scilab', ' ', ' ', ' ' /
c     data nomlog / 'SCI', 'SCI' , 'HOME', 'HOME', 'HOME' /
c     data sep    / '/' /
c
c -----------
c fin version
c -----------
c
      lpas = .true.
c
c --------------------------------
c recherche du nom et remplacement
c --------------------------------
c
   05 continue
      l2 = len ( name )
      if ( index(name,sep).eq.0 ) goto 07
      do 06 i=1,nblog
         l1 = labrev(i)
         if ( l2.le.l1 .or. lnomlo(i).le.0 .or. l1.le.0 ) goto 06
         if ( name(1:l1).ne.abrevi(i)(1:l1) ) goto 06
         if ( lchain(i).gt.0 ) then
            ln                = lchain(i)
            nams(1:ln)        = chaine(i)(1:ln)
            ln                = ln + 1
            nams(ln:ln+l2-l1) = name(l1:l2)
            ln                = ln + l2 - l1
         else
            nams = name(l1+1:l2)
            ln   = l2 - l1
         endif
         goto 08
   06 continue
c
   07 continue
      nams = name
      ln   = l2
c
   08 continue
      goto 100
c
c ---
c fin
c ---
c
  100 continue
      end
