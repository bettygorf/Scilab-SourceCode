function [state,sim]=modipar(newparameters,state,sim,x,cor)
//store modified parameters in compiled structure state,sim
//newparameters gives modified blocks numbers in original structure x
//cor is the correspondance table from original structure to compiled one

[stptr,rpar,rpptr,ipar,ipptr]=sim([3 7:10])
nb=prod(size(rpptr))-1

for k=newparameters
  if prod(size(k))==1 then //parameter of a simple block
    o=x(k);model=o(3);[statek,dstatek,rpark,ipark]=model(6:9)
    kc=cor(k)
  else //parameter of a super block
    kc=get_tree_elt(cor,k);
    nk=size(k,2)
    //Don't try to understand next line!
    k=[k(1) matrix([3*ones(1,nk-1);8*ones(1,nk-1);k(2:nk)],1,3*(nk-1))]
    o=get_tree_elt(x,k);model=o(3);[statek,dstatek,rpark,ipark]=model(6:9)
  end
  //Change continuuous state
  nek=prod(size(statek))-(stptr(kc+1)-stptr(kc)) 
  st=state(2);
  if nek<>0 then
    st(nek+(stptr(kc+1)-1:stptr(nb+1)-1))=st((stptr(kc+1)-1:stptr(nb+1)-1))
    state(2)=st
  end
  stptr(kc+1:nb+1)=stptr(kc+1:nb+1)+nek
  if statek<>[] then 
    st=state(2);
    st(stptr(kc):stptr(kc+1)-1)=statek,
    state(2)=st
  end
  state(2)=st
  //Change discrete  state
  nek=prod(size(dstatek))-(stptr(nb+kc+1)-stptr(nb+kc)) 
  st=state(2);
  if nek<>0&kc<>nb then
    sel=stptr(nb+kc+1)-1:stptr(2*nb+1)-1
    st(nek+sel)=st(sel)
    state(2)=st
  end

  stptr(nb+kc+1:2*nb+1)=stptr(nb+kc+1:2*nb+1)+nek
  if dstatek<>[] then 
    st=state(2);
    st(stptr(nb+kc):stptr(nb+kc+1)-1)=dstatek,
    state(2)=st
  end
  state(2)=st
  
  
  //Change real parameters
  nek=prod(size(rpark))-(rpptr(kc+1)-rpptr(kc)) 
  if nek<>0&kc<>nb then
    rpar(nek+(rpptr(kc+1)-1:rpptr(nb+1)-1))=rpar((rpptr(kc+1)-1:rpptr(nb+1)-1))
    rpptr(kc+1:nb+1)=rpptr(kc+1:nb+1)+nek
  end
  if rpark<>[] then rpar(rpptr(kc):rpptr(kc+1)-1)=rpark,end


  //Change integer parameters
  nek=prod(size(ipark))-(ipptr(kc+1)-ipptr(kc)) 
  if nek<>0&kc<>nb&(ipptr(kc+1)-ipptr(kc))<>0 then
    ipar(nek+(ipptr(kc+1)-1:ipptr(nb+1)-1))=ipar((ipptr(kc+1)-1:ipptr(nb+1)-1))
    ipptr(kc+1:nb+1)=ipptr(kc+1:nb+1)+nek
  end
   if ipark<>[]&(ipptr(kc+1)-ipptr(kc))<>0 then ipar(ipptr(kc):ipptr(kc+1)-1)=ipark,end
end
sim(3)=stptr;sim(7)=rpar;sim(8)=rpptr;sim(9)=ipar;sim(10)=ipptr
