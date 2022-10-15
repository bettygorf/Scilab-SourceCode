      program newfun 
c 
c generating new routine funtab.f 
c
      integer fsiz,nsiz,csiz,nlgh,bsiz
      parameter (fsiz=500,nlgh=24)
      parameter (csiz=63,bsiz=4096,isiz=500,psiz=128,nsiz=6,lsiz=4096)
      character*1 ligne(80),funn(nlgh,fsiz),funm(nlgh,fsiz)
      character*(nlgh) name
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
      open(nout,file='funtab.f.new',status='unknown')
c
      ncl=1
      nlig=10
 10   continue
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
 15   funl=funl+1
      read(nfunn,fmt1,end=16) (funn(k,funl),k=1,nlgh),funp(funl),
     $ funt(funl)
      if(funt(funl).eq.1) funl1=funl1+1
      goto 15
      
 16   continue
      funl=funl-1

      l=1
      count(1)=1
      do 18 i=1,26
         nco=0
         do 17 k=1,funl
            if(funn(1,k).ne.alpha(10+i).and.funn(1,k).ne.alphb(10+i))
     1           goto 17
            nco=nco+1
            ind(l)=k
            l=l+1
 17      continue
         count(i+1)=count(i)+nco
 18   continue
c      write(6,*) ind
      if(count(27)-1.ne.funl) then
      write(6,*) 'names must begin with a letter!'
      write(6,*) count(27),funl
      stop
      endif
c
c
      write(nout,'(''      parameter (mxf=nfree+'',i3,'')'')') funl
      write(nout,101) 
  101 format('      integer funl,funl1,funn(nsiz,mxf),funp(mxf)' )
      write(nout,'(''      parameter (funl1='',i3,'')'')') funl1
      write(nout,'(''      integer funm(nsiz,funl1)'')') 
      write(nout,'(''      common /funcs/funl,funn,funp'')')
      write(nout,'(''      data funl/'',i3,''/'')') funl
c
c
      fmt(1:14)='(''c    '',a1,1x,'
      write(fmt(15:),
     $     '(i2,''a1,7x,'',i2,''a1,7x,'',i2,''a1,7x,'',i2,''a1)'')')
     $     nlgh,nlgh,nlgh,nlgh

      m=2
      do 20 l=1,funl
         write(nout,fmt) alfa(m),(funn(k,ind(l)),k=1,nlgh)
         m=m+1
         if(m.eq.12) m=2
 20   continue
c
      l=0
      j1=1-ncl*nlig
 30   j1=j1+ncl*nlig
      j2=min(j1-1+ncl*nlig,funl)
      write(nout,31) j1,j2
 31   format('      data ((funn(i,j),i=1,nsiz),j=',i3,',',i3,')/')
      m=2
      nef=0
      do 36 jj=j1,j2
c     coding
         do 32 k=1,nlgh
            name(k:k)=funn(k,ind(l+1))
 32      continue
         call cvname(fn,name,0)
c     ecriture
         if(jj.lt.j2) then
            write(nout,35) alfa(m),(fn(k),k=1,nsiz),','
         else
            write(nout,35) alfa(m),(fn(k),k=1,nsiz),'/'
         endif
 35      format(5x,a1,1x,(5(i9,',')),i9,a1)
         l=l+ncl
         m=m+1
         if(m.eq.12) m=2
         if(l.ge.funl) goto 37
 36   continue
      if(j2.lt.funl) goto 30
c
 37   continue
c
c      DATA FUNM
c
      funl1=0
      do 39 l=1,funl
         if(funt(ind(l)).eq.1) then
            funl1=funl1+1
            do 38 lll=1,nlgh
               funm(lll,funl1)=funn(lll,ind(l))
 38         continue
         endif
 39   continue
      l=0
      j1=1-ncl*nlig
 40   j1=j1+ncl*nlig
      j2=min(j1-1+ncl*nlig,funl1)
      write(nout,41) j1,j2
 41   format('      data ((funm(i,j),i=1,nsiz),j=',i3,',',i3,')/')
      m=2
      do 48 jj=j1,j2
c     coding
         do 42 k=1,nlgh
            name(k:k)=funm(k,l+1)
 42      continue
         call cvname(fn,name,0)
c     ecriture
         if(jj.lt.j2) then
            write(nout,47) alfa(m),(fn(k),k=1,nsiz),','
         else
            write(nout,47) alfa(m),(fn(k),k=1,nsiz),'/'
         endif
 47      format(5x,a1,1x,5(i9,','),i9,a1)
         l=l+ncl
         m=m+1
         if(m.eq.12) m=2
         if(l.ge.funl1) goto 49
 48   continue
      if(j2.lt.funl1) goto 40
c
 49   continue
c    
c     data funp
c
      l=0
      j1=1-ncl*nlig
c
 50   j1=j1+ncl*nlig
      j2=min(j1-1+ncl*nlig,funl)
c     
      write(nout,51) j1,j2
 51   format('      data (funp(j),j=',i3,',',i3,')/')

      m=2
      nef=0
      do 53 jj=j1,j2
         if(jj.lt.j2) then
            write(nout,52)  alfa(m),funp(ind(l+1)),','
         else
            write(nout,52) alfa(m),funp(ind(l+1)),'/'
         endif
 52      format('     ',a1,5x,i4,4x,a1)
         l=l+ncl
         m=m+1
         if(m.eq.12) m=2
         if(l.ge.funl) goto 54
 53   continue
      if(j2.lt.funl) goto 50
c     
 54   continue
      write(nout,108) (count(i),i=1,13)
      write(nout,1081) (count(i),i=14,26)
      write(nout,1082) count(27)
  108 format('      data point/',13(i3,','))
 1081 format('     1           ',13(i3,','))
 1082 format('     2           ',i3,'/')
c
c
c
 62   continue
      read(nfuns,'(80a1)') ligne
      if(ligne(1).ne.'c' .or. ligne(2).ne.'+') goto 62
      write(nout,'(''c+'')')
 65   read(nfuns,'(80a1)',end=70) ligne
      ll=81
 66   ll=ll-1
      if(ll.eq.0) goto 65
      if(ligne(ll).eq.' ') goto 66
      write(nout,'(80a1)') (ligne(i),i=1,ll)
      goto 65
c     
 70   continue
      stop
c 999  continue
c  110 format(1x,'forbidden character!')
c      stop
      end

      subroutine cvname(id,str,job)
c     =====================================
c     Scilab internal coding of vars to string 
c     =====================================
      include '../stack.h'
      integer id(nsiz),name(nlgh),ch,blank
      character*(*) str
      data blank/40/
c
      if(job.ne.0) then 
         i1=1
         do 15 l=1,nsiz
            idl=id(l)
            do 10 i=1,nlgh/2
               k=(idl+128)/256
               if(k.lt.0) k=k-1
               ch=idl-256*k
               idl=k
               if(ch.gt.0) then
                  str(i:i)=alfa(ch+1)
               else
                  str(i:i)=alfb(-ch+1)
               endif
 10         continue
            i1=i1+4
 15      continue
      else
         ln=len(str)
         call cvstr(min(ln,nlgh),name,str,0)
         if(ln.lt.nlgh) then
            do 16 jj=ln+1,nlgh
               name(jj)=blank
 16         continue
         endif
         i1=1
         do 30 l=1,nsiz
            id(l)=0
            do 20 i=1,4
               ii=i1+4-i
               id(l)=256*id(l)+name(ii)
 20         continue
            i1=i1+4
 30      continue
      endif
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
      include '../stack.h'
      integer eol
c
      integer line(*)
      character str*(*),mc*1
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
      include '../stack.h'
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
