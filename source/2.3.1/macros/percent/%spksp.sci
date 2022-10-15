function r=%spksp(a,b)
//  a.*.b with a and b sparse
[ija,va,mna]=spget(a)
[ijb,vb,mnb]=spget(b)
ia=ija(:,1);ja=ija(:,2)
ib=ijb(:,1);jb=ijb(:,2)

ij=[((ia-ones(ia))*mnb(1)).*.ones(ib)+ones(ia).*.ib,..
    ((ja-ones(ja))*mnb(2)).*.ones(jb)+ones(ia).*.jb]
r=sparse(ij,va.*.vb,mna.*mnb)
