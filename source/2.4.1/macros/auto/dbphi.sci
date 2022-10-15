function [db,phi]=dbphi(repf) 
// Copyright INRIA
phi=phasemag(repf);
 db=20*log(abs(repf))/log(10);
