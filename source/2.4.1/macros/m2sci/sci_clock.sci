function [stk,txt,top]=sci_clock()
// Copyright INRIA
txt=[]
stk=list('evstr(''[''+unix_g(''date +""""%Y %m  %d %H %M  %S""""'')+'']'')','0','1','6','1')

