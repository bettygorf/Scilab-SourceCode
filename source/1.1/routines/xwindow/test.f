      program test 
      parameter (nn=30)
      integer basdesc(3),ldesc,basstrings(3*30),nstring
      integer ptrstrings(10)
      integer nrep
      integer ierr
      data basdesc / 10,11,12/
      ldesc=3
      nstring=3
      do 10 i=1,30
         basstrings(i)=i
         basstrings(30+i)=i
         basstrings(60+i)=i
 10   continue
      ptrstrings(2)=nn+1
      ptrstrings(3)=2*nn+1
      ptrstrings(4)=3*nn+1
      call inix()
      call inibas()
      call xchoose(basdesc,ldesc,basstrings,nstring,
     $     ptrstrings,nrep,ierr)
      call xchoose(basdesc,ldesc,basstrings,nstring,
     $     ptrstrings,nrep,ierr)
      call xchoose(basdesc,ldesc,basstrings,nstring,
     $     ptrstrings,nrep,ierr)
      call xchoose(basdesc,ldesc,basstrings,nstring,
     $     ptrstrings,nrep,ierr)
      call xmsg(basstrings,nstring,ptrstrings,ierr)
      ierr=3
      nrep=3
      call xdialg(basstrings,ptrstrings,nstring,
     $     basstrings,ptrstrings,nstring,
     $     basstrings,ptrstrings,nrep,ierr)
      ierr=3
      call xmdial(basstrings,ptrstrings,nstring,basstrings,ptrstrings,
     $     basstrings,ptrstrings,nstring,
     $     basstrings,ptrstrings,ierr)
      ierr=3
      call xmdial(basstrings,ptrstrings,nstring,basstrings,ptrstrings,
     $     basstrings,ptrstrings,nstring,
     $     basstrings,ptrstrings,ierr)
      ierr=3
      call xmdial(basstrings,ptrstrings,nstring,basstrings,ptrstrings,
     $     basstrings,ptrstrings,nstring,
     $     basstrings,ptrstrings,ierr)
      call mbar()
      end

      subroutine cvstr(n,line,str,job)
c!but
c     converti une chaine de caracteres code  en une chaine
c     standard. les eol (99) sont remplaces  par des !
c
c!appel
c     call cvstr(n,line,str,job)
c     ou
c     n: entier, longueur de la chaine a convertir
c     line: vecteur entier, contient le code des caracteres 
c     string: caracter, contient des caracteres ASCII
c     job: entier, si egal a 1: code-->ascii
c                  si egal a 0: ascii-->code
c!
c
      include '../stack.h'
c
      integer line(*)
      character str*(*),mc*1
c
      if(job.eq.0) goto 40
c
c     conversion code ->ascii
      do 30 j=1,n
      m=line(j)
      if(abs(m).gt.csiz) m=99
      if(m.eq.99) goto 10
      if(m.lt.0) then
                     str(j:j)=alfb(abs(m)+1)
                 else
                     str(j:j)=alfa(m+1)
      endif
      goto 30
   10 str(j:j)='!'
   30 continue
      return
c
c     conversion ascii ->code
   40 continue
      lj=0
      do 50 j=1,n
      mc=str(j:j)
      do 45 k=1,csiz
      if(mc.eq.alfa(k)) then
         lj=lj+1
         line(lj)=k-1
         goto 50
      elseif(mc.eq.alfb(k)) then
         lj=lj+1
         line(lj)=-(k-1)
         goto 50
      endif
   45 continue
      k = eol+1
      call xchar(mc,k)
      if (k .gt. eol) then
         lj=0
      elseif (k .eq. eol) then
         lj=lj+1
         line(lj)=k
      elseif (k .eq. -1) then
         lj=max(lj-1,0)
      elseif (k .le. 0) then
c on ignore le caractere         
      else
         lj=lj+1
         line(lj)=k
      endif
   50 continue
      end
      subroutine xchar(line,k)
c     ======================================================================
c     routine systeme dependente  pour caracteres speciaux
c     ======================================================================
c effacement de la ligne : retourner  k>99
c fin de ligne : retourner k=99
c effacement du caractere precedent :retourner k=-1
c ignorer le caractere : retourner k=0
c
      include '../stack.h'
c
      integer blank
      data blank/40/
      integer k
      character line*(*)
c
      if(ichar(line(1:1)).eq.0) then
c     prise en compte de la marque de fin de chaine C
c     dans le cas d'un appel de matlab par un programme C
         k=99
      elseif(ichar(line(1:1)).eq.9) then
c     tab remplace par un blanc
         k=blank+1
      else
         k=0
      endif
c
      end
      subroutine inibas( ini1, bu1, vsizr, ierr)
c
c ====================================================================
c
c             initialisation du logiciel 
c
c ====================================================================
c
c reference externe : adr    banier clunit error  d1mach i1mach 
c                     inffic inibrk 
c
      integer        ierr,ini1,vsizr
      character*(*)  bu1
c
c
      include '../stack.h'
      integer adr
c
c common unite logique
      integer         nunit,unit(20)
      common /units / nunit,unit
c common pour la gestion du break
      logical         iflag
      common /basbrk/ iflag
c common pour le mode de protection des macros
      common /mprot/ macprt
c
      save /stack/,/vstk/,/recu/,/iop/,/com/,/cha1/
      save /units/
c
      logical first
      double precision d1mach
      integer i1mach
      integer i,il,k,l,lecbuf,nc
      integer eps(nsiz),im(nsiz),exp(nsiz),pi(nsiz),bl(nsiz),io(nsiz)
      integer inf(nsiz),nan(nsiz),true(nsiz),false(nsiz)
c
c     character set
c            0       10       20       30       40       50
c
c     0      0        a        k        u   colon  :  less   <
c     1      1        b        l        v   plus   +  great  >
c     2      2        c        m        w   minus  -  perc   %
c     3      3        d        n        x   star   *  under  _
c     4      4        e        o        y   slash  /
c     5      5        f        p        z   bslash \
c     6      6        g        q  blank     equal  =
c     7      7        h        r  lparen (  dot    .
c     8      8        i        s  rparen )  comma  ,
c     9      9        j        t  semi   ;  quote  '
c
      character alpha(csiz)*1,alphb(csiz)*1
      data alpha /'0','1','2','3','4','5','6','7','8','9',
     $    'a','b','c','d','e','f','g','h','i','j',
     $    'k','l','m','n','o','p','q','r','s','t',
     $    'u','v','w','x','y','z','_','#','!','0',
     $    ' ','(',')',';',':','+','-','*','/','\\',
     $    '=','.',',','''','[',']','%','|','&','<','>','~',
     $    '^'/
c
c     alternate character set
c
      data alphb /'0','1','2','3','4','5','6','7','8','9',
     $    'A','B','C','D','E','F','G','H','I','J',
     $    'K','L','M','N','O','P','Q','R','S','T',
     $    'U','V','W','X','Y','Z','0','0','?','0',
     $    '0','0','0','0','0','0','0','0','0','$',
     $    '0','0','0','"','{','}','0','0','0','`','0','@',
     $    '0'/
c
      data im/673714744,673720360/,exp/673713720,673720360/
      data pi/672274744,673720360/,bl/673720360,673720360/
      data eps/471404088,673720360/,io/672666168,673720360/
      data first/.true./
      data inf/253170232,673720360/,nan/386537272,673720360/
      data true/673717560,673720360/,false/673713976,673720360/
c
      data nunit/20/
c---------------------
      do 20 i = 1, csiz
         alfa(i) = alpha(i)
         alfb(i) = alphb(i)
   20 continue
      return
      end
