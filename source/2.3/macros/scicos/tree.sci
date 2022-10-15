function [ord,ok]=tree(vec,IN,dep_ut)
//compute blocks execution tree
//This function is not used anymore, it is replaced by ctree.
ok=%t
for j=1:nb+2
  fini=%t
  for i=1:nb
    if vec(i)==j-1 then
      if j==nb+2 then
	message('algebraic loop detected');ok=%f;ord=[];return;
      end
      k=outptr(i):outptr(i+1)-1;
      kk=[];
      for l=k
	ii=IN(cmatp(l));
	if dep_ut(ii,1) then
	 fini=%f;
	 kk=[kk ii];
	end
      end
      vec(kk)=j*ones(kk) ;
    end
  end
  if fini then break;end
end
[k,ord]=sort(-vec);
ord(find(k==1))=[];
tokill=[]
for i=1:prod(size(ord))
  l=ord(i)
  if outptr(l+1)-outptr(l)==0 then tokill=[tokill i];end
end
ord(tokill)=[]




