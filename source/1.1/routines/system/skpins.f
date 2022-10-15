      subroutine skpins(job)
c!but 
c     ce sous programme permet de sauter les instructions suivantes
c     d'une clause j'usqu'a l'un des  mots clef "end" ou
c     "else","elseif","case" de la clause courante
c     si job=1 on recherche le "end"
c     si job=0 on recherche le "end" ou "else","elseif","case" 
c     
c     attention skpins modifie la valeur de lpt en particulier lpt(4)
c     et lpt(6)
c     
      include '../stack.h'
c     
      integer for(nsiz),while(nsiz),iff(nsiz),else(nsiz),ennd(nsiz)
      integer cas(nsiz),sel(nsiz),elsif(nsiz)
      integer clcnt,strcnt,qcount
      integer rparen,right,quote,percen
      integer eol,blank,name,psym
      logical eqid
c
      data rparen/42/,right/55/,quote/53/,percen/56/
      data eol/99/,blank/40/
      data name/1/
      data else/236721422,673720360/
      data ennd/671946510,673720360/, for/672864271,673720360/
      data iff/673713938,673720360/,elsif/236721422,673713938/
      data while/353505568,673720334/
      data cas/236718604,673720360/, sel/236260892,673717516/
c     
      l4=lpt(4)
      
      clcnt = 0
      strcnt=0
 10   continue
      psym=sym
      call getsym
      if(strcnt.eq.0) then
c     
         if (sym .eq. eol) then
c     gestion des clause sur plusieurs lignes
            if(macr.gt.0.and.lin(lpt(4)+1).eq.eol) then
               call error(47)
               return
            endif
c     get the following line
            if(lpt(4).eq.lpt(6))  then
               call getlin(1)
               if(err.gt.0) return
            else
               lpt(4)=lpt(4)+1
               char1=blank
            endif
         else if (sym.eq.quote) then
            if(.not.(psym.le.blank.or.psym.eq.rparen.or.psym.eq.right
     $           .or.psym.eq.percen.or.psym.eq.quote)) strcnt=1
         else if(sym .eq. name) then
            if(eqid(syn,ennd)) then
               if(clcnt.eq.0) goto 20
               clcnt=clcnt-1
            elseif (eqid(syn,for) .or. eqid(syn,while) .or.
     $              eqid(syn,iff) .or. eqid(syn,sel)) then
               clcnt = clcnt+1
            elseif(clcnt.eq.0.and.job.eq.0.and.
     $              (eqid(syn,else).or. 
     $              eqid(syn,cas).or.eqid(syn,elsif))) then
               goto 20
            endif
         endif
c
      else
         if (sym.eq.eol) then
            call error(3)
            return
         elseif (sym.eq.quote) then
            qcount=0
 11         qcount=qcount+1
            if(char1.ne.quote) goto 12
            call getsym
            goto 11
 12         continue
            if(2*int(qcount/2).ne.qcount)  strcnt=0
         endif
      endif
      goto 10
c     
 20   continue
      end
