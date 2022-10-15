function [yup,kup] = sortup(x,how) ;

// function [yup,kup] = sortup(x,how) ;
// Reorders the elements of a matrix in the increasing order.
// Inputs:
//	x		Real (or complex) valued matrix
//	how		'*' x is treated as x(:)
//			'r' x is treated column by column
//			'c' x is treated row by row
// Outputs:
//	yup		increasing ordered matrix
//	kup		indices of the re-ordered matrix


[rx,cx] = size(x) ;
if exists('how') == 0
  how = '*' ;
  [ydown,kdown] = sort(x) ;
else exists('how') == 1
  [ydown,kdown] = sort(x,how) ;
end

select how
case '*'
  kup = mtlb_flipud(kdown(:)) ;
  yup = x(kup) ;
  kup = matrix(kup,rx,cx) ;
  yup = matrix(yup,rx,cx) ;
case 'r'
  kup = mtlb_flipud(kdown) ;
  yup = mtlb_flipud(ydown) ;
case 'c'
  kup = mtlb_fliplr(kdown) ;
  yup = mtlb_fliplr(ydown) ;
end
