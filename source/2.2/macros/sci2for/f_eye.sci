//[stk,nwrk,txt,top]=f_eye(nwrk)
// genere le code fortran relatif a la primitive eye
//!
txt=[]
select rhs
case 0 then
//write(6,'eye');pause
   top=top+1;stk=list('1.0',0,'-1','-1','0')
case 1 then
   s2=stk(top)
   [out,nwrk,txt]=outname(nwrk,'1',s2(4),s2(5))
   txt=[txt;gencall(['dset',mulf(s2(4),s2(5)),'0.0d0',out,'1']);
            gencall(['dset',s2(4),'1.0d0',out,addf(s2(4),'1')]')]
   stk=list(out,'-1',1,s2(4),s2(5))
case 2  then
   s1=stk(top-1)
   s2=stk(top)
   [out,nwrk,txt]=outname(nwrk,'1',s1(1),s2(1))
   txt=[txt;gencall(['dset',mulf(s1(1),s2(1)),'0.0d0',out,'1']);
            gencall(['dset',s1(1),'1.0d0',out,addf(s1(1),'1')])]
   stk=list(out,'-1',1,s1(1),s2(1))
end
//end


