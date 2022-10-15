function []=plot_graph(g,orx,ory,w,h)
//This function plot a graph in the Scilab graphic window
//It uses the data of the list defining the graph
[lhs,rhs]=argn(0)
// g
check_graph(g)

n=g('node_number');
ma=g('edge_number');
xnodes=g('node_x');ynodes=g('node_y');
if (xnodes==[]|ynodes==[]) then 
  error('plot_graph: coordinates of nodes needed for plotting');
  return
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
  orx=ah+0.09*enx;w=0.82*enx;
  ory=av+0.05*eny;h=0.9*eny;
else 
  if rhs<>5 then error(39), end
end
xsetech([0,0,1.0,1.0],[orx,ory,orx+w,ory+h]);
isoview(orx,orx+w,ory,ory+h);
nodecolor=nodediam
nodeborder=0*ones(1,n)
nodefontsize=23040.*ones(1,n);
metarc=[xnodes-ray;-ynodes+ray;nodecolor;nodediam;nodeborder;nodefontsize];
xset('use color',1);
ncolor=g('node_color')
if ncolor=[] then ncolor=0*ones(1,n);end;
xarcs(metarc,ncolor-1);vtail=g('tail');vhead=g('head');
nxx=0*ones(2,ma);nyy=nxx;
nxx(1,:)=xnodes(vtail);
nxx(2,:)=xnodes(vhead);
nyy(1,:)=-ynodes(vtail);
nyy(2,:)=-ynodes(vhead);
txx=0*ones(2,ma);tyy=txx;
txx(1,:)=xnodes(vtail);
txx(2,:)=xnodes(vhead);
tyy(1,:)=-ynodes(vtail);
tyy(2,:)=-ynodes(vhead);
edgecolor=g('edge_color');if edgecolor==[] then edgecolor=ones(1,ma);end;
ii=find(edgecolor==0);edgecolor(ii)=ones(ii);
xpolys(txx,tyy,-edgecolor);
