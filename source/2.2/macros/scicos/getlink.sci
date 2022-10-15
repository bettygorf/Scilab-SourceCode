function [x,needcompile]=getlink(x,needcompile)
//edition of a link from an output block to an input  block
dash=xget('dashes')
//----------- get link origin --------------------------------------
//------------------------------------------------------------------
while %t
  [n,pt]=getmenu(datam);xc1=pt(1);yc1=pt(2)
  if n>0 then n=resume(n),end
  //[btn,xc1,yc1]=xclick()
  [kfrom,wh]=getobj(x,[xc1;yc1])
  if kfrom<>[] then o1=x(kfrom);break,end
end
if o1(1)=='Link' then  // add a split block
  pt=[xc1;yc1]
  [xx,yy,ct,from,to]=o1([2 3 7:9]);
  // get split type
  [xout,yout,typout]=getoutputs(x(from(1)))
  clr=ct(1)
  
  typo=ct(2)
  // get initial split position
  d=projaff(xx(wh:wh+1),yy(wh:wh+1),pt)
  // Note : creation of the split block and modifications of links are
  //        done later, the sequel assumes that the split block is added 
  //        at the end of x
  ks=kfrom;
  kfrom=size(x)+1;port_number=2;
  xo=d(1);yo=d(2)
  fromsplit=%t
else //connection comes from a block
  graphics1=o1(2)
  [orig,sz,io,op,cop]=graphics1([1:3,6,8])
  [xout,yout,typout]=getoutputs(o1)
  if xout==[] then 
    x_message('This block has no output port'),
    xset('dashes',dash)
    return
  end
  [m,kp1]=mini((yc1-yout)^2+(xc1-xout)^2)
  k=kp1
  xo=xout(k);yo=yout(k);typo=typout(k)
  if typo==1 then
    port_number=k
    if op(port_number)<>0 then 
      x_message('selected port is already connected'),
      xset('dashes',dash)
      return
    end
  else
    port_number=k-prod(size(find(typout==1)))
    if cop(port_number)<>0 then 
      x_message('selected port is already connected'),
      xset('dashes',dash)
      return
    end
  end
  fromsplit=%f
  clr=default_color(typo)
end  
from=[kfrom,port_number]
xl=xo
yl=yo

//----------- get link path ----------------------------------------
//------------------------------------------------------------------
xset('dashes',clr)
while %t do //loop on link segments
  xe=xo;ye=yo
  xpoly([xo;xe],[yo;ye],'lines')
  rep(3)=-1
  while rep(3)==-1 do //get a new point
    rep=xgetmouse()
    //erase last link segment
    xpoly([xo;xe],[yo;ye],'lines')
    //plot new position of last link segment
    xe=rep(1);ye=rep(2)
    xpoly([xo;xe],[yo;ye],'lines')
    if pixmap then xset('wshow'),end
  end
  kto=getblock(x,[xe;ye])
  if kto<>[] then //new point designs the "to block"
    o2=x(kto);
    graphics2=o2(2);[orig,sz,ip,cip]=graphics2([1:2 5 7])
    [xin,yin,typin]=getinputs(o2)
    //check connection
    if xin==[] then 
      x_message('This block has no input port'),
      xpoly([xl;xe],[yl;ye],'lines')
      if pixmap then xset('wshow'),end
      xset('dashes',dash)
      return
    end
    [m,kp2]=mini((ye-yin)^2+(xe-xin)^2)
    k=kp2
    xc2=xin(k);yc2=yin(k)
    if typo<>typin(k)
      x_message(['This input port is not compatible with the port at the'
	         'link''s origin';
		 strcat(string([typo,typin(k)]),',')]),
      xpoly([xl;xe],[yl;ye],'lines')
      if pixmap then xset('wshow'),end
      xset('dashes',dash)
      return
    end
    if typo==1 then
      port_number=k
      if ip(port_number)<>0 then 
	x_message('selected port is already connected'),
	xpoly([xl;xe],[yl;ye],'lines')
	if pixmap then xset('wshow'),end
	xset('dashes',dash)
	return
      end
    else
      port_number=k-prod(size(find(typin==1)))
      if cip(port_number)<>0 then 
	x_message('selected port is already connected'),
	xpoly([xl;xe],[yl;ye],'lines')
	if pixmap then xset('wshow'),end
	xset('dashes',dash)
	return
      end
    end
    xpoly([xo;xe],[yo;ye],'lines')
    xpoly([xo;xc2],[yo;yc2],'lines')
    if pixmap then xset('wshow'),end
    break;
  else //new point ends current line segment
    if xe<>xo|ye<>yo then //to avoid null length segments
      xc2=xe;yc2=ye
      xpoly([xo;xc2],[yo;yc2],'lines')
      if abs(xo-xc2)<abs(yo-yc2) then
	xc2=xo
      else
	yc2=yo
      end
      xpoly([xo;xc2],[yo;yc2],'lines')
      if pixmap then xset('wshow'),end
      xl=[xl;xc2]
      yl=[yl;yc2]
      xo=xc2
      yo=yc2
    end
  end
end //loop on link segments

//make last segment horizontal or vertical
typ=typo
to=[kto,port_number]
nx=prod(size(xl))
if nx==1 then //1 segment link
  
  if fromsplit&(xl<>xc2|yl<>yc2) then 
    //try to move split point
    if xx(wh)==xx(wh+1) then //split is on a vertical link
      if (yy(wh)-yc2)*(yy(wh+1)-yc2)<0 then 
	//erase last segment
	xpoly([xl;xc2],[yl;yc2],'lines')
	yl=yc2,
	//draw last segment
	xpoly([xl;xc2],[yl;yc2],'lines')
	if pixmap then xset('wshow'),end
      end
    elseif yy(wh)==yy(wh+1) then //split is on a horizontal link
      if (xx(wh)-xc2)*(xx(wh+1)-xc2)<0 then 
	//erase last segment
	xpoly([xl;xc2],[yl;yc2],'lines')
	xl=xc2,
	//draw last segment
	xpoly([xl;xc2],[yl;yc2],'lines')
	if pixmap then xset('wshow'),end
      end
    end
    d=[xl,yl]
  end
  //form link datas
  xl=[xl;xc2];yl=[yl;yc2]
else
  if xl(nx)==xl(nx-1) then //previous segment is vertical
    //erase last and previous segments
    xpoly([xl(nx-1);xl(nx);xo;xc2],[yl(nx-1);yl(nx);yo;yc2],'lines')
    //draw last 2 segments
    xpoly([xl(nx-1);xl(nx);xc2],[yl(nx-1);yc2;yc2],'lines')
    if pixmap then xset('wshow'),end
    //form link datas
    xl=[xl;xc2];yl=[yl(1:nx-1);yc2;yc2]
  elseif yl(nx)==yl(nx-1) then //previous segment is horizontal
    //erase last and previous segments
    xpoly([xl(nx-1);xl(nx);xo;xc2],[yl(nx-1);yl(nx);yo;yc2],'lines')
    //draw last 2 sgements
    xpoly([xl(nx-1);xc2;xc2],[yl(nx-1);yl(nx);yc2],'lines')
    if pixmap then xset('wshow'),end
    //form link datas
    xl=[xl(1:nx-1);xc2;xc2];yl=[yl;yc2]
  else ///previous segment is oblique 
    //nothing particular is done
    xl=[xl;xc2];yl=[yl;yc2]
  end
end

//----------- update objects structure -----------------------------
//------------------------------------------------------------------
if fromsplit then //link comes from a split
  nx=size(x)+1
  //split old link
  from1=o1(8)
  to1=o1(9)
  link1=o1;
  link1(2)=[xx(1:wh);d(1)];
  link1(3)=[yy(1:wh);d(2)];
  link1(9)=[nx,1]
  link2=o1;
  link2(2)=[d(1);xx(wh+1:size(xx,1))];
  link2(3)=[d(2);yy(wh+1:size(yy,1))];
  link2(8)=[nx,1];

  nx=size(x)+1
  
    // create split block
  if typo==1 then
    model=list('lsplit',1,2,0,0,[],[],[],[],'c',%f,[%t %f])
    graphics1=list(d,[1 1],%t,' ',ks,[nx+1;nx+2],[],[])
    sp=list('Block',graphics1,model,' ','SPLIT_f')
  else
    model=list('lsplit',0,0,1,2,[],[],[],[],'d',[%f,%f],[%t %f])
    graphics1=list(d,[1 1],%t,' ',[],[],[ks],[nx+1;nx+2])
    sp=list('Block',graphics1,model,' ','CLKSPLIT_f')
  end
  
  x(ks)=link1;
  x(nx)=sp
  x(nx+1)=link2;
  x(from1(1))=mark_prt(x(from1(1)),from1(2),'out',typ,ks)
  x(to1(1))=mark_prt(x(to1(1)),to1(2),'in',typ,nx+1)

end
//add new link in objects structure
lk=list('Link',xl,yl,'drawlink',' ',[0 0],[clr,typ],from,to)
nx=size(x)+1
x(size(x)+1)=lk
//update connected blocks
x(kfrom)=mark_prt(x(kfrom),from(2),'out',typ,nx)
x(kto)=mark_prt(x(kto),to(2),'in',typ,nx)


xset('dashes',dash)
needcompile=%t
