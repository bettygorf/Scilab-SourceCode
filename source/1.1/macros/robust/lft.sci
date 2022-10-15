//[P1,r1]=LFT(P,r,P#,r#)
//[P1,r1]=LFT(P,r,P#,r#)
//Linear fractional transform between two standard plants
//P and P# in state space form or in transfer form.
//r= size(P22) r#=size(P22#);
// LFT(P,r, K) is the linear fractional transform between P and
// a controller K (K may be a gain or a controller in
// state space form or in transfer form);
// LFT(P,K) is LFT(P,r,K) with r=size of K transpose;
//!
//F.D.
if P(1)='lss' then dom=P(7);else dom=P(4);end
[LHS,RHS]=argn(0);
if RHS=2 then
RHS=3;P#=r;
   r=size(P#');
end  //RHS=2
if RHS=3 then
    If type(P)=1 then
          // LFT( Gain, Linear system in ss form)
         [nl,nc]=size(P);
         l1=1:nc-r(1);
         l2=nc-r(1)+1:nc;
         k1=1:nl-r(2);
         k2=nl-r(2)+1:nl;
         D11=P(l1,k1);D12=P(l1,k2);D21=P(l2,k1);D22=P(l2,k2);
        if type(P#)=1 then
          //P# is a gain
    Dk=P#,
    Id=inv(eye(D22*Dk)-D22*Dk),
    Dd=D11+D12*Dk*Id*D21,
    P1=Dd;
                  else
          // P# is not a gain
          if P#(1)='lss' then
    [Ak,Bk,Ck,Dk]=P#(2:5);
    Id=inv(eye(D22*Dk)-D22*Dk),
    Aa= Ak+Bk*Id*D22*Ck,
    Bb=Bk*Id*D21,
    Cc=D12*(Ck+Dk*Id*D22*Ck),
    Dd=D11+D12*Dk*Id*D21,
    P1=syslin(dom,Aa,Bb,Cc,Dd)
                        end
          if P#(1)='r' then
    P1=D11+D12*P#*invr(eye-D22*P#)*D21;
                        end
        end
    end   //type(P)=1
 
    If P(1)='lss' then
          // LFT(Standard in ss form,Linear system in ss form)
    [A,B1,B2,C1,C2,D11,D12,D21,D22]=smga(P,r);
        if type(P#)=1 then
          //P# is a gain
    Dk=P#,
    Id=inv(eye(D22*Dk)-D22*Dk),
    Aa=A+B2*Dk*Id*C2;
    Bb=B1+B2*Dk*Id*D21,
    Cc=C1+D12*Dk*Id*C2,
    Dd=D11+D12*Dk*Id*D21,
    P1=syslin(dom,Aa,Bb,Cc,Dd)
                  else
          // P# is not a gain
    [Ak,Bk,Ck,Dk]=P#(2:5);
    Id=inv(eye(D22*Dk)-D22*Dk),
    Aa=[A+B2*Dk*Id*C2, B2*(Ck+Dk*Id*D22*Ck);
        Bk*Id*C2, Ak+Bk*Id*D22*Ck],
    Bb=[B1+B2*Dk*Id*D21;Bk*Id*D21],
    Cc=[C1+D12*Dk*Id*C2, D12*(Ck+Dk*Id*D22*Ck)],
    Dd=D11+D12*Dk*Id*D21,
    P1=syslin(dom,Aa,Bb,Cc,Dd)
        end
    end
    If P(1)='r' then
          //LFT(Standard plant in tf form,Linear system in tf form)
    [P11,P12,P21,P22]=smga(P,r);
    P1=P11+P12*P#*invr(eye-P22*P#)*P21
    end  //P(1)='lss'
end  //RHS=3
if RHS=4 then
 
   If type(P)=1 then
         //LFT(Gain,standard plant )
         [nl,nc]=size(P);
         l1=1:nc-r(1);
         l2=nc-r(1)+1:nc;
         k1=1:nl-r(2);
         k2=nl-r(2)+1:nl;
         D11=P(l1,k1);D12=P(l1,k2);D21=P(l2,k1);D22=P(l2,k2);
       if type(P#)=1 then
                     //P# is a gain
         [nl,nc]=size(P#);
         l1=1:nc-r#(1);
         l2=nc-r#(1)+1:nc;
         k1=1:nl-r#(2);
         k2=nl-r#(2)+1:nl;
         D11#=P#(l1,k1);D12#=P#(l1,k2);D21#=P#(l2,k1);D22#=P#(l2,k2);
 
    G=inv(eye-D22*D#11);
    G#=inv(eye-D#11*D22);
 
    Dd11=D11+D12*G#*D#11*D21;
    Dd12=D12*G#*D#12;
    Dd21=D#21*G*D21;
    Dd22=D#22+D#21*G*D22*D#12;
 
    P1=[Dd11,Dd12;Dd21,Dd22];
    r1=size(Dd22);
        end
        if P#(1)='lss'
                     //P# in state form
    [A#,B#1,B#2,C#1,C#2,D#11,D#12,D#21,D#22]=smga(P#,r#);
    G=inv(eye-D22*D#11);
    G#=inv(eye-D#11*D22);
 
    Aa=A#+B#1*G*D22*C#1;
 
    Bb1= B#1*G*D21;
    Bb2= B#2+B#1*G*D22*D#12;
 
    Cc1= D12*G#*C#1;
    Cc2= C#2+D#21*G*D22*C#1;
 
    Dd11=D11+D12*G#*D#11*D21;
    Dd12=D12*G#*D#12;
    Dd21=D#21*G*D21;
    Dd22=D#22+D#21*G*D22*D#12;
 
    P1=syslin(dom,Aa,[Bb1,Bb2],[Cc1;Cc2],[Dd11,Dd12;Dd21,Dd22]);
    r1=size(Dd22);
       end
        if P#(1)='r' then
    [J11,J12,J21,J22]=smga(P#,r#);
 
    G=invr(eye-D22*J11);
    G#=invr(eye-J11*D22);
 
    Ptfg11=D11+D12*J11*G*D21;
    Ptfg12=D12*G#*J12;
//Ptfg21=J21*G*P21;
    Ptfg21=J21*(eye+D22*G#*J11)*D21;
    Ptfg22=J22+J21*D22*G#*J12;
 
    P1=[Ptfg11,Ptfg12;Ptfg21,Ptfg22];
    r1=size(Ptfg22)
 
        end
    end  //type(P)=1
 
    If P(1)='lss' then
         //LFT(Standard plant in ss form,standard plant in ss form)
    [A ,B1,B2,C1,C2,D11,D12,D21,D22]=smga(P,r);
 
       if type(P#)=1 then
                     //P# is a gain
         [nl,nc]=size(P#);
         l1=1:nc-r#(1);
         l2=nc-r#(1)+1:nc;
         k1=1:nl-r#(2);
         k2=nl-r#(2)+1:nl;
         D11#=P#(l1,k1);D12#=P#(l1,k2);D21#=P#(l2,k1);D22#=P#(l2,k2);
 
    G=inv(eye-D22*D#11);
    G#=inv(eye-D#11*D22);
 
    Aa=A+B2*G#*D#11*C2;
 
    Bb1=B1+B2*G#*D#11*D21;
    Bb2=B2*G#*D#12;
 
    Cc1=C1+D12*G#*D#11*C2;
    Cc2=D#21*G*C2;
 
    Dd11=D11+D12*G#*D#11*D21;
    Dd12=D12*G#*D#12;
    Dd21=D#21*G*D21;
    Dd22=D#22+D#21*G*D22*D#12;
 
    P1=syslin(dom,Aa,[Bb1,Bb2],[Cc1;Cc2],[Dd11,Dd12;Dd21,Dd22]);
    r1=size(Dd22);
 
                     else
                     //P# in state form
    [A#,B#1,B#2,C#1,C#2,D#11,D#12,D#21,D#22]=smga(P#,r#);
    G=inv(eye-D22*D#11);
    G#=inv(eye-D#11*D22);
 
    Aa=[A+B2*G#*D#11*C2 B2*G#*C#1;
        B#1*G*C2 A#+B#1*G*D22*C#1];
 
    Bb1=[B1+B2*G#*D#11*D21;
          B#1*G*D21];
 
    Bb2=[B2*G#*D#12;
         B#2+B#1*G*D22*D#12];
 
    Cc1=[C1+D12*G#*D#11*C2 D12*G#*C#1];
 
    Cc2=[D#21*G*C2 C#2+D#21*G*D22*C#1];
    Dd11=D11+D12*G#*D#11*D21;
 
    Dd12=D12*G#*D#12;
 
    Dd21=D#21*G*D21;
 
    Dd22=D#22+D#21*G*D22*D#12;
 
    P1=syslin(dom,Aa,[Bb1,Bb2],[Cc1;Cc2],[Dd11,Dd12;Dd21,Dd22]);
    r1=size(Dd22);
       end // type(P#)=1
    end  //P(1)='lss'
 
   If P(1)='r' then
      //LFT(standard plant in tf form,standard plant in tf form)
    [P11,P12,P21,P22]=smga(P,r);
    [J11,J12,J21,J22]=smga(P#,r#);
 
    G=invr(eye-P22*J11);
    G#=invr(eye-J11*P22);
 
    Ptfg11=P11+P12*J11*G*P21;
    Ptfg12=P12*G#*J12;
//Ptfg21=J21*G*P21;
    Ptfg21=J21*(eye+P22*G#*J11)*P21;
    Ptfg22=J22+J21*P22*G#*J12;
 
    P1=[Ptfg11,Ptfg12;Ptfg21,Ptfg22];
    r1=size(Ptfg22)
   end //P(1)='r'
end //RHS=4

