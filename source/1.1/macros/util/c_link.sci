function [rep]=c_link(name)
// check if 'name' is already linked 
// 
rep=%f;
if type(name)<>10 then 
    error("c_link : name must be a string");
    return
end
tablnk=link();
if prod(size(tablnk))=0 then rep=%f ;return;end
nn=length(tablnk(1))-length(name);
bb=' '; for i=1:(nn-1);bb=bb+ ' ';end
namep=name+bb
tablnk=[tablnk;namep];
nt=prod(size(tablnk));
k=1;while tablnk(k)<>namep then k=k+1,end
if k=nt then rep=%f;else rep=%t;end

