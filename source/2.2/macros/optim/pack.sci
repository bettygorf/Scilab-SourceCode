function [M,sel]=pack(M,blck_szs)
//utility function (for use with semidef)
sel=[]
kk=0
blck_szs=matrix(blck_szs,1,prod(size(blck_szs)))
for ni=blck_szs
 k=kk
 for j=1:ni
   sel=[sel,k+(j:ni)]
   k=k+ni
 end
 kk=kk+ni*ni
end
M=M(sel,:)

