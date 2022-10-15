function [p,q]=c_sort(A,flag)
//Utility function for column sorting
[p,q]=sort(A',"r");
p=p';q=q';

