function []=plot_graph2(g,orx,ory,wx,hy)
//This function plot a graph with multiple arcs in the Scilab graphic window
//with the orientation of arcs
//It uses the data of the list defining the graph
[lhs,rhs]=argn(0)
// g
check_graph(g)

n=g('node_number');ma=g('edge_number');
xnodes=g('node_x');ynodes=g('node_y');
if (xnodes==[]|ynodes==[]) then 
  error('plot_graph1: coordinates of nodes needed for plotting');
  return;
end
diam=g('default_node_diam'); if diam==[] then diam=20;end;
nodediam=g('node_diam');if nodediam==[] then nodediam=zeros(1,n);end;
ii=find(nodediam==0);nodediam(ii)=diam*ones(ii);ray=0.5*nodediam;
if rhs==1 then 
  lim=max(nodediam);
  ah=min(xnodes);bh=max(xnodes);
  av=min(-ynodes);bv=max(-ynodes);
  enx=bh-ah;enx=max(enx,5.*lim);
  eny=bv-av;eny=max(eny,5.*lim);
  orx=ah+0.09*enx;wx=0.82*enx;
  ory=av+0.05*eny;hy=0.9*eny;
else 
  if rhs<>5 then error(39), end
end
xsetech([0,0,1.0,1.0],[orx,ory,orx+wx,ory+hy]);
isoview(orx,orx+wx,ory,ory+hy);
nodecolor=nodediam
nodeborder=0*ones(1,n);
nodefontsize=23040.*ones(1,n);
//			DEFINITION OF NODE PLOT
metarcs=[xnodes-ray;-ynodes+ray;nodecolor;nodediam;nodeborder;nodefontsize];
xset("use color",1);
ncolor=g('node_color')
if ncolor=[] then ncolor=0*ones(1,n);end;
vtail=g('tail');vhead=g('head');v=0*ones(1,ma); 
spp=0*ones(n,n);
for i=1:ma
  ii=vtail(i); kk=vhead(i);
  spp(ii,kk)=spp(ii,kk)+1; at=spp(ii,kk)+spp(kk,ii)+0;v(i)=at
end
//			PLOT OF STRAIGHT ARCS
edgecolor=g('edge_color');if edgecolor==[] then edgecolor=1*ones(1,ma);end;
ii=find(edgecolor==0);edgecolor(ii)=1*ones(ii);
for i=1:ma
  if v(i)==1 then
    x1=xnodes(vtail(i));x2=xnodes(vhead(i));
    y1=ynodes(vtail(i));y2=ynodes(vhead(i));
    txx(1,1)=x1;txx(2,1)=x2;
    tyy(1,1)=-y1;tyy(2,1)=-y2;
    xpolys(txx,tyy,-edgecolor(i));
    enorm=sqrt((x2-x1)**2+(y2-y1)**2);
    if enorm < 0.0000001 then enorm=1.;end;
    lsin=(x2-x1)/enorm;lcos=(y2-y1)/enorm;
    x1m=x1+0.5*(x2-x1)-6*lsin;y1m=y1+0.5*(y2-y1)-6*lcos;
    x1mm=x1m-6*lcos;y1mm=y1m+6*lsin;
    x2mm=x1m+6*lcos;y2mm=y1m-6*lsin;
    x3mm=x1m+12*lsin;y3mm=y1m+12*lcos;
    fr(1,1)=x1mm;fr(2,1)=x3mm;fr(3,1)=x2mm;
    gr(1,1)=-y1mm;gr(2,1)=-y3mm;gr(3,1)=-y2mm;
    xpolys(fr,gr,-edgecolor(i));
  end
end;
//			PLOT OF CURVED ARCS WITH ARROWS
for i=1:ma
  if v(i)<>1 then 
    ii=vtail(i); kk=vhead(i);
    x1=xnodes(ii);y1=ynodes(ii);x2=xnodes(kk);y2=ynodes(kk);
    x1p=x1+0.25*(x2-x1);y1p=y1+0.25*(y2-y1);
    x2p=x2-0.25*(x2-x1);y2p=y2-0.25*(y2-y1);
    iv=v(i);ivv=((-1)**iv)*round(iv/2)*sign(kk-ii);epai=10.*ivv;
    enorm=sqrt((x2-x1)**2+(y2-y1)**2);
    if enorm < 0.0000001 then enorm=1.;end;
    lsin=(x2-x1)/enorm;lcos=(y2-y1)/enorm;
    x1m=x1+0.5*(x2-x1)-6*lsin;y1m=y1+0.5*(y2-y1)-6*lcos;
    x1pp=x1p-epai*lcos;y1pp=y1p+epai*lsin;
    x2pp=x2p-epai*lcos;y2pp=y2p+epai*lsin;
    x1m=x1m-epai*lcos;y1m=y1m+epai*lsin;
    x1mm=x1m-6*lcos;y1mm=y1m+6*lsin;
    x2mm=x1m+6*lcos;y2mm=y1m-6*lsin;
    x3mm=x1m+12*lsin;y3mm=y1m+12*lcos;
    fr(1,1)=x1mm;fr(2,1)=x3mm;fr(3,1)=x2mm;
    gr(1,1)=-y1mm;gr(2,1)=-y3mm;gr(3,1)=-y2mm;
    xpolys(fr,gr,-edgecolor(i));
    ar(1,1)=x1;ar(2,1)=x1pp;ar(3,1)=x2pp;ar(4,1)=x2;
    br(1,1)=-y1;br(2,1)=-y1pp;br(3,1)=-y2pp;br(4,1)=-y2;
    xpolys(ar,br,-edgecolor(i));
  end
end
//			PLOT OF LOOPS
gona=diag(spp);ii=find(gona<>0);kk=size(ii);
for i=1:kk(2)
  iii=ii(i); imax=gona(iii);
  x1=xnodes(iii);y1=-ynodes(iii); uni=nodediam(iii);
  jj=find(vtail==iii & vhead==iii);
  for k=1:imax
    xup=x1-0.5*uni; h=(k+0.5)*uni; yup=y1+h; icol=jj(k);
    metarc=[xup,yup,uni,h,0,23040];
    xarcs(metarc',edgecolor(icol)-1);
    x1mm=xup-6;x3mm=xup;x2mm=xup+6;
    y1mm=y1+0.5*h+12;y3mm=y1+0.5*h;y2mm=y1mm;
    fr(1,1)=x1mm;fr(2,1)=x3mm;fr(3,1)=x2mm;
    gr(1,1)=y1mm;gr(2,1)=y3mm;gr(3,1)=y2mm;
    xpolys(fr,gr,-edgecolor(icol));
  end
end

//			PLOT OF SINK NODES
GCD=ncolor;ii=find(GCD==0);GCD(ii)=1*ones(ii);
nodetype=g('node_type');ii=find(nodetype==1);kk=size(ii);
for i=1:kk(2)
  iii=ii(i);
  x1=xnodes(iii);y1=-ynodes(iii);mesu=nodediam(iii);
  xset('pattern',ncolor(iii)-1);
  xrect(x1-0.5*mesu,y1-0.5*mesu,mesu,mesu);
  ar(1,1)=x1-mesu;ar(2,1)=x1+mesu;ar(3,1)=x1;ar(4,1)=ar(1,1);
  br(1,1)=y1-1.5*mesu;br(2,1)=br(1,1);br(3,1)=y1-2.5*mesu;br(4,1)=br(1,1);
  xpolys(ar,br,-GCD(iii));
end
//			PLOT OF SOURCE NODES	
ii=find(nodetype==2);kk=size(ii);
for i=1:kk(2)
  iii=ii(i);
  mesu=nodediam(iii);x1=xnodes(iii);y1=-ynodes(iii)+3*mesu;
  xset('pattern',ncolor(iii)-1);
  xrect(x1-0.5*mesu,y1-0.5*mesu,mesu,mesu);
  ar(1,1)=x1-mesu;ar(2,1)=x1+mesu;ar(3,1)=x1;ar(4,1)=ar(1,1);
  br(1,1)=y1-1.5*mesu;br(2,1)=br(1,1);br(3,1)=y1-2.5*mesu;br(4,1)=br(1,1);
  xpolys(ar,br,-GCD(iii));
end
//			FINAL PLOT OF PLAIN NODES
xarcs(metarcs,ncolor-1);
