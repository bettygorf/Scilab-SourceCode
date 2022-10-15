function [ident,info]=testqp(n,irand,idef,imi,icota,nul,eps,modo)
//Syntax : [ident,info]=testqp(n,irand,idef,imi,icota,nul,eps,modo)
//
//    test problems for quapro and linpro
//
//%inputs
//   n        : dimension of the problem
//   irand    : seed for starting the generation of random numbers.
//              For irand < 0 the seed will not be recovered
//   idef     : it indicates the type of quadratic problem. It may
//              take the following values:
//                  0  : for a linear problem
//                  1  : for an indefinite quadratic problem
//                  2  : for a positive semi-definite quadratic problem
//   imi      : biggest number of equality or inequality constraints
//   icota    : it indicates the type of bound constraints. It may
//              take the values:
//                > 2  : there are only security bounds
//                  2  : there are security bounds for some variables
//                  1  : there is at least one real bound for each
//                       variable
//   nul      : number of null columns of the Hessian
//   eps      : maximum absolute differences for predicting active
//              inequality constraints in macro postqp (standard
//              value=%eps**0.75)
//   modo     : it indicates the way the process begins:
//                  1  : no initial point has been given. The
//                       program computes a feasible initial point
//                       that is a vertex of the region of feasible
//                       points
//                  2  : no initial point has been given. The program
//                       computes a feasible initial point that is not
//                       necesarily a vertex. This value of  MODO is
//                       advisable when the quadratic form is positive
//                       definite and there are a few constraints in
//                       the problem or when there are large bounds
//                       on the variables that are security bounds and
//                       very probably  no actives at the solution
//                  3  : an initial point is given
//
//%outputs
//   ident    : seed for re-starting the generation of random numbers
//              when there are several problems to be tested
//   info     : flag showing return conditions:
//                  0  : normal ending. A local minimum has been found
//                > 0  : abnormal ending
//!
  gigant=1.e3; xci=10; xcs=100; r=gigant/n; t1=r/4;
  imp=1; ident=irand; x0=0;
  if irand > 0 then,..
      rand('seed');..
      rand(ones(1,irand)); ..
  end;
//
// Generation of H
//
  if idef=0 then,..
     h(n,n)=0;..
  else,..
     t=rand; ident=ident+1; s=nul*n/(2*gigant);
     if t < s then,..
        t=rand*nul; mnul=int(t); ident=ident+1;..
     else,..
        mnul=0;..
     end;
     h=rand(ones(n,n));
     h=h+h';
     ident=ident+n**2;
     if mnul <> 0 then,..
        nk=n/mnul;..
     else,..
        nk=0;..
     end;
     i1=nk; i10=nk;
     for j=1:n,..
        if j=i1 then h(:,j)=0; end,..
        i1=i1+nk;..
     end;
     for j=1:n,..
        if j=i10 then h(j,:)=0; end;..
        i10=i10+nk;..
     end;
     if idef=2 then h=h'*h; end;..
  end;
//
// Generation of p
//
  p=rand(n,1); ident=ident+n;
//
// constraints
//
  t=rand*imi; mi=int(t); ident=ident+1;
  t=rand*imi; md=int(t); ident=ident+1;
  mid=mi+md;
  c=rand(n,mid); d=rand(mid,1); ident=ident+mid*(n+1);
//
// bounds
//
  if icota <= 2 then,..
     for i=1:n,..
        t=rand; ident=ident+1;..
        if t <= 0.25d0 then,..
           if icota = 1 then,..
              ci(i)=xci; cs(i)=xcs;..
           else,..
              ci(i)=-gigant; cs(i)=gigant;..
           end;..
        else,..
           if t <= 0.5d0 then,..
              ci(i)=(t-0.375d0)*t1+xci; cs(i)=gigant;..
           else,..
              if t <= 0.75d0 then,..
                 ci(i)=-gigant; cs(i)=(t-0.625d0)*t1+xcs;..
              else,..
                 ci(i)=(t-0.875d0)*t1+xci; cs(i)=ci(i)+rand*r+xcs;..
                 ident=ident+1;..
              end;..
           end;..
        end;..
     end,..
  end;
  if icota > 2 then,..
   cs=gigant*ones(n,1) ; ci=-cs ; ..
  end;
//
//Point initial
//
  if modo=3 then,..
     x1=0; h1=eye(n,n); p1(n)=0; modo1=2; imp1=0;..
     [x0,f,lagr,info]=quapro(x1,h1,p1,c,d,ci,cs,mi,modo1,imp1);..
  end;
//
//
  write(%io(2), '  ************** call linpro/quapro ');
  if idef=0 then,..
     [x,f,lagr,info]=linpro(x0,p,c,d,ci,cs,mi,modo,imp);..
  else,..
     [x,f,lagr,info]=quapro(x0,h,p,c,d,ci,cs,mi,modo,imp);..
  end;
//
  write(%io(2), ' *************** check');
  if info = 0 then,..
     [n1qp,n2qp,n3qp,n4qp,nact]=postqp(x,lagr,h,p,c,d,ci,cs,mi,eps);..
  else,..
     write(%io(2),'INCORRECT END!!!. INFO:');..
     write(%io(2),info,'(10x,f6.0)');..
  end


function [n1qp,n2qp,n3qp,n4qp,nact]=postqp(x,lagr,h,p,c,d,ci,cs,mi,eps)
//Syntax : <n1qp,n2qp,n3qp,n4qp,nact>=postqp(x,lagr,h,p,c,d,ci,cs,mi,eps)
//
//Controle de la programmation quadratique
//
//%parametres d'entree
//   x,lagr : output of quapro
//   h,p,c,d,ci,cs,mi : input of quapro
//   eps      : maximum absolute differences for predicting active
//              inequality constraints (standar value=%eps**0.75)
//
//output
//    n1qp : kuhn-tucker
//    n2qp : error in constraints
//    n3qp : lagrange
//    n4qp : 
//    nact : active constraints
//
//    n1qp n2qp n3qp and n4qp must be small
//!
  n=maxi(size(p));
  slagr=size(lagr); md=slagr(1)-n-mi; nact=mi;
//
//n1qp=
  mid=mi+md;
//
  n1qp=p + h*x + lagr(1:n);
  if mid > 0 then n1qp=n1qp + c*lagr(n+1:n+mid);end;
  n1qp=norm(n1qp)
//
//n2qp=
//
  n2qp=0;
  if mid > 0 then,..
     cxmd=c'*x-d;..
  end;
  if mi>0 then n2qp=norm(cxmd(1:mi),1);end;
  for i=mi+1:mi+md,..
     n2qp=n2qp+maxi(cxmd(i),0);..
  end;
//
  for i=1:n,..
     n2qp=n2qp+maxi(ci(i)-x(i),0)+maxi(0,x(i)-cs(i));..
  end;
//
//  n3qp=
//  n4qp=
//
  n3qp=maxi(abs(lagr));
  n4qp=0;
  for i=1:n,..
     s1=abs(x(i)-ci(i));..
     if s1 < eps then,..
        n3qp=mini(n3qp,-lagr(i));..
        n4qp=n4qp+abs(lagr(i)*(x(i)-ci(i)));..
        nact=nact+1;..
     end,..
     s2=abs(x(i)-cs(i));..
     if s2 < eps then,..
        n3qp=mini(n3qp,lagr(i));..
        n4qp=n4qp+abs(lagr(i)*(x(i)-cs(i)));..
        nact=nact+1;..
     end,..
  end;
//
  if md > 0  then,..
     for i=1:md,..
        if abs(cxmd(mi+i)) < eps then,..
           n3qp=mini(n3qp,lagr(n+mi+i));..
           nact=nact+1;..
        end,..
     end;..
  end;
  if mid > 0 then,..
     n4qp=n4qp+abs(lagr(1+n:n+mid)'*cxmd(1:mid));..
  end;
  write(%io(2),'-NUMBER ACTIVE CONSTRAINTS');
  write(%io(2),nact,'(10x,f3.0)');
  write(%io(2),'-NORM OF  KUHN-TUCKER VECTOR:');
  write(%io(2),n1qp,'(10x,e14.8)');
  write(%io(2),'-ERROR IN CONSTRAINTS:');
  write(%io(2),n2qp,'(10x,e14.8)');
  write(%io(2),'-SMALLEST LAGRANGE MULTIPLIER:');
  write(%io(2),n3qp,'(10x,e14.8)');
  write(%io(2),'-COMPLEMENTARITY: multiplier*(c*x-d):');
  write(%io(2),n4qp,'(10x,e14.8)')




