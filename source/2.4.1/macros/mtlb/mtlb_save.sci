function mtlb_save(thefile,varargin)
//save variable under  matlab 4.x .mat binary format files
//

[lhs,rhs]=argn(0)
opts=[]
if rhs==1 then
  names=who('get')
  names(1:3)=[] // clear functions variables
  names($-37:$)=[] // clear predefined variables
  funcprot(0)
  for k=size(names,'*'):-1:1
    execstr('x='+names(k))
    select type(x)
    case 1 then
    case 4 then
    case 5 then
    case 6 then
    case 10 then
    else
      names(k)=[]
    end
  end
else
  for k=size(varargin):-1:1
    if part(varargin(k),1)=='-' then 
      opts=[convstr(varargin(k)),opts],
    else
      kk=k
      break
    end
  end
  names=[]
  for k=1:kk
    names=[names, varargin(k)]
  end
end

k=strindex(thefile,'.')
if k==[] then  //no extension given
  if find(opts=='-ascii')==[] then
    thefile=thefile+'.mat'
  end
end


if names==[] then return,end

if opts==[] then //binary save
  [fd,err]=mopen(thefile,'wb',0)
  M=0; //little Endian
  O=0;
  for k=1:size(names,'*')
    // perform changes on variables
    execstr('x='+names(k))
    it=0
    select type(x)
    case 1 then
      P=0
      T=0
      if norm(imag(x),1)<>0 then it=1,end
    case 4 then
      x=bool2s(x)
      P=5
      T=0
    case 5 then
      if norm(imag(x),1)<>0 then it1=1,else it1=0,end
      P=0
      T=2
      [x,v,mn]=spget(x);
      if it1==0 then
	x=[x real(v);[mn 0]]
      else
	x=[x real(v) imag(v);[mn 0 0]]
      end
    case 6 then
      x=bool2s(x)
      P=0
      T=2
      [x,v,mn]=spget(x);
      x=[x v;[mn 0]]
    case 10 then
      x1=part(x(:),1:max(length(x)))
      x=[]
      for l=1:size(x1,1)
	x=[x;ascii(x1(l))]
      end
      P=5
      T=1
    end
    [m,n]=size(x)

    MOPT=[M O P T]
    
    [m,n]=size(x)
    head=[MOPT*[1000;100;10;1] m,n,it,length(names(k))+1]

    head=mput(head,'ull',fd);
    mput([ascii(names(k)) 0],"c",fd);
    select P
    case 0 then
      flag='dl'
    case 1 then
      flag='fl'
    case 2 then
      flag='ll'
    case 3 then
      flag='sl'
    case 4 then
      flag='uls'
    case 5 then
      flag='uc'
    end
    if T==0 then
      if x<>[] then
	mput(real(x(:).'),flag,fd);
	if it==1
	  mput(imag(x(:).'),flag,fd);
	end
      end
    elseif T==1
      v=mput(x(:).',flag,fd);
    elseif T==2 then  //sparse
      mput(x(:).',flag,fd);
    end
  end
  mclose(fd);
else //ascii save

  if convstr(opts(1))<>'-ascii' then 
    error('Uknown or misplaced option '+opts(1))
  end
    if size(opts,'*')==3 then
    sep=str2code(-40)
  else
    sep=' '
  end
  if size(opts,'*')==1 then //8 digits save
    fmt='(1pe14.7'+sep+')'
  else
    fmt='(1pe23.15'+sep+')'
  end

  fd=file('open',thefile,'unknown')
  
  for k=1:size(names,'*')
    // perform changes on variables
    execstr('x='+names(k))
    select type(x)
    case 1 then
      write(fd,real(x),'('+string(size(x,2))+fmt+')')
    case 4 then
      write(fd,bool2s(x),'('+string(size(x,2))+fmt+')')
    case 5 then
      [ij,x]=spget(real(x));x=[ij x];
      write(fd,real(x),'(2f8.0,1x'+string(size(x,2))+fmt+')')
    case 6 then
      [ij,x]=spget(bool2s(x));x=[ij x];
      write(fd,real(x),'(2f8.0,1x'+string(size(x,2))+fmt+')')
    case 10 then
      x=part(x(:),1:max(length(x)))
      x1=[]
      for l=1:size(x,1)
	x1=[x1;ascii(x(l))]
      end
      write(fd,x1,'('+string(size(x1,2))+fmt+')')
    end
  end
  file('close',fd)
end


 

