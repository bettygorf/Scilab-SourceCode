c      program newfun
c
c     generating new routine funtab.f
c
      integer fsiz,nsiz,csiz,nlgh,bsiz
      parameter (fsiz=500,nlgh=8)
      parameter (csiz=63,bsiz=4096,isiz=500,psiz=128,nsiz=2,lsiz=4096)
      character*1 ligne(80),funn(nlgh,fsiz),funm(nlgh,fsiz)
      character*8 name
      character*50 fmt
      character*50 fmt1
      character alfa(csiz)*1,alfb(csiz)*1,buf*(bsiz)
      character alpha(csiz)*1,alphb(csiz)*1
      common /cha1/ alfa,alfb,buf
      integer funp(fsiz),funl,funl1,fn(24),ind(fsiz),count(27)
      integer funt(fsiz)
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
c initialization of data alfa alfb
      do 05 i=1,csiz
      alfa(i)=alpha(i)
      alfb(i)=alphb(i)
   05 continue
c
c 
      nfuns=50
      nfunn=51
      nout=60
      open(nfuns,file='funtab.f',status='old')
      open(nfunn,file='fundef',status='old')
      open(nout,file='funtab.f.new',status='new')
c
      ncl=3
      nlig=10
   10 continue
      read(nfuns,'(80a1)') ligne
      ll=81
 11   ll=ll-1
      if(ll.eq.0) goto 10
      if(ligne(ll).eq.' ') goto 11
      write(nout,'(80a1)') (ligne(i),i=1,ll)
      if(ligne(1).ne.'c' .or. ligne(2).ne.'+') goto 10
c
c 
      write(fmt,'(''('',i2,''a1,1x,i4)'')') nlgh
      write(fmt1,'(''('',i2,''a1,1x,i4,3x,i1)'')') nlgh
      funl=0
      funl1=0
   15 funl=funl+1
      read(nfunn,fmt1,end=16) (funn(k,funl),k=1,nlgh),funp(funl),
     $ funt(funl)
      if (funt(funl).eq.1) then
      funl1=funl1+1
      do 1234 lll=1,nlgh
      funm(lll,funl1)=funn(lll,funl)
 1234 continue
      endif
      goto 15
   16 continue
      funl=funl-1
c      write(6,*) ((funm(i,j),i=1,nlgh),j=1,funl1)
c
c 
c
      l=1
      count(1)=1
      do 18 i=1,26
      nco=0
         do 17 k=1,funl
         if(funn(1,k).ne.alpha(10+i).and.funn(1,k).ne.alphb(10+i))
     1                                               goto 17
         nco=nco+1
         ind(l)=k
         l=l+1
   17    continue
      count(i+1)=count(i)+nco
   18 continue
c      write(6,*) ind
      if(count(27)-1.ne.funl) then
      write(6,*) 'names must begin with a letter!'
      write(6,*) count(27),funl
      stop
      endif
c
c
      write(nout,1011) funl
 1011 format('      parameter (maxfun=nfree+',i3,')')
      write(nout,101) 
  101 format('      integer funl,funl1,funn(nsiz,maxfun),funp(maxfun)' )
      write(nout,7101)
 7101 format('      integer funm(nsiz,maxfun)')
      write(nout,102) 
 102  format('      common /funcs/funl,funn,funp')
      write(nout,7103) funl
7103  format('      data funl/',i3,'/')
      write(nout,103) funl1
 103  format('      data funl1/',i3,'/')
c
c
c
c
      fmt(1:14)='(''c    '',a1,1x,'
      write(fmt(15:),
     $     '(i2,''a1,7x,'',i2,''a1,7x,'',i2,''a1,7x,'',i2,''a1)'')')
     $     nlgh,nlgh,nlgh,nlgh
      l=0
      m=2
   20 continue
      nf=min0(ncl,funl-l)
      write(nout,fmt) alfa(m),((funn(k,ind(l+i)),k=1,nlgh),i=1,nf)
      l=l+ncl
      m=m+1
      if(m.eq.12) m=2
      if(l.lt.funl) goto 20
c
c
c
      l=0
      j1=1-ncl*nlig
   30 j1=j1+ncl*nlig
      j2=min(j1-1+ncl*nlig,funl)
      write(nout,104) j1,j2
  104 format('      data ((funn(i,j),i=1,nsiz),j=',i3,',',i3,')/')
      m=2
      nef=0
      do 35 jj=1,nlig
      nf=ncl
      if(jj.eq.nlig) nef=nf
      if(funl-l.le.ncl) nf=funl-l
      if(funl-l.le.ncl) nef=nf
c coding
      do 32 i=1,nf
      do 31 k=1,nlgh
      name(k:k)=funn(k,ind(l+i))
   31 continue
      call cvname(fn(1+(i-1)*nsiz),name,0)
   32 continue
c ecriture
      goto (321,322,323,324) nef
      write(nout,105) alfa(m),(fn(k),k=1,nf*nsiz)
       goto 33
  321 write(nout,1051) alfa(m),(fn(k),k=1,nf*nsiz)
      goto 33
  322 write(nout,1052) alfa(m),(fn(k),k=1,nf*nsiz)
      goto 33
  323 write(nout,1053) alfa(m),(fn(k),k=1,nf*nsiz)
       goto 33
  324 write(nout,1054) alfa(m),(fn(k),k=1,nf*nsiz)
   33 continue
  105 format(5x,a1,1x,4(2(i9,','),' ')                 )
 1054 format(5x,a1,1x,3(2(i9,','),' '),1(i9,','),i9,'/')
 1053 format(5x,a1,1x,2(2(i9,','),' '),1(i9,','),i9,'/')
 1052 format(5x,a1,1x,1(2(i9,','),' '),1(i9,','),i9,'/')
 1051 format(5x,a1,1x,                 1(i9,','),i9,'/')
      l=l+ncl
      m=m+1
      if(m.eq.12) m=2
      if(l.ge.funl) goto 36
   35 continue
      if(j2.lt.funl) goto 30
c
 36   continue
c      CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
c
c
      l=0
      j1=1-ncl*nlig
  730 j1=j1+ncl*nlig
      j2=min(j1-1+ncl*nlig,funl1)
      write(nout,7104) j1,j2
 7104 format('      data ((funm(i,j),i=1,nsiz),j=',i3,',',i3,')/')
      m=2
      nef=0
      do 735 jj=1,nlig
      nf=ncl
      if(jj.eq.nlig) nef=nf
      if(funl1-l.le.ncl) nf=funl1-l
      if(funl1-l.le.ncl) nef=nf
c
      do 732 i=1,nf
      do 731 k=1,nlgh
c      name(k:k)=funm(k,ind(l+i))
      name(k:k)=funm(k,i+l)
  731 continue
c      write(6,*) name
      call cvname(fn(1+(i-1)*nsiz),name,0)
  732 continue
c ecriture
      goto (7321,7322,7323,7324) nef
      write(nout,105) alfa(m),(fn(k),k=1,nf*nsiz)
       goto 733
 7321 write(nout,1051) alfa(m),(fn(k),k=1,nf*nsiz)
      goto 733
 7322 write(nout,1052) alfa(m),(fn(k),k=1,nf*nsiz)
      goto 733
 7323 write(nout,1053) alfa(m),(fn(k),k=1,nf*nsiz)
       goto 733
 7324 write(nout,1054) alfa(m),(fn(k),k=1,nf*nsiz)
  733 continue
      l=l+ncl
      m=m+1
      if(m.eq.12) m=2
      if(l.ge.funl1) goto 360
  735 continue
      if(j2.lt.funl1) goto 730
c      CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
c     data funp
 360  continue
      l=0
      j1=1-ncl*nlig
   40 j1=j1+ncl*nlig
      j2=min(j1-1+ncl*nlig,funl)
c
      write(nout,106) j1,j2
  106 format('      data (funp(j),j=',i3,',',i3,')/')
c
      m=2
      nef=0
      do 45 jj=1,nlig
      nf=ncl
      if(jj.eq.nlig) nef=nf
      if(funl-l.le.ncl) nf=funl-l
      if(funl-l.le.ncl) nef=nf
       goto (401,402,403,404) nef
      write(nout,107) alfa(m),(funp(ind(l+k)),k=1,nf)
      goto 41
  401 write(nout,1071) alfa(m),(funp(ind(l+k)),k=1,nf)
      goto 41
  402 write(nout,1072) alfa(m),(funp(ind(l+k)),k=1,nf)
      goto 41
  403 write(nout,1073) alfa(m),(funp(ind(l+k)),k=1,nf)
      goto 41
  404 write(nout,1074) alfa(m),(funp(ind(l+k)),k=1,nf)
c
  107 format('     ',a1,4(5x,i4,4x,',')          )
 1071 format('     ',a1,                5x,i4,'/')
 1072 format('     ',a1,1(5x,i4,4x,','),5x,i4,'/')
 1073 format('     ',a1,2(5x,i4,4x,','),5x,i4,'/')
 1074 format('     ',a1,3(5x,i4,4x,','),5x,i4,'/')
c
   41 continue
      l=l+ncl
      m=m+1
      if(m.eq.12) m=2
      if(l.ge.funl) goto 50
   45 continue
      if(j2.lt.funl) goto 40
c
   50 continue
c
      write(nout,108) (count(i),i=1,13)
      write(nout,1081) (count(i),i=14,26)
      write(nout,1082) count(27)
  108 format('      data point/',13(i3,','))
 1081 format('     1           ',13(i3,','))
 1082 format('     2           ',i3,'/')
c
c
c
   52 continue
      read(nfuns,'(80a1)') ligne
      if(ligne(1).ne.'c' .or. ligne(2).ne.'+') goto 52
      write(nout,'(''c+'')')
   55 read(nfuns,'(80a1)',end=60) ligne
      ll=81
 56   ll=ll-1
      if(ll.eq.0) goto 55
      if(ligne(ll).eq.' ') goto 56
      write(nout,'(80a1)') (ligne(i),i=1,ll)
      goto 55
c
   60 continue
      stop
c 999  continue
c  110 format(1x,'forbidden character!')
c      stop
      end
C/MEMBR ADD NAME=CVNAME,SSI=0
      subroutine cvname(id,str,job)
c
c converti un nom code scilab en un string
c
c
      include '../routines/stack.h'

      integer id(nsiz),name(nlgh),ch
      character*(*) str
c
      if(job.eq.0) goto 20
      id1=id(1)
      id2=id(2)
      do 10 i=1,nlgh/2
      k=id1/256
      ch=id1-256*k
      id1=k
   10 str(i:i)=alfa(ch+1)
      do 11 i=nlgh/2+1,nlgh
      k=id2/256
      ch=id2-256*k
      id2=k
   11 str(i:i)=alfa(ch+1)
      return
c
   20 continue
      call cvstr(nlgh,name,str,0)
      id(1)=0
      id(2)=0
      do 21 i=1,nlgh/2
      id(1)=256*id(1)+abs(name(nlgh/2+1-i))
      id(2)=256*id(2)+abs(name(nlgh+1-i))
   21 continue
      return
      end
      subroutine cvstr(n,line,str,job)
c!but
c     converti une chaine de caracteres code  en une chaine
c     standard. les eol (99) sont remplaces  par des !
c
c!appel
c     call cvstr(n,line,str,job)
c
c     ou
c
c     n: entier, longueur de la chaine a convertir
c
c     line: vecteur entier, contient le code des caracteres 
c
c     string: caracter, contient des caracteres ASCII
c
c     job: entier, si egal a 1: code-->ascii
c                  si egal a 0: ascii-->code
c
c!
c
      include '../routines/stack.h'
c
      integer line(*)
      character str*(*),mc*1
      integer eol
      data eol/99/
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
      include '../routines/stack.h'
c
      integer k
      character line*(*)
      integer blank
      data blank/40/
c
      if(ichar(line(1:1)).eq.0) then
c     prise en compte de la marque de fin de chaine C
c     dans le cas d'un appel de matlab par un programme C
         k=99
      elseif(ichar(line(1:1)).eq.9) then
c     tab remplace par un blanc
         k=blank+1
      else
      write(6,*) 'unknown scilab character'
         k=0
      endif
c
      end
