      subroutine affich(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
      double precision t,x(*),z(*),u(*),rpar(*),out(*)
      integer ipar(*),flag,wid
c     ipar(1) = win_num
c     ipar(2) = 0/1 color flag
c     ipar(3) = fontsize
c     ipar(4) = color
c     ipar(5) = lfmt : format length 
c     ipar(6:5+lfmt) = character codes for format 

c
c     rpar(1)=x
c     rpar(2)=y
c
      common /dbcos/ idb
      integer verb,cur,v
      double precision dv,xx,yy,angle
      character*40 fmt,value
      data cur/0/
      data angle/0.0d0/

c     
      if(idb.eq.1) then
         write(6,'(''Affich t='',e10.3,'' flag='',i1,''window='',i3)') t
     $        ,flag,ipar(1) 
      endif
c     
      if(flag.eq.2) then
c state evolution
         wid=ipar(1)
         call cvstr(ipar(5),ipar(6),fmt,1)
         xx=rpar(1)
         yy=rpar(2)
         call dr1('xget'//char(0),'window'//char(0),verb,cur,na,v,v,v,
     $        dv,dv,dv,dv)
         if(cur.ne.wid) then
            call dr1('xset'//char(0),'window'//char(0),wid,v,v,v,v,v,
     $           dv,dv,dv,dv)
         endif
         call dr1('xset'//char(0),'use color'//char(0),ipar(2),0,0,
     &        0,0,v,dv,dv,dv,dv)
         write(value,fmt) z(1)
         ln=lnblnk(value)
         call dr1('xstring'//char(0),value(1:ln),v,v,v,0,v,v,xx,yy,
     &        angle,dv)
         z(1)=u(1)
         write(value,fmt) z(1)
         ln=lnblnk(value)
         call dr1('xstring'//char(0),value(1:ln),v,v,v,0,v,v,xx,yy,
     &        angle,dv)
      elseif(flag.eq.4) then
c     init
         wid=ipar(1)
         call cvstr(ipar(5),ipar(6),fmt,1)
         xx=rpar(1)
         yy=rpar(2)
         z(1)=0
         call dr1('xget'//char(0),'window'//char(0),verb,cur,na,v,v,v,
     $        dv,dv,dv,dv)
         if(cur.ne.wid) then
            call dr1('xset'//char(0),'window'//char(0),wid,v,v,v,v,v,
     $           dv,dv,dv,dv)
         endif
         call dr1('xset'//char(0),'use color'//char(0),ipar(2),0,0,
     &        0,0,v,dv,dv,dv,dv)
         write(value,fmt) z(1)
         ln=lnblnk(value)
         call dr1('xstring'//char(0),value(1:ln),v,v,v,0,v,v,xx,yy,
     &        angle,dv)
      endif
      end
