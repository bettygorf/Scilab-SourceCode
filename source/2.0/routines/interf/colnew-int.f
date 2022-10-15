      subroutine bva(fname)
C     Interface for the colnew program for boundary values problem.
C     the type and consistency checks are omited here they are to be done 
C     at Scilab level.
C     ==============================================================
C      implicit undefined (a-z)
      character*(*) fname
      character*6   efsub,edfsub,egsub,edgsub,eguess
      integer    kfsub,kdfsub,kgsub,kdgsub,kguess,topk
      external   fsub,dfsub,gsub,dgsub,dguess
      integer    mstar,ncomp,io
      double precision aleft,aright
      include '../stack.h'
      integer iadr,lr,iflag,mf,nf,lfixpnt,mtol,ntol,ltol,l
      integer mltol,nltol,lltol,iero,mipar,nipar,lipar,mzeta,nzeta,lzeta
      integer mm,mn,lrm,i,lispace,lspace,lc,ki,kz,kx,lr1,lc1
      integer mres,nres,lres
      integer itfsub,itdfsub,itgsub,itdgsub,itguess,gettype
      logical type,getexternal,getrmat,cremat,getscalar
      common/iercol/iero
C     External names 
      common / colname / efsub,edfsub,egsub,edgsub,eguess
C     External Position in stack and arguments model position in stack
      common / coladr / kfsub,kdfsub,kgsub,kdgsub,kguess,kx,ki,kz
C     Type of externals 
      common / coltyp / itfsub,itdfsub,itgsub,itdgsub,itguess
      common / icolnew/  ncomp,mstar
      iadr(l)=l+l-1
      type=.false.
      topk=top
      kguess=top
      if (.not.getexternal(fname,topk,top,eguess,type)) return
      itguess=gettype(top)
      top=top-1
      kdgsub=top
      if (.not.getexternal(fname,topk,top,edgsub,type)) return
      itdgsub=gettype(top)
      top=top-1
      kgsub=top
      if (.not.getexternal(fname,topk,top,egsub,type)) return
      itgsub=gettype(top)
      top=top-1
      kdfsub=top
      if (.not.getexternal(fname,topk,top,edfsub,type)) return
      itdfsub=gettype(top)
      top=top-1
      kfsub=top
      if (.not.getexternal(fname,topk,top,efsub,type)) return
      itfsub=gettype(top)
      top=top-1
      if (.not.getrmat(fname,topk,top,mf,nf,lfixpnt))  return
      top=top-1
      if (.not.getrmat(fname,topk,top,mtol,ntol,ltol))  return
      top=top-1
      if (.not.getrmat(fname,topk,top,mltol,nltol,lltol))  return
      call entier(mltol*nltol,stk(lltol),istk(iadr(lltol)))
      top=top-1
      if (.not.getrmat(fname,topk,top,mipar,nipar,lipar))  return
      call entier(mipar*nipar,stk(lipar),istk(iadr(lipar)))
      top=top-1
      if (.not.getrmat(fname,topk,top,mzeta,nzeta,lzeta))  return
      top=top-1
      if (.not.getscalar(fname,topk,top,lr))  return
      aright=stk(lr)
      top=top-1
      if (.not.getscalar(fname,topk,top,lr))  return
      aleft=stk(lr)
      top=top-1
      if (.not. getrmat(fname,topk,top,mm,mn,lrm)) return 
      call entier(mm*mn,stk(lrm),istk(iadr(lrm)))
      mstar=0
      do 10 i=1,mm*mn
         mstar=mstar+ istk(iadr(lrm)+i-1)
 10   continue
      top=top-1
      if (.not.getscalar(fname,topk,top,lr))  return
      ncomp=int(stk(lr))
      top=top-1
      if (.not.getrmat(fname,topk,top,mres,nres,lres))  return
      top=topk+1
      if (.not.cremat(fname,top,0,1,istk(iadr(lipar)+6-1),lispace,lc)) 
     $     return
      top=top+1
      if (.not.cremat(fname,top,0,1,istk(iadr(lipar)+5-1),lspace,lc)) 
     $     return
C     Modele des arguments des external x scalaire z vecteur 
      top=top+1
      ki=top
      kx=top
      if (.not.cremat(fname,top,0,1,1,lr,lc)) return
      top=top+1
      kz=top
      if (.not.cremat(fname,top,0,mstar,1,lr,lc)) return
      iero=0
      CALL COLnew (ncomp,istk(iadr(lrm)),aleft,aright,stk(lzeta),
     $     istk(iadr(lipar)),istk(iadr(lltol)), stk(ltol),stk(lfixpnt),
     $     istk(iadr(lispace)), stk(lspace), IFLAG, FSUB, 
     $             DFSUB, GSUB, DGSUB, dguess) 
      if(err.gt.0) return
      if(iero.gt.0) then
         call error(24)
         Return
      endif
      if ( iflag.ne.1) then 
         goto (101,102,103,104) iflag+4
 101     call basout(io,wte,' Colnew : input data error')  
         return 
 102     call basout(io,wte,' Colnew : Iterations do not converge')  
         return
 103     call basout(io,wte,' no. of subintervals exceeds storage')
         return
 104     call basout(io,wte,' Th colocation matrix is singular')
         return
      endif
      top=top+1
      if (.not.cremat(fname,top,0,mstar,mres*nres,lr,lc)) return
         do 20 i=1,mres*nres
            call appsln(stk(lres+i-1),stk(lr+(i-1)*mstar),stk(lspace),
     $           istk(iadr(lispace)))
 20      continue
      top=topk-rhs+1
      if (.not.cremat(fname,top,0,mstar,mres*nres,lr1,lc1)) return
      call dcopy(mstar*mres*nres,stk(lr),1,stk(lr1),1)
      return
      end

