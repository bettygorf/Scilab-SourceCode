function [r]=%lssolss(s1,s2)
//%lssolss(s1,s2) test s1==s2
for k=2:7,r=and(s1(k)==s2(k));if ~r then return,end,end



