function out=set_palette(name)
// set_palette - define the contents of scicos palettes
//%Syntax
// pal_names=set_palette()
// palette==set_palette(name)
//%Parameters
// pal_name :  Column vector of existing palettes names
// name     :  a character string giving the requested palette name
// palette  :  a list which contains the definition of the blocks of the 
//             palette 
//!
[lhs,rhs]=argn(0)
if rhs<1 then
  pal_names=[
      'Inputs/Outputs';
      'Linear'
      'Non linear'
      'Events'
      'Treshold'
      'Others']
  npredef=size(pal_names,1)
  if exists('user_pal_dir')<>0 then  
    pal_names=[pal_names;user_pal_dir]
  end
  out=pal_names
  return
end
select name
case 'Inputs/Outputs' then
  names=[
      'SCOPE_f',' ';
      'EVENTSCOPE_f',' ';
      'SCOPXY_f',' ';
      'ANIMXY_f',' ';
      'CONST_f',' ';
      'GENSIN_f',' ';
      'GENSQR_f',' ';      
      'TRASH_f',' ';
      'WFILE_f',' ';
      'RFILE_f',' ';
      'RAND_f',' ';
      'SAWTOOTH_f',' ';
      'TIME_f',' ';
      'IN_f',' ';
      'OUT_f',' ';
      'CLKIN_f',' ';
      'CLKOUT_f',' ';
      'CLOCK_f',' ']
case 'Linear' then
     names=[
    'CLSS_f',' ';
    'CLR_f',' ';
    'INTEGRAL_f',' ';
    'DLR_f',' ';
    'DLSS_f',' ';
    'TCLSS_f',' ';
    'SOM_f',' ';
    'GAIN_f',' ';
    'CLINDUMMY_f',' ';
    'DELAY_f',' ';
    'REGISTER_f',' ']
    
case 'Non linear' then
   names=[
    'QUANT_f',' ';
    'SAT_f',' ';  
    'BOUND_f',' ';
    'PROD_f',' ';
    'EXPBLK_f',' ';
    'SINBLK_f',' ';
    'COSBLK_f',' ';
    'INVBLK_f',' ';
    'LOGBLK_f',' ';
    'POWBLK_f',' ';
    'ABSBLK_f',' ';    
    'TANBLK_f',' ';
    'LOOKUP_f',' ']
case 'Events' then
  names=[
      'CLKSOM_f',' ';
      'EVTDLY_f',' ';
      'CLOCK_f',' ';  
      'EVTGEN_f',' ';
      'SELECT_f',' ';
      'TRASH_f',' ';
      'IFTHEL_f',' ';
      'HALT_f',' ';
      'MFCLCK_f',' ';
      'MCLOCK_f',' ']
case 'Treshold' then
  names=[  
      'ZCROSS_f',' ';
      'NEGTOPOS_f',' ';
      'POSTONEG_f',' ';
      'GENERAL_f',' ']
  
case 'Others' then
  names=[
      'SUPER_f',' ';
      'sci_block',' ';
      'scifunc_block',' ';
      'TEXT_f',' ']
else
  k=find(user_pal_dir==name)
  if k==0 then
    names=[]
  else
    names=stripblanks(read(user_pal_dir(k)+'/blocknames',-1,1,'(a)'))
    to_kill=[]
    for k=1:size(names,1)
      if exists(names(k))==0 then to_kill=[to_kill;k],end
    end
    if to_kill<>[] then
      x_message(['Warning functions associated with ';
	  'subsequents blocks are undefined:';names(to_kill)])
      names(to_kill)=[]
    end
    if names<>[] then bl=' ';names=[names,bl(ones(names))],end
  end

end  
palette=list(list([],name))
[mn,nn]=size(names)
for k=1:mn
  if names(k,2)==' ' then
    execstr('palette(k+1)='+names(k,1)+'(''define'')')
  else
    execstr('palette(k+1)='+names(k,1)+'(''define'','+names(k,2)+')')
  end
end
out=palette

