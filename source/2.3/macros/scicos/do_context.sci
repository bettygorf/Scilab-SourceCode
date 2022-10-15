function [context,ok]=do_context(context)
if context==[] then context=' ',end
rep=dialog([
    'You may enter here scilab instructions to define ';
    'symbolic parameters used in block definitions using';
    'Scilab instructions; comments are not allowed.';
    ' ';
    'These instructions are evaluated once confirmed, i.e.,you';
    'click on OK and every time diagram is loaded. For blocks to';
    'take into account the changes, they must be re-evaluated';
    'by clicking on them and then confirming, or by using Eval,'],context)
if rep==[] then 
  ok=%f
else
  context=rep
  ok=%t
end

