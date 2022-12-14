 function [X,c]=normopt2(sys)
 // Generated by lmitool on Wed Feb 08 14:55:43 MET 1995
   
   Mbound = 1e3;
   abstol = 1e-10;
   nu = 10;
   maxiters = 100;
   reltol = 1e-10;
   options=[Mbound,abstol,nu,maxiters,reltol];
    
 ///////////DEFINE INITIAL GUESS BELOW
 [A,B,C,D]=abcd(sys)
 X_init=eye(A);Ib=eye(B'*B);Ic=eye(C*C');                          
 /////////// 
  
 XLIST0=list(X_init,c_init)
 XLIST=lmisolver(XLIST0,normopt2_eval,options)
 [X,c]=XLIST(:)
  
  
  
 /////////////////EVALUATION FUNCTION////////////////////////////
  
 function [LME,LMI,OBJ]=normopt2_eval(XLIST)
 [X,c]=XLIST(:)
  
 /////////////////DEFINE LME, LMI and OBJ BELOW
 LME=X'-X                                                          
 LMI=-[A*X+X*A',B,X*C';B',-gama*Ib,D';C*X,D,-gama*Ic]              
 //  LMI=-[A*X*E'+E*X*A',B,E*X*C';B',-gama*Ib,D';C*X*E',D,-gama*Ic]
 OBJ=gama                                                          
                                                                   
                                                                   
