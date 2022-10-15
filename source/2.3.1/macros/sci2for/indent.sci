function [txt]=indent(txt)
//
//!
n=prod(size(txt))
bl(n,1)=' ';
txt=bl+bl+bl+txt



