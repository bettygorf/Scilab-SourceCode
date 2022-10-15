function [stk,txt,top]=%j2sci()
// 
//!
// Copyright INRIA

s2=stk(top);s1=stk(top-1);
txt=[]
[s1,te1]=s1(1:2);
[s2,te2]=s2(1:2);
//
if te2=='2' then s2='('+s2+')',end
if te1=='2' then s1='('+s1+')',end
if part(s2,1)=='-' then s2='('+s2+')',end
stk=list(s1+'.^'+s2,'1','?','?','?')
top=top-1


