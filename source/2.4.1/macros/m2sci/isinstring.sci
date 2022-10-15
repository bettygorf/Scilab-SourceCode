function r=isinstring(str,pos)
// Copyright INRIA
str=part(str,1:pos-1)
quote=''''
if strindex(str,quote)==[] then
  r=%f
  return
end

ksym=0  
strcnt=0
qcount=0
bcount=0
pcount=0
sym=' '
while %t ,
  while %t then
    if ksym>=pos then
      r=strcnt<>0
      return
    end
    ksym=ksym+1
    psym=sym
    sym=part(str,ksym);
    if sym<>' ' then break,end
  end
  if  strcnt<>0 then
    if sym==quote then
      qcount=0
      qcount=qcount+1
      while part(str,ksym+1)<>quote&ksym+1<pos then ksym=ksym+1,end
      if 2*int(qcount/2)<>qcount then  strcnt=0,sym=' ',end
    end
    //disp([1 strcnt,qcount,bcount]),halt()
  elseif sym==quote then
    // check if transpose or beginning of a string
    if abs(str2code(psym))>=36&psym<>')'&psym<>']'&psym<>'.'&psym<>quote then
      strcnt=1
    elseif bcount<>0 then
      if part(str,ksym-1)==' ' then strcnt=1,end
    end
    //disp([0 strcnt,qcount,bcount]),halt()
  elseif sym=='[' then
    bcount=bcount+1
  elseif sym==']' then
    bcount=bcount-1
  end
end

