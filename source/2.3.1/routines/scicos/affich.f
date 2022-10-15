      subroutine affich(flag,nevprt,t,xd,x,nx,z,nz,tvec,ntvec,
     &     rpar,nrpar,ipar,nipar,u,nu,y,ny)
c     Scicos block simulator
c     Displays the value of the input in a graphic window
c
c     ipar(1) = font
c     ipar(2) = fontsize
c     ipar(3) = color
c     ipar(4) = win
c     ipar(5) = nt : total number of output digits
c     ipar(6) = nd number of rationnal part digits

c
c     rpar(1)=x
c     rpar(2)=y
c     rpar(3)=width
c     rpar(4)=height

      double precision t,xd(*),x(*),z(*),tvec(*),rpar(*),u(*),y(*)
      integer flag,nevprt,nx,nz,ntvec,nrpar,ipar(*)
      integer nipar,nu,ny


      integer wid
      common /dbcos/ idb
      integer verb,cur,v,font(5),nf,iflag
      double precision dv,xx,yy,angle,round,ur
      character*40 fmt,value,drv
      data cur/0/,verb/0/
      data angle/0.0d0/
      data iflag/0/

c     
      if(idb.eq.1) then
         write(6,'(''Affich t='',e10.3,'' flag='',i1,''window='',i3)') t
     $        ,flag,ipar(4) 
      endif
c     
      if(flag.eq.2) then
c     state evolution
         ur=10.0d0**ipar(6)
         ur=round(u(1)*ur)/ur
         if (ur.eq.z(1)) return
         wid=ipar(4)
         write(fmt,'(''(f'',i3,''.'',i3,'')'')') ipar(5),ipar(6)
         xx=rpar(1)
         yy=rpar(2)+rpar(4)/4
         call dr1('xget'//char(0),'window'//char(0),verb,cur,na,v,v,v,
     $        dv,dv,dv,dv)
         if(cur.ne.wid) then
            call dr1('xset'//char(0),'window'//char(0),wid,v,v,v,v,v,
     $           dv,dv,dv,dv)
         endif
         call  dr1('xgetdr'//char(0),drv,v,v,v,v,v,v,dv,dv,dv,dv)
         call  dr1('xsetdr'//char(0),'X11'//char(0),v,v,v,v,v,v,dv,dv,dv
     $        ,dv)
         call dr1('xget'//char(0),'font'//char(0),verb,font,nf,v,v,
     $           v,dv,dv,dv,dv)
         call dr1('xset'//char(0),'font'//char(0),ipar(1),ipar(2),v,v,v,
     $           v,dv,dv,dv,dv)
         call  dr1('xclea'//char(0),'v'//char(0),v,v,v,v
     $        ,v,v,rpar(1)+0.06*rpar(3),rpar(2)+rpar(4)*0.94,
     $        rpar(3)*0.88,rpar(4)*0.88)

         z(1)=ur
         value=' '
         write(value,fmt) z(1)
         ln=lnblnk(value)
         value(ln+1:ln+1)=char(0)
         call dr1('xstring'//char(0),value,v,v,v,0,v,v,xx,yy,
     &        angle,dv)
         call dr1('xset'//char(0),'font'//char(0),font(1),font(2),v,v,v,
     $           v,dv,dv,dv,dv)
         call  dr1('xsetdr'//char(0),drv,v,v,v,v,v,v,dv,dv,dv,dv)
      elseif(flag.eq.4) then
c     init
         wid=ipar(4)
         write(fmt,'(''(f'',i3,''.'',i3,'')'')') ipar(5),ipar(6)
         xx=rpar(1)
         yy=rpar(2)
         z(1)=0.0d0
         call dr1('xget'//char(0),'window'//char(0),verb,cur,na,v,v,v,
     $        dv,dv,dv,dv)
         if(cur.ne.wid) then
            call dr1('xset'//char(0),'window'//char(0),wid,v,v,v,v,v,
     $           dv,dv,dv,dv)
         endif
         call  dr1('xgetdr'//char(0),drv,v,v,v,v,v,v,dv,dv,dv,dv)
         call  dr1('xsetdr'//char(0),'X11'//char(0),v,v,v,v,v,v,
     $        dv,dv,dv,dv)
         call  dr1('xclea'//char(0),'v'//char(0),v,v,v,v
     $        ,v,v,xx+0.06*rpar(3),yy+rpar(4)*0.94,rpar(3)*0.88,
     $        rpar(4)*0.88)
         call dr1('xget'//char(0),'font'//char(0),verb,font,nf,v,v,
     $           v,dv,dv,dv,dv)
         call dr1('xset'//char(0),'font'//char(0),ipar(1),ipar(2),v,v,v,
     $           v,dv,dv,dv,dv)
         value=' '
         write(value,fmt) z(1)
         ln=lnblnk(value)
         value(ln+1:ln+1)=char(0)
         yy=rpar(2)+rpar(4)/4
         call dr1('xstring'//char(0),value,v,v,v,0,v,v,xx,yy,
     &        angle,dv)
         call dr1('xset'//char(0),'font'//char(0),font(1),font(2),v,v,v,
     $           v,dv,dv,dv,dv)
         call  dr1('xsetdr'//char(0),drv,v,v,v,v,v,v,dv,dv,dv,dv)
      endif
      end
