function [stk,txt,top]=%c2sci()
// Copyright INRIA
txt=[]
m=evstr(op(3));n=evstr(op(4))
top1=top-m*n
if op(2)=='23' then  // row 
  nrc=m
  row=[]
  szr=[];szc=[]
  typ='1'
  for k=1:nrc
    sk=stk(top1+k)
    if sk(5)=='10' then typ='10',end
    szr=[szr sk(3)]
    szc=[szc sk(4)]
    row=[row,sk(1)]
  end
  undef=find(szr=='?')
  void=find(szr=='0')
  szr([undef void])=[]
  if szr==[] then 
    if undef<>[] then
      sr='?'
    else
      sr='0'
    end
  else
    [w,k]=mini(length(szr))
    sr=szr(k)
  end
  if typ<>'10' then
    if find(szc=='?')==[] then
      w=szc(1)
      for k=2:nrc
        w=addf(w,szc(k))
      end
      sc=w
    else
      sc='?'
    end
    
    stk=list('['+strcat(row,',')+']','0',sr,sc,sk(5))
  else
    stk=list('['+strcat(row,'+')+']','0',sr,'1','10')
  end    
elseif op(2)=='27' then // column
  ncc=m
  col=[]
  szr=[];szc=[]
  for l=1:ncc
    sk=stk(top1+l)
    szr=[szr sk(3)]
    szc=[szc sk(4)]
    col=[col,sk(1)]
  end
  undef=find(szc=='?')
  void=find(szc=='0')
  szc([undef void])=[]
  if szc==[] then 
    if undef<>[] then
      sc='?'
    else
      sc='0'
    end
  else
    find(szc=='0')
    [w,k]=mini(length(szc))
    sc=szc(k)
  end
  if find(szr=='?')==[] then
    w=szr(1)
    for k=2:ncc
      w=addf(w,szr(k))
    end
    sr=w
  else
    sr='?'
  end
  stk=list('['+strcat(col,';')+']','0',sr,sc,sk(5))
else
//  nrc=n;ncc=m
  nrc=m;ncc=n
  col=[]
  szr=[];szc=[]
  for l=1:nrc
    row=[]
    for k=1:ncc
      sk=stk(top1+(l-1)*ncc+k);
      szr(l,k)=sk(3);
      szc(l,k)=sk(4);
      row=[row,sk(1)];
    end
    col=[col,strcat(row,',')]
  end
  sr='0'
  for l=1:nrc
    k=find(szr(l,:)<>'?')
    if k==[] then sr='?',break,end
    [w,kk]=mini(length(szr(l,k)))
    sr=addf(sr,szr(l,k(kk)))
  end
  
  sc='0'
  for k=1:ncc
    l=find(szc(:,k)<>'?')
    if l==[] then sc='?',break,end
    [w,ll]=mini(length(szr(l,k)))
    sc=addf(sc,szc(l(ll),k))
  end
  
  stk=list('['+strcat(col,';')+']','0',sr,sc,sk(5))
end
top=top1+1


 



