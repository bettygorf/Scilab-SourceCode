function [y] = log2(x)

// Copyright INRIA
// function [y] = log2(x)
// Log bas 2 of x
//
// Inputs:
//	x		real matrix
// Outputs:
//	y		real matrix y = log_2(x)

y = log(x)./log(2) ;
