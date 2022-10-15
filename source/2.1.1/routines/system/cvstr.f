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
