c SCILAB function : savewave, fin = 1
c     Copyright INRIA
      subroutine intssavewave(fname)
c
       character*(*) fname
       integer topk,rhsk
       logical checkrhs,checklhs,getsmat,checkval,getrvect,cremat
       logical getscalar,bufstore
       include '../stack.h'
c
       integer iadr, sadr
       iadr(l)=l+l-1
       sadr(l)=(l/2)+1
       rhs = max(0,rhs)
c
       lbuf = 1
       topk = top 
       rhsk = rhs 
       if(.not.checkrhs(fname,2,3)) return
       if(.not.checklhs(fname,1,1)) return
c       checking variable file (number 1)
c       
       if(.not.getsmat(fname,top,top-rhs+1,m1,n1,1,1,lr1,nlr1)) return
       if(.not.checkval(fname,m1*n1,1)) return
c       checking variable res (number 2)
c       
       if(.not.getrvect(fname,top,top-rhs+2,m2,n2,lr2)) return
c       checking variable rate (number 3)
c       
       if(rhs .le. 2) then
        top = top+1
        rhs = rhs+1
        if(.not.cremat(fname,top,0,1,1,lr3,lc3)) return
        il3=iadr(lr3)
        istk(il3)= 22050
      else
         if(.not.getscalar(fname,top,top-rhs+3,lr3)) return
         call entier(1,stk(lr3),istk(iadr(lr3)))
         il3=iadr(lr3)
      endif
      if(.not.bufstore(fname,lbuf,lbufi1,lbuff1,lr1,nlr1)) return
      mn2=n2*m2
      call savewave(buf(lbufi1:lbuff1),stk(lr2),istk(iadr(lr3)),mn2,err)
      if(err .gt. 0) then 
         buf = fname // ' Internal Error' 
         call error(999)
         return
      endif
c
      topk=top-rhs
      top=top-rhs+1
      if(.not.cremat(fname,top,0,1,1,lrs,lcs)) return
      call dcopy(1,stk(lr2),1,stk(lrs),1)
      return
      end


c SCILAB function : sox, fin = 2
       subroutine intsloadwave(fname)
c     WARNING : we have used intersci to generate this file 
C     but intssoc was modified by hand to add a working area 
C     
c
       character*(*) fname
       integer topk,rhsk
       logical checkrhs,checklhs,getsmat,checkval,bufstore,cremat
       logical crewmat
       include '../stack.h'
c
       integer iadr, sadr
       iadr(l)=l+l-1
       sadr(l)=(l/2)+1
       rhs = max(0,rhs)
c
       lbuf = 1
       topk = top 
       rhsk = rhs 
       if(.not.checkrhs(fname,1,1)) return
       if(.not.checklhs(fname,1,1)) return
c       checking variable file (number 1)
c       
       if(.not.getsmat(fname,top,top-rhs+1,m1,n1,1,1,lr1,nlr1)) return
       if(.not.checkval(fname,m1*n1,1)) return
c     
c       cross variable size checking
c     
c     
c       cross formal parameter checking
c       not implemented yet
c     
c       cross equal output variable checking
c       not implemented yet
       if(.not.bufstore(fname,lbuf,lbufi1,lbuff1,lr1,nlr1)) return
       if(.not.crewmat(fname,top+1,mm,lw2)) return
       call loadwave(buf(lbufi1:lbuff1),stk(lw2),mm,err)
       if(err .gt. 0) then 
        buf = fname // ' Internal Error' 
        call error(999)
        return
       endif
c     --------------output variable: res
       if(.not.cremat(fname,top,0,1,mm,lrs,lcs)) return
       call dcopy(mm,stk(lw2),1,stk(lrs),1)
       return
       end
c
c SCILAB function : mopen, fin = 3
       subroutine intsmopen(fname)
c
       character*(*) fname
       include '../stack.h'
c
       integer iadr, sadr
       integer topk,rhsk,topl
       logical checkrhs,checklhs,getsmat,checkval,cresmat2,cremat,getsca
     $ lar,bufstore
       iadr(l)=l+l-1
       sadr(l)=(l/2)+1
       rhs = max(0,rhs)
c
       lbuf = 1
       topk = top 
       rhsk = rhs 
       if(.not.checkrhs(fname,1,3)) return
       if(.not.checklhs(fname,1,2)) return
c       checking variable file (number 1)
c       
       if(.not.getsmat(fname,top,top-rhs+1,m1,n1,1,1,lr1,nlr1)) return
       if(.not.checkval(fname,m1*n1,1)) return
c       checking variable status (number 2)
c       
       if(rhs .le. 1) then
        top = top+1
        rhs = rhs+1
        nlr2 = 2
        if(.not.cresmat2(fname,top,nlr2,lr2)) return
        call cvstr(nlr2,istk(lr2),'rb',0)
       endif
       if(.not.getsmat(fname,top,top-rhs+2,m2,n2,1,1,lr2,nlr2)) return
       if(.not.checkval(fname,m2*n2,1)) return
c       checking variable swap (number 3)
c       
       if(rhs .le. 2) then
        top = top+1
        rhs = rhs+1
        if(.not.cremat(fname,top,0,1,1,lr3,lc3)) return
        stk(lr3)= 1
       endif
       if(.not.getscalar(fname,top,top-rhs+3,lr3)) return
c     
c       cross variable size checking
c     
       if(.not.cremat(fname,top+1,0,1,1,lw1,loc1)) return
       if(.not.bufstore(fname,lbuf,lbufi2,lbuff2,lr1,nlr1)) return
       if(.not.bufstore(fname,lbuf,lbufi3,lbuff3,lr2,nlr2)) return
       call entier(1,stk(lr3),istk(iadr(lr3)))
       if(.not.cremat(fname,top+2,0,1,1,lw5,loc5)) return
       call mopen(stk(lw1),buf(lbufi2:lbuff2),buf(lbufi3:lbuff3),istk(ia
     $ dr(lr3)),stk(lw5),err)
       if(err .gt. 0) then 
        buf = fname // ' Internal Error' 
        call error(999)
        return
       endif
c
       topk=top-rhs
       topl=top+2
c     
       if(lhs .ge. 1) then
c       --------------output variable: fd
        top=topl+1
        if(.not.cremat(fname,top,0,1,1,lrs,lcs)) return
        call int2db(1*1,istk(iadr(lw1)),-1,stk(lrs),-1)
       endif
c     
       if(lhs .ge. 2) then
c       --------------output variable: res
        top=topl+2
        if(.not.cremat(fname,top,0,1,1,lrs,lcs)) return
        call dcopy(1*1,stk(lw5),1,stk(lrs),1)
       endif
c     Putting in order the stack
       if(lhs .ge. 1) then
        call copyobj(fname,topl+1,topk+1)
       endif
       if(lhs .ge. 2) then
        call copyobj(fname,topl+2,topk+2)
       endif
       top=topk+lhs
       return
       end

c
c SCILAB function : mputstr, fin = 4
       subroutine intsmputstr(fname)
c
       character*(*) fname
       integer topk,rhsk,topl
       logical checkrhs,checklhs,getsmat,checkval,cremat,getscalar,bufst
     $ ore
       include '../stack.h'
c
       integer iadr, sadr
       iadr(l)=l+l-1
       sadr(l)=(l/2)+1
       rhs = max(0,rhs)
c
       lbuf = 1
       topk = top 
       rhsk = rhs 
       if(.not.checkrhs(fname,1,2)) return
       if(.not.checklhs(fname,1,1)) return
c       checking variable str (number 1)
c       
       if(.not.getsmat(fname,top,top-rhs+1,m1,n1,1,1,lr1,nlr1)) return
       if(.not.checkval(fname,m1*n1,1)) return
c       checking variable fd (number 2)
c       
       if(rhs .le. 1) then
        top = top+1
        rhs = rhs+1
        if(.not.cremat(fname,top,0,1,1,lr2,lc2)) return
        stk(lr2)= -1
       endif
       if(.not.getscalar(fname,top,top-rhs+2,lr2)) return
c     
c       cross variable size checking
c     
       call entier(1,stk(lr2),istk(iadr(lr2)))
       if(.not.bufstore(fname,lbuf,lbufi2,lbuff2,lr1,nlr1)) return
       if(.not.cremat(fname,top+1,0,1,1,lw3,loc3)) return
       call mputstr(istk(iadr(lr2)),buf(lbufi2:lbuff2),stk(lw3),err)
       if(err .gt. 0) then 
        buf = fname // ' Internal Error' 
        call error(999)
        return
       endif
c
       topk=top-rhs
       topl=top+1
c     
       if(lhs .ge. 1) then
c       --------------output variable: res
        top=topl+1
        if(.not.cremat(fname,top,0,1,1,lrs,lcs)) return
        call dcopy(1*1,stk(lw3),1,stk(lrs),1)
       endif
c     Putting in order the stack
       if(lhs .ge. 1) then
        call copyobj(fname,topl+1,topk+1)
       endif
       top=topk+lhs
       return
       end
c
c SCILAB function : mclose, fin = 5
       subroutine intsmclose(fname)
c
       character*(*) fname
       integer topk,rhsk,topl
       logical checkrhs,checklhs,cremat,getscalar
       include '../stack.h'
c
       integer iadr, sadr
       iadr(l)=l+l-1
       sadr(l)=(l/2)+1
       rhs = max(0,rhs)
c
       topk = top 
       rhsk = rhs 
       if(.not.checkrhs(fname,0,1)) return
       if(.not.checklhs(fname,1,1)) return
c       checking variable fd (number 1)
c       
       if(rhs .le. 0) then
        top = top+1
        rhs = rhs+1
        if(.not.cremat(fname,top,0,1,1,lr1,lc1)) return
        stk(lr1)= -1
       endif
       if(.not.getscalar(fname,top,top-rhs+1,lr1)) return
c     
c       cross variable size checking
c     
       call entier(1,stk(lr1),istk(iadr(lr1)))
       if(.not.cremat(fname,top+1,0,1,1,lw2,loc2)) return
       call mclose(istk(iadr(lr1)),stk(lw2))
       if(err .gt. 0) then 
        buf = fname // ' Internal Error' 
        call error(999)
        return
       endif
c
       topk=top-rhs
       topl=top+1
c     
       if(lhs .ge. 1) then
c       --------------output variable: res
        top=topl+1
        if(.not.cremat(fname,top,0,1,1,lrs,lcs)) return
        call dcopy(1*1,stk(lw2),1,stk(lrs),1)
       endif
c     Putting in order the stack
       if(lhs .ge. 1) then
        call copyobj(fname,topl+1,topk+1)
       endif
       top=topk+lhs
       return
       end
c
c SCILAB function : mput, fin = 6
       subroutine intsmput(fname)
c
       character*(*) fname
       integer topk,rhsk,topl
       logical checkrhs,checklhs,getvectrow,cresmat2,getsmat,checkval,cr
     $ emat,getscalar,bufstore
       include '../stack.h'
c
       integer iadr, sadr
       iadr(l)=l+l-1
       sadr(l)=(l/2)+1
       rhs = max(0,rhs)
c
       lbuf = 1
       topk = top 
       rhsk = rhs 
       if(.not.checkrhs(fname,1,3)) return
       if(.not.checklhs(fname,1,1)) return
c       checking variable res (number 1)
c       
       if(.not.getvectrow(fname,top,top-rhs+1,it1,m1,n1,lr1,lc1)) return
c       checking variable type (number 2)
c       
       if(rhs .le. 1) then
        top = top+1
        rhs = rhs+1
        nlr2 = 1
        if(.not.cresmat2(fname,top,nlr2,lr2)) return
        call cvstr(nlr2,istk(lr2),'l',0)
       endif
       if(.not.getsmat(fname,top,top-rhs+2,m2,n2,1,1,lr2,nlr2)) return
       if(.not.checkval(fname,m2*n2,1)) return
c       checking variable fd (number 3)
c       
       if(rhs .le. 2) then
        top = top+1
        rhs = rhs+1
        if(.not.cremat(fname,top,0,1,1,lr3,lc3)) return
        stk(lr3)= -1
       endif
       if(.not.getscalar(fname,top,top-rhs+3,lr3)) return
c     
c       cross variable size checking
c     
       call entier(1,stk(lr3),istk(iadr(lr3)))
       if(.not.bufstore(fname,lbuf,lbufi4,lbuff4,lr2,nlr2)) return
       call mput(istk(iadr(lr3)),stk(lr1),n1,buf(lbufi4:lbuff4),err)
       if(err .gt. 0) then 
        buf = fname // ' Internal Error' 
        call error(999)
        return
       endif
c
       topk=top-rhs
       topl=top+0
c     
       if(lhs .ge. 1) then
c       --------------output variable: res
        top=topl+1
        if(.not.cremat(fname,top,0,1,n1,lrs,lcs)) return
        call dcopy(n1*m1,stk(lr1),1,stk(lrs),1)
       endif
c     Putting in order the stack
       if(lhs .ge. 1) then
        call copyobj(fname,topl+1,topk+1)
       endif
       top=topk+lhs
       return
       end
c
c SCILAB function : mget, fin = 7
       subroutine intsmget(fname)
c
       character*(*) fname
       integer topk,rhsk,topl
       logical checkrhs,checklhs,cremat,getscalar,cresmat2,getsmat,check
     $ val,bufstore
       include '../stack.h'
c
       integer iadr, sadr
       iadr(l)=l+l-1
       sadr(l)=(l/2)+1
       rhs = max(0,rhs)
c
       lbuf = 1
       topk = top 
       rhsk = rhs 
       if(.not.checkrhs(fname,0,3)) return
       if(.not.checklhs(fname,1,1)) return
c       checking variable n (number 1)
c       
       if(rhs .le. 0) then
        top = top+1
        rhs = rhs+1
        if(.not.cremat(fname,top,0,1,1,lr1,lc1)) return
        stk(lr1)= 1
       endif
       if(.not.getscalar(fname,top,top-rhs+1,lr1)) return
c       checking variable type (number 2)
c       
       if(rhs .le. 1) then
        top = top+1
        rhs = rhs+1
        nlr2 = 1
        if(.not.cresmat2(fname,top,nlr2,lr2)) return
        call cvstr(nlr2,istk(lr2),'l',0)
       endif
       if(.not.getsmat(fname,top,top-rhs+2,m2,n2,1,1,lr2,nlr2)) return
       if(.not.checkval(fname,m2*n2,1)) return
c       checking variable fd (number 3)
c       
       if(rhs .le. 2) then
        top = top+1
        rhs = rhs+1
        if(.not.cremat(fname,top,0,1,1,lr3,lc3)) return
        stk(lr3)= -1
       endif
       if(.not.getscalar(fname,top,top-rhs+3,lr3)) return
c     
c       cross variable size checking
c     
       call entier(1,stk(lr3),istk(iadr(lr3)))
       nn2= int(stk(lr1))
       if(.not.cremat(fname,top+1,0,nn2,1,lw2,loc2)) return
       call entier(1,stk(lr1),istk(iadr(lr1)))
       if(.not.bufstore(fname,lbuf,lbufi4,lbuff4,lr2,nlr2)) return
       call mget(istk(iadr(lr3)),stk(lw2),istk(iadr(lr1)),buf(lbufi4:lbu
     $ ff4),err)
       if(err .gt. 0) then 
        buf = fname // ' Internal Error' 
        call error(999)
        return
       endif
c
       topk=top-rhs
       topl=top+1
c     
       if(lhs .ge. 1) then
c       --------------output variable: res
        top=topl+1
        if(.not.cremat(fname,top,0,1,istk(iadr(lr1)),lrs,lcs)) return
        call dcopy(1*istk(iadr(lr1)),stk(lw2),1,stk(lrs),1)
       endif
c     Putting in order the stack
       if(lhs .ge. 1) then
        call copyobj(fname,topl+1,topk+1)
       endif
       top=topk+lhs
       return
       end
c
c SCILAB function : mgetstr, fin = 8
       subroutine intsmgetstr(fname)
c
       character*(*) fname
       integer topk,rhsk,topl
       logical checkrhs,checklhs,cremat,getscalar,crepointer,crestring
       include '../stack.h'
c
       integer iadr, sadr
       iadr(l)=l+l-1
       sadr(l)=(l/2)+1
       rhs = max(0,rhs)
c
       topk = top 
       rhsk = rhs 
       if(.not.checkrhs(fname,0,2)) return
       if(.not.checklhs(fname,1,1)) return
c       checking variable n (number 1)
c       
       if(rhs .le. 0) then
        top = top+1
        rhs = rhs+1
        if(.not.cremat(fname,top,0,1,1,lr1,lc1)) return
        stk(lr1)= 1
       endif
       if(.not.getscalar(fname,top,top-rhs+1,lr1)) return
c       checking variable fd (number 2)
c       
       if(rhs .le. 1) then
        top = top+1
        rhs = rhs+1
        if(.not.cremat(fname,top,0,1,1,lr2,lc2)) return
        stk(lr2)= -1
       endif
       if(.not.getscalar(fname,top,top-rhs+2,lr2)) return
c     
c       cross variable size checking
c     
       call entier(1,stk(lr2),istk(iadr(lr2)))
       if(.not.crepointer(fname,top+1,lw2)) return
       call entier(1,stk(lr1),istk(iadr(lr1)))
       call mgetstr(istk(iadr(lr2)),stk(lw2),istk(iadr(lr1)),err)
       if(err .gt. 0) then 
        buf = fname // ' Internal Error' 
        call error(999)
        return
       endif
c
       topk=top-rhs
       topl=top+1
c     
       if(lhs .ge. 1) then
c       --------------output variable: res
        top=topl+1
        if(.not.crestring(fname,top,istk(iadr(lr1)),ilrs)) return
        call ccharf(istk(iadr(lr1)),stk(lw2),istk(ilrs))
       endif
c     Putting in order the stack
       if(lhs .ge. 1) then
        call copyobj(fname,topl+1,topk+1)
       endif
       top=topk+lhs
       return
       end
c
c SCILAB function : meof, fin = 9
       subroutine intsmeof(fname)
c
       character*(*) fname
       integer topk,rhsk,topl
       logical checkrhs,checklhs,cremat,getscalar
       include '../stack.h'
c
       integer iadr, sadr
       iadr(l)=l+l-1
       sadr(l)=(l/2)+1
       rhs = max(0,rhs)
c
       topk = top 
       rhsk = rhs 
       if(.not.checkrhs(fname,0,1)) return
       if(.not.checklhs(fname,1,1)) return
c       checking variable fd (number 1)
c       
       if(rhs .le. 0) then
        top = top+1
        rhs = rhs+1
        if(.not.cremat(fname,top,0,1,1,lr1,lc1)) return
        stk(lr1)= -1
       endif
       if(.not.getscalar(fname,top,top-rhs+1,lr1)) return
c     
c       cross variable size checking
c     
       call entier(1,stk(lr1),istk(iadr(lr1)))
       if(.not.cremat(fname,top+1,0,1,1,lw2,loc2)) return
       call meof(istk(iadr(lr1)),stk(lw2))
       if(err .gt. 0) then 
        buf = fname // ' Internal Error' 
        call error(999)
        return
       endif
c
       topk=top-rhs
       topl=top+1
c     
       if(lhs .ge. 1) then
c       --------------output variable: res
        top=topl+1
        if(.not.cremat(fname,top,0,1,1,lrs,lcs)) return
        call dcopy(1*1,stk(lw2),1,stk(lrs),1)
       endif
c     Putting in order the stack
       if(lhs .ge. 1) then
        call copyobj(fname,topl+1,topk+1)
       endif
       top=topk+lhs
       return
       end
c

c
c SCILAB function : mseek, fin = 10
       subroutine intsmseek(fname)
c
       character*(*) fname
       include '../stack.h'
c
       integer iadr, sadr
       integer topk,rhsk,topl
       logical checkrhs,checklhs,getscalar,cremat,cresmat2,getsmat,check
     $ val,bufstore
       iadr(l)=l+l-1
       sadr(l)=(l/2)+1
       rhs = max(0,rhs)
c
       lbuf = 1
       topk = top 
       rhsk = rhs 
       if(.not.checkrhs(fname,1,3)) return
       if(.not.checklhs(fname,1,1)) return
c       checking variable n (number 1)
c       
       if(.not.getscalar(fname,top,top-rhs+1,lr1)) return
c       checking variable fd (number 2)
c       
       if(rhs .le. 1) then
        top = top+1
        rhs = rhs+1
        if(.not.cremat(fname,top,0,1,1,lr2,lc2)) return
        stk(lr2)= -1
       endif
       if(.not.getscalar(fname,top,top-rhs+2,lr2)) return
c       checking variable flag (number 3)
c       
       if(rhs .le. 2) then
        top = top+1
        rhs = rhs+1
        nlr3 = 3
        if(.not.cresmat2(fname,top,nlr3,lr3)) return
        call cvstr(nlr3,istk(lr3),'set',0)
       endif
       if(.not.getsmat(fname,top,top-rhs+3,m3,n3,1,1,lr3,nlr3)) return
       if(.not.checkval(fname,m3*n3,1)) return
c     
c       cross variable size checking
c     
       call entier(1,stk(lr2),istk(iadr(lr2)))
       call entier(1,stk(lr1),istk(iadr(lr1)))
       if(.not.bufstore(fname,lbuf,lbufi3,lbuff3,lr3,nlr3)) return
       call mseek(istk(iadr(lr2)),istk(iadr(lr1)),buf(lbufi3:lbuff3),err
     $ )
       if(err .gt. 0) then 
        buf = fname // ' Internal Error' 
        call error(999)
        return
       endif
c
       topk=top-rhs
       topl=top+0
c       no output variable
       top=topk+1
       call objvide(fname,top)
       return
       end
c
c
c SCILAB function : mtell, fin = 11
       subroutine intsmtell(fname)
c
       character*(*) fname
       include '../stack.h'
c
       integer iadr, sadr
       integer topk,rhsk,topl
       logical checkrhs,checklhs,cremat,getscalar
       iadr(l)=l+l-1
       sadr(l)=(l/2)+1
       rhs = max(0,rhs)
c
       topk = top 
       rhsk = rhs 
       if(.not.checkrhs(fname,0,1)) return
       if(.not.checklhs(fname,1,1)) return
c       checking variable fd (number 1)
c       
       if(rhs .le. 0) then
        top = top+1
        rhs = rhs+1
        if(.not.cremat(fname,top,0,1,1,lr1,lc1)) return
        stk(lr1)= -1
       endif
       if(.not.getscalar(fname,top,top-rhs+1,lr1)) return
c     
c       cross variable size checking
c     
       call entier(1,stk(lr1),istk(iadr(lr1)))
       if(.not.cremat(fname,top+1,0,1,1,lw2,loc2)) return
       call mtell(istk(iadr(lr1)),stk(lw2),err)
       if(err .gt. 0) then 
        buf = fname // ' Internal Error' 
        call error(999)
        return
       endif
c
       topk=top-rhs
       topl=top+1
c     
       if(lhs .ge. 1) then
c       --------------output variable: n
        top=topl+1
        if(.not.cremat(fname,top,0,1,1,lrs,lcs)) return
        call int2db(1*1,istk(iadr(lw2)),-1,stk(lrs),-1)
       endif
c     Putting in order the stack
       if(lhs .ge. 1) then
        call copyobj(fname,topl+1,topk+1)
       endif
       top=topk+lhs
       return
       end
c

c  interface function 
c   ********************
       subroutine soundI
       include '../stack.h'
       rhs = max(0,rhs)
c
       goto (1,2,3,4,5,6,7,8,9,10,11) fin
       return
 1     call intssavewave('savewave')
       return
 2     call intsloadwave('loadwave')
       return
 3     call intsmopen('mopen')
       return
 4     call intsmputstr('mputstr')
       return
 5     call intsmclose('mclose')
       return
 6     call intsmput('mput')
       return
 7     call intsmget('mget')
       return
 8     call intsmgetstr('mgetstr')
       return
 9     call intsmeof('meof')
       return
 10    call intsmseek('mseek')
       return
 11    call intsmtell('mtell')
       return
       end






