function [solver]=lmitool(lmi_eval,vstruc,vdim)
// LMITOOL: a tool for solving LMI problems.
// input: a macro which defines the LMI's
// ouput: a macro solver which solves your problem
[LHS,RHS]=argn(0);
lmi_driver='nemirov'
if RHS==0 then
   x_message('Welcome to LMITOOL, a help in solving LMI problems...')
   Problems=['1: feasability problem';...
             '2: (generalized) eigenvalue minimization problem']
   pbtype=x_choose(Problems,'Click below to select the problem')

   select pbtype
    case 0
    solver=[];return;
    case 1 
     pbtype='f';
    case 2
     pbtype='e';
   end
  codes=['1: A. Nemirovski''s code';
         '2: B. Lecinq''s code (not yet implemented)';
         '3: L. El Ghaoui''s code (to be implemented)'];
//  driv=x_choose(codes,'Select your LMI solver');
driv=0; 
   select driv
    case 0
    solver=[];lmi_eval=[];lmi_driver='nemirov';
    case 1
    lmi_driver= 'nemirov'
    case 2
    lmi_driver= 'lmi_driver'
    case 3
    lmi_driver= 'lmi_driver'     
   end
end
if RHS==0|RHS==1 then
   choice=x_choose(['On-line definition?';'Read on file?'],...
                    'Definition of the function lmi_eval')
   select choice
   case 0
    return;
   case 1
    lmi_eval=def_lmi(pbtype);
   case 2
    pathname=unix_g('pwd');
    path=x_dialog('Edit Filename of the LMI',...
                  pathname+'/lmi_ex0.sci');
    getf(path);lg=length(path);k=0;
//  path=/directory/lmi_ex0.sci ==> lmi_func=lmi_ex    
         while %T
         k=k+1;
         if part(path,lg-k)=='/' then break;end
         end
      pathend=part(path,lg-k+1:lg-4);
      lmi_func=pathend;lmi_eval=evstr(lmi_func);
   end
end
//         Now lmi_eval is defined
ww=macrovar(lmi_eval);
vlist=strcat(ww(1),',');
inputs=strcat(ww(3),',');
[out,inp,txt]=string(lmi_eval);
vlist=strcat(inp,',');
outputs=strcat(out,',');
//        Feasability problem: LHS of lmi_eval=1
//        Eigenvalue problem:  LHS of lmi_eval=2
nw=length(outputs);
index_commas=[];
for k=1:nw
  if part(outputs,k)==',' then index_commas=[index_commas,k];end
end
nbout=length(index_commas)+1;
select nbout
   case 1 
pbtype='f'
   case 2
pbtype='e'
   else
error('lmi_eval must have 1 or 2 output parameters!')
end
//        Structure and dimension of variables: if not defined 
//         analyze lmi_eval
if RHS=0|RHS=1|RHS==2
[vstruc,vdim]=lmi_ana(lmi_eval);
end
//      Calculation of the solver function
select pbtype
 case 'f'
  solver=def_feas(lmi_driver,lmi_eval,vstruc,vdim)
 case 'e'
  solver=def_eig(lmi_driver,lmi_eval,vstruc,vdim)
 else
  error('Undefined problem?')
end

function [lmi_eval]=def_lmi(pbtype)
// Examples of valid LMI's 
select pbtype
case 'f'
comments=[ 'Defining lmi_eval: lmi evaluation function';
       'lmi_eval is used for solving a feasibility problem';
       'Find X1,X2,... such that:'
       '      Flmi1(X1,X2,..) > 0 ';
       '      Flmi2(X1,X2,..) > 0 ';
       '         ....             ';
       'The function lmi_eval(X1,X2,...) should evaluate';
       'Flmi1, Flmi2 as a function of X1,X2,...';
       'If several LMI''s are to be solved put Flmi1,Flmi2,... in a list';
       'Other parameters do not need to be defined';
       'Here is an example:'
       'Find Q and Y such that:';
       'Flmi1=-(A*Q+Q*A''+B*Y+Y''*B'') > 0';
       'and';
       'Flmi2=[mu2*I Y;Y'' Q] > 0';
       'Q,Y are the (unknown) LMI variables (input parameters of lmi_eval)'; 
       'outputs:';
       'Flmi=list(Flmi1,Flmi2)';
       'Type in your LMI(s) by editing the example text below';
       'Note that lmi_eval must have one output paramater';]

txt=['function [Flmi]= lmi_eval(Q,Y)';
      '[n,n]=size(A);';
      'I=eye(n,n);';
      'Flmi1=-(A*Q+Q*A''+B*Y+Y''*B'');';
      'Flmi2=[mu2*I Y;Y'' Q];';
      'Flmi=list(Flmi1,Flmi2);'];

case 'e'
comments=['Defining lmi_eval used for solving an eigenvalue problem:';
          ' Find X1,X2,... which ';
          ' minimize t such that ';
          ' Almi1(X1,X2,..) > 0 ';
          ' Almi2(X1,X2,..) > 0 ';
          '      ....           ';
          ' t* Almi1(X1,X2,..) > Blmi1(X1,X2,..) ';
          ' t* Almi2(X1,X2,..) > Blmi2(X1,X2,..) ';
          '      ....           ';
          'Function lmi_eval must be as follows:';
          '[Almi,Blmi]=lmi_eval(X1,X2,...)';
       'The function lmi_eval(X1,X2,...) should evaluate';
       'Almi1, Almi2 ,..., Blmi1, Blmi2,... as a function of X1,X2,...';
       'If several LMI''s are to be solved put Almi1,Almi2,... in a list';
       'Other parameters do not need to be defined';
       'Here is an example:'
       'Minimize t such that P>0 exists such that :';
       '[-(A''*P+P*A+C''*C)  P*B; '
       '    B''*P           t*eye]   > 0';
       'P is the (unknown) LMI variable (input parameter of lmi_eval)'; 
       'Note that lmi_eval must have two output paramaters'];
           ]
txt=['function [Almi,Blmi]=lmi_eval(P)';
      'eps=0.00001';
      'Almi=[zeros(A)+eps*eye zeros(A*B); zeros(B''*A) eye(B''*B)]';
      'Blmi=[A''*P+P*A+C''*C -P*B;-B''*P zeros(B''*B)]'];
end

txt=x_dialog(comments,txt);
header=txt(1,:);[lng,un]=size(txt);
deff(part(header,10:length(header)),txt(2:lng,:));

function [vstruc,vdim]=lmi_ana(lmi_eval)
ww=macrovar(lmi_eval);
vlist=strcat(ww(1),',');
inputs=strcat(ww(3),',');
[out,inp,txt]=string(lmi_eval);
vlist=strcat(inp,',');
x_message('Analyzing the input parameters of lmi_eval ');
nv=length(vlist)
index_commas=[]
for k=1:nv
  if part(vlist,k)==',' then index_commas=[index_commas,k],end
end
vnum = length(index_commas)+1;
index_commas = [0 index_commas length(vlist)+1];
vstruc=[];vdim=[];
Selection='Select structure of variable ';
Choices=['full, symmetric matrix';
         'full, symmetric matrix with zero trace';
         'full, rectangular matrix';
         'diagonal matrix';
         'scalar matrix'];
for i = 1:vnum,
  vname = part(vlist,index_commas(i)+1:index_commas(i+1)-1);
  vstruci=x_choose(Choices,Selection+vname);
  vstruc=[vstruc,vstruci]
  // get dimension of each variable
  [ok,vdimi] = getvalue(['Enter dimension of variable '+vname;
                          '(any function of '+inputs+')'],...
                   ['[#row #col]'],list('str',1),'size('+vname+')')
  vdim=[vdim,vdimi];
end

function [solver]=def_feas(lmi_driver,lmi_eval,vstruc,vdim)
// get number of variables

ww=macrovar(lmi_eval);
vlist=strcat(ww(1),',');
inputs=strcat(ww(3),',');
if type(lmi_eval)==13 then
   error('lmi_eval function must not be compiled!');
   return
end
[out,inp,txt]=string(lmi_eval);
vlist=strcat(inp,',');

nv=length(vlist)
index_commas=[]
for k=1:nv
  if part(vlist,k)==',' then index_commas=[index_commas,k],end
end
vnum = length(index_commas)+1;
com='/'+'/'

index_commas = [0 index_commas length(vlist)+1];

txt1=[];
for i = 1:vnum,
  vname = part(vlist,index_commas(i)+1:index_commas(i+1)-1);
  vstruci=vstruc(i);
  txt1 = [txt1;
          'struc'+vname+'='+string(vstruci)]

  // get dimension of each variable
  vdimi = vdim(i);
  txt1 = [txt1;
        'dim'+vname+'=['+vdimi+']'];
end

txt2=['nx=0';];
for i = 1:vnum,  
  vname = part(vlist,index_commas(i)+1:index_commas(i+1)-1);
  vstrucname = 'struc'+vname;
  vdimname = 'dim'+vname;
  txt2 = [txt2;'['+vname+'0'+',nvar'+vname+']'+...
	    '=nbasis('+vdimname+','+vstrucname+',0)';
             vname+'='+vname+'0';
             'nx=nx+'+'nvar'+vname];
end

txt2=[txt2;
      'Almi0=lmi_eval('+vlist+');';
      'mstr=mstruc(Almi0);';
      'bc=mcompress(Almi0)']

txt3=['Ac=[]';];

for i =1:vnum,
  vname = part(vlist,index_commas(i)+1:index_commas(i+1)-1);
  txt3 = [txt3;
         'for i=1:nvar'+vname;
         '  '+vname+'=nbasis(dim'+vname+',struc'+vname+','+'i'+')';
         '  '+'Almi=lmi_eval('+vlist+');';
         '  '+'Ac=[Ac,mcompress(msub(Almi,Almi0))]';
         'end;'
          '  '+vname+'='+vname+'0';];
end

txt4=['Qc=0*Ac;pc=0*bc';'tmin=1;tmax=1';
     'params=[-1,20,1.d-6,1.d-6,1.d-6,5,5];'
      '[xopt,topt,info]='+lmi_driver+...
      '(Ac,bc,Qc,pc,mstr,tmin,list(tmax,zeros(nx,1)),params)';
     'if info(1)<0 then warning(''LMI solver fails'');xopt=[];return;end';
     'Ac=[];Qc=[];'];

// call LMI solver, depending on problem type
txt5 = ['k=0;';]
for i = 1:vnum,
 vname = part(vlist,index_commas(i)+1:index_commas(i+1)-1);
 txt5 = [txt5;
         vname+'=[];';
         'for i=1:'+'nvar'+vname;
         'k=k+1;';
         vname+'='+vname+'+xopt(k)*nbasis(dim'+vname+',struc'+vname+',i)';
         'end']
end

headlmi='['+strcat(out,',')+']='+'lmi_eval('+strcat(inp,',')+')'
[mt,nt]=size(txt)
quote='''';quote=quote(ones(mt,1))
semi=';';semi=semi(ones(mt,1));
txtlmi_eval=['deff('+''''+headlmi+''''+',[';
quote+dblquote(txt)+quote+semi;
'])']

outputs=vlist;
txtsolver=[txtlmi_eval;
           'comp(lmi_eval)';
            txt1;txt2;txt3;txt4;txt5];
deff('['+outputs +']='+'solver'+'('+inputs+')',...
     [txtlmi_eval;'comp(lmi_eval)';txtsolver]);
comp(solver);
comm1=' ';comm2=' ';comm3=' ';comm4=' ';comm5=' ';
n=x_choose(['Yes';'No'],'Do you want to save the solver function ?')
if n==1 then
 pbname = x_dialog('Enter a problem/macro name: ','solvername');
 pathname=unix_g('pwd');
 fname = pathname+'/'+pbname+'.sci';
 fname=x_dialog('Saving solver macro '+pbname+' in file ',fname);
 unix_s('\rm -f '+fname);
 header = 'function ['+outputs+']='+pbname+'('+inputs+')';
 headerlmi_eval='function '+headlmi;
 write(fname,[header;...
       [comm1;txt1;comm2;txt2;comm3;txt3;comm4;txt4;...
        comm5;txt5;
        headerlmi_eval;txt]]);
// tell user what to do:
txtdo = ['    To solve your problem, you need to ';
         '1- load (and compile) the solver function:';
         '   getf('''+fname'+''',''c'')';
         '2- Define '+inputs+' and run the solver function:';
       '  '+'['+outputs+']='+pbname+'('+inputs+')';
       ' ';
       '           Good luck! ';
        'To check the results, use lmi_eval('+outputs+')';];

write(%io(2),txtdo)
end

function txt=dblquote(txt)
//Change simple quote into double quote!
quote=''''
dquote='""'
[m,n]=size(txt)
for l=1:m,
  for k=1:n
   tlk=txt(l,k)
   sz=length(tlk)
   tlk1=emptystr(1)
   for i=1:sz
     if part(tlk,i)==quote then
       tlk1=tlk1+quote+quote
     elseif part(tlk,i)==dquote then
       tlk1=tlk1+dquote+dquote
     else
       tlk1=tlk1+part(tlk,i)
     end
   end
   txt(l,k)=tlk1
  end
end

function [MXi,m] = nbasis(msize,struc,k)
// function [Xk,m] = basis(msize,struc,k)
// Forms a basis of the space of block-diagonal matrices.
// inputs:
// msize      a 2xl integer vector.
// struc	    an integer vector.
// choice    
// outputs:
// Xk where {Xk} forms a basis of a subspace of
//           nxq matrices, where n = sum(msize(1)), q = sum(msize(2)).
//           for each i, i = 1,...,l,
//           if struc(i) = 1, the i-th block of X is that of full, symmetric 
//                         matrices of dimension msize(i,1)xmsize(i,1).

//           if struc = 2, the subspace is that of full, symmetric 
//                         matrices of dimension msize(1)xmsize(1), with
//                          Tr(X) = 0.
//           if struc = 3, the subspace is that of full, rectangular
//                         matrices of dimension msize(1)xmsize(2).
// m         dimension of the subspace. 
// see also: vec2mat, matrix.

// NOTE: this file has yet to be completed to more general structures.

// find size needed
n = msize(1);
q = msize(2);
[r,l] = size(msize);
l = length(struc);

// case of full, symmetric matrices
if struc == 1,
    if k==0 then
    m = n*(n+1)/2;
    MXi=zeros(n,q);
    return
    end
  m = n*(n+1)/2;
  z = zeros(m,1);
  i=k;
    xi = z; xi(i) = 1;
    MXi = vec2mat(xi,1,n);
end

// case of full, symmetric matrices with zero trace
if struc == 2,
     if k==0 then
     m=n*(n+1)/2-1;
     MXi=zeros(n,q);
     return
     end
  m = n*(n+1)/2;
  z = zeros(m,1);
     if k=1 then
        MXi = zeros(n,n); MXi(1,1) = 1;
     return
     end
  i=k;
  MX1 = zeros(n,n); MX1(1,1) = 1;
    xi = z; xi(i) = 1;
    MXi = vec2mat(xi,1,n);
    MXi = MXi-sum(diag(MXi))*MX1;
m = m-1;
end

// case of full, rectangular matrices
if struc == 3,
  if k==0 then
  m=n*q;
  MXi=zeros(n,q);
  return
  end
  m = n*q;
  z = zeros(m,1);
  i=k;
    xi = z; xi(i) = 1;
    MXi = matrix(xi,n,q);
end

//diagonal matrices
if struc == 4,
  if k==0 then
  m=n;
  MXi=zeros(n,q);
  return
  end
  m=n;
  MXi = zeros(n,q);
    MXi(k,k) = 1;
end

//scalar matrices
if struc == 5,;
  if k==0 then
  m=1;
  MXi=zeros(n,q);
  return
  end
  m=1;
  MXi = eye(n,q);
end


function m=mstruc(list_lmis)
if typeof(list_lmis)='usual' then
 [m,m]=size(list_lmis);
 return;
end
if typeof(list_lmis)='list' then
 m=[];
  for lmi=list_lmis
  [mk,mk]=size(lmi);
  m=[m,mk];
  end
end

function w=mcompress(list_lmis)
if typeof(list_lmis)='usual' then
 w=compress(list_lmis);
 return;
end
if typeof(list_lmis)='list' then
 w=[];
  for lmi=list_lmis
  w=[w,compress(lmi)];
  end
end

function lmisd=msub(lmis1,lmis2)
if typeof(lmis1)='usual' then
 lmisd=lmis1-lmis2;
 return;
end
if typeof(lmis1)='list' then
 k=length(lmis1);
 lmisd=list();
  for i=1:k
  lmisd(i)=lmis1(i)-lmis2(i);
  end
end

function AA=compress(A)
//For A square and symmetric AA is vector:
// [A(1,1),A(2,1),A(2,2),...,A(q,1),...A(q,q),...]
//!
if norm(A-A','fro')>1.d-5 then
  error('non symmetric matrix')
end
[m,n]=size(A)
AA=[]
for l=1:m,AA=[AA A(l,1:l)],end


function A=uncompress(AA,mod)
//Rebuilds  A square symmetric or antsymmetric from AA
// mode : 's' : symmetric
//        'a' : skew-symmetric
// [A(1,1),A(2,1),A(2,2),...,A(q,1),...A(q,q),...]
//!
nn=prod(size(AA))
m=maxi(real(roots(poly([-2*nn 1 1],'x','c'))))
s=1;if part(mod,1)=='a' then s=-1,end
A=[]
ptr=1
for l=1:m
  A(l,1:l)=AA(ptr:ptr+l-1)
  ptr=ptr+l
end
A=A+s*tril(A,-1)'

function A = vec2mat(x,choice,r)
// function A = vec2mat(x,choice,r)
// VEC2MAT: Matrix representation of a vector.
// inputs:
//	x	vector.
//	choice	integer (default: 0).
//  	r	integer vector such that 
//		n = sum(r*r) = length(x)        if choice = 0,
//		n = sum(r*(r-1)/2) = length(x)	if choice < 0,
//		n = sum(r*(r+1)/2) = length(x)	otherwise.
// output:
//	A	nxn matrix containing x column-wise in 
//		block-diagonal structure (each block being of
//		size ri). If choice > 0, A is symmetric, if 
//		choice < 0, it is skew-symmetric.
// See also:	
//	mat2vec
[nargout,nargin]=argn(0);
l = length(x);
if nargin <= 1, choice = 0; end
if nargin <= 2, 
    if choice == 0,
	r = fix( sqrt(l) );
    elseif choice > 0,
	r = fix( .5*(-1+sqrt(1+8*l)) );
    else
	r = fix( .5*(1+sqrt(1+8*l)) );
    end
end
A = [];
p = length(r);
x = x(:);

// symmetric case
if choice > 0,
rx = r.*(r+ones(r))/2;
for i = 1:p,
    Ai = [];
    index = sum(rx(1:i-1));
    index = 1+index:index+rx(i);
    xi = x(index);
    for j = 1:r(i),
	Ai(1:j,j) = xi(1+j*(j-1)/2:j*(j+1)/2); 
    end
    indi = sum(r(1:i-1));
    indi = 1+indi:indi+r(i);
    A(indi,indi) = Ai;
end
A = triu(A)+triu(A,1)';

// skew-symmetric case
elseif choice < 0,
rx = r.*(r-ones(r))/2;
for i = 1:p,
    Ai = [];
    index = sum(rx(1:i-1));
    index = 1+index:index+rx(i);
    xi = x(index);
    for j = 2:r(i),
	Ai(1:(j-1),j) = xi(1+(j-1)*(j-2)/2:j*(j-1)/2); 
    end
    Ai(r(i),r(i)) = 0;
    indi = sum(r(1:i-1));
    indi = 1+indi:indi+r(i);
    A(indi,indi) = Ai;
end
A = triu(A)-triu(A,1)';

// general case
else
rx = r.*r;
for i = 1:p,
    index = sum(rx(1:i-1));
    index = 1+index:index+rx(i);
    xi = x(index);
    Ai = zeros(r(i));
    Ai(:) = xi;
    A = [A Ai];
end
end	

function [solver]=def_eig(lmi_driver,lmi_eval,vstruc,vdim)
// get number of variables

ww=macrovar(lmi_eval);
vlist=strcat(ww(1),',');
inputs=strcat(ww(3),',');
[out,inp,txt]=string(lmi_eval);
vlist=strcat(inp,',');

nv=length(vlist)
index_commas=[]
for k=1:nv
  if part(vlist,k)==',' then index_commas=[index_commas,k],end
end
vnum = length(index_commas)+1;
com='/'+'/'

index_commas = [0 index_commas length(vlist)+1];

txt1=[];
for i = 1:vnum,
  vname = part(vlist,index_commas(i)+1:index_commas(i+1)-1);
  vstruci=vstruc(i);
  txt1 = [txt1;
          'struc'+vname+'='+string(vstruci)]

  // get dimension of each variable
  vdimi = vdim(i);
  txt1 = [txt1;
        'dim'+vname+'=['+vdimi+']'];
end

txt2=['nx=0';];
for i = 1:vnum,  
  vname = part(vlist,index_commas(i)+1:index_commas(i+1)-1);
  vstrucname = 'struc'+vname;
  vdimname = 'dim'+vname;
  txt2 = [txt2;'['+vname+'0'+',nvar'+vname+']'+...
	    '=nbasis('+vdimname+','+vstrucname+',0)';
             vname+'='+vname+'0';
             'nx=nx+'+'nvar'+vname];
end

txt2=[txt2;
      '[Almi0,Blmi0]=lmi_eval('+vlist+');';
      'mstr=mstruc(Almi0);';
      'bc=mcompress(Almi0);pc=mcompress(Blmi0);']

txt3=['Ac=[];Qc=[]';];

for i =1:vnum,
  vname = part(vlist,index_commas(i)+1:index_commas(i+1)-1);
  txt3 = [txt3;
         'for i=1:nvar'+vname;
         '  '+vname+'=nbasis(dim'+vname+',struc'+vname+','+'i'+')';
         '  '+'[Almi,Blmi]=lmi_eval('+vlist+');';
         '  '+'Ac=[Ac,mcompress(msub(Almi,Almi0))];';
         '  '+'Qc=[Qc,mcompress(msub(Blmi,Blmi0))];';
         'end;'
          '  '+vname+'='+vname+'0';];
end

txt4=['tmin=-1000;tmax=10000';
     'params=[-1,20,1.d-6,1.d-6,1.d-6,5,5];'
      '[xopt,topt,info]='+lmi_driver+...
      '(Ac,bc,Qc,pc,mstr,tmin,list(tmax,zeros(nx,1)),params)';
     'if info(1) < 0 then warning(''LMI solver fails!''), xopt=[];return;end';
     'Ac=[];Qc=[];'];

// call LMI solver, depending on problem type
txt5 = ['k=0;';]
for i = 1:vnum,
 vname = part(vlist,index_commas(i)+1:index_commas(i+1)-1);
 txt5 = [txt5;
         vname+'=[];';
         'for i=1:'+'nvar'+vname;
         'k=k+1;';
         vname+'='+vname+'+xopt(k)*nbasis(dim'+vname+',struc'+vname+',i)';
         'end']
end

headlmi='['+strcat(out,',')+']='+'lmi_eval('+strcat(inp,',')+')'
[mt,nt]=size(txt)
quote='''';quote=quote(ones(mt,1))
semi=';';semi=semi(ones(mt,1));
txtlmi_eval=['deff('+''''+headlmi+''''+',[';
quote+dblquote(txt)+quote+semi;
'])']

outputs=vlist+',topt';
txtsolver=[txtlmi_eval;
           'comp(lmi_eval)';
            txt1;txt2;txt3;txt4;txt5];
deff('['+outputs +']='+'solver'+'('+inputs+')',...
     [txtlmi_eval;'comp(lmi_eval)';txtsolver]);
comp(solver);
comm1=' ';comm2=' ';comm3=' ';comm4=' ';comm5=' ';
n=x_choose(['Yes';'No'],'Do you want to save the solver macro ?')
if n==1 then
 pbname = x_dialog('Enter a problem/macro name: ','solvername');
 pathname=unix_g('pwd');
 fname = pathname+'/'+pbname+'.sci';
 fname=x_dialog('Saving solver macro '+pbname+' in file ',fname);
 unix_s('\rm -f '+fname);
 header = 'function ['+outputs+']='+pbname+'('+inputs+')';
 headerlmi_eval='function '+headlmi;
 write(fname,[header;...
       [comm1;txt1;comm2;txt2;comm3;txt3;comm4;txt4;...
        comm5;txt5;
        headerlmi_eval;txt]]);
// tell user what to do:
txtdo = ['    To solve your problem, you need to ';
         '1- load (and compile) the solver function:';
         '   getf('''+fname'+''',''c'')';
         '2- Define '+inputs+' and run the solver function:';
       '  '+'['+outputs+']='+pbname+'('+inputs+')';
       ' ';
       '           Good luck! ';
        'To check the results, use lmi_eval('+outputs+')';];
write(%io(2),txtdo)
end
