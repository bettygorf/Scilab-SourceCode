function [x,needcompile]=do_delete(x,needcompile)
// do_delete - delete a scicos object
// get first object to delete
while %t
  [n,pt]=getmenu(datam);xc=pt(1);yc=pt(2)
  if n>0 then n=resume(n),end
  //[btn,xc,yc]=xclick()
  K=getobj(x,[xc;yc])
  if K<>[] then break,end
end

DEL=[]
while K<>[] do
  k=K(1);K(1)=[]
  o=x(k)
  if find(DEL==k)==[] then typ=o(1);else typ='Deleted',end
  //typ=o(1)
  DEL=[DEL k]

  if typ=='Link' then
    [ct,from,to]=o(7:9)
    //  free connected ports
    x(from(1))=mark_prt(x(from(1)),from(2),'out',ct(2),0)
    x(to(1))=mark_prt(x(to(1)),to(2),'in',ct(2),0)
    // erase and delete link
    drawobj(o)
    fromblock=x(from(1));
    toblock=x(to(1));
    if fromblock(5)=='SPLIT_f'|fromblock(5)=='CLKSPLIT_f' then
      //user kills a split  output link, 
      //we create a unique link with  the split input and remaining output links
      //and suppress the split block
      connected=get_connected(x,from(1))//get links connected to the split block
      if size(connected,'*')==2 then
	DEL=[DEL  from(1)]       //suppress split block 
	//create a unique link
	o1=x(connected(1));from1=o1(9);
	o2=x(connected(2));
	if from1(1)<>from(1) then [o1,o2]=(o2,o1),connected=connected([2 1]);end
	from1=o1(9);to2=o2(9);ct2=o2(7)
	
	//the links comes from connected(1) block and goes to connected(2) block
	x1=o1(2);y1=o1(3)
	n1=size(x1,1)
	xl=[x1(1:n1-1);o2(2)];
	yl=[y1(1:n1-1);o2(3)];
	o1(2)=[x1(1:n1-1);o2(2)];
	o1(3)=[y1(1:n1-1);o2(3)];
	o1(9)=o2(9);
	DEL=[DEL connected(2)] // supress one link
	x(connected(1))=o1 //change link
	x(to2(1))=mark_prt(x(to2(1)),to2(2),'in',ct2(2),connected(1))
      end
    end
    if toblock(5)=='SPLIT_f'|toblock(5)=='CLKSPLIT_f' then
      //user kills a split input link 
      //ask for split deletion 
      K=[K to(1)]  
    end 
  elseif typ=='Block' then
    // get connected links
    connected=get_connected(x,k)
    //ask for connected links deletion
    K=[K connected] 
    // erase and delete block 
    drawobj(x(k))
  elseif typ=='Text' then
    drawobj(o)
  elseif typ='Deleted' then
  else
    x_message('This object cant be deleted')
  end
end
  
if pixmap then xset('wshow'),end
for k=DEL,x(k)=list('Deleted'),end
nx=size(x)
//suppress rigth-most deleted elements
while %lol(x(nx),list('Deleted')) then x(nx)=null();nx=nx-1;end
needcompile=DEL<>[]
