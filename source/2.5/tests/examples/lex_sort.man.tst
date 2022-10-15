clear;lines(0);
M=round(2*rand(20,3));

lex_sort(M)
lex_sort(M,'unique')
[N,k]=lex_sort(M,[1 3],'unique')

