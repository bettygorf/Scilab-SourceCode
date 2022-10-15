function do_help()
while %t do
  [btn,xc,yc,cwin]=xclick(0);
  pt=[xc,yc]
  if cwin==curwin then
    [nm,pt,btn]=getmenu(datam,pt)
    if nm>0 then
      name=menus(nm)
      break,
    else
      k=getobj(scs_m,[xc;yc])
      if k<>[] then
	o=scs_m(k)
	name=o(5)
	break
      end
    end
  elseif or(windows(find(windows(:,1)<0),2)==cwin) then
    kwin=find(windows(:,2)==cwin)
    pal=palettes(-windows(kwin,1))
    k=getobj(pal,[xc;yc])
    o=pal(k)
    name=o(5)
    nm=0
    break
  end
end
if nm==0 then
  fhelp(name)
//  unix_s('$SCI/bin/scilab -help ""'+name+'"" | $SCI/bin/xless &')
  return
end
select name
case 'Help' then
  mess=[' To get help on an object or menu buttons,';
        ' click first on Help button and then on ';
	' the selected object or menu item.']


case 'Edit..' then
  mess=[' Click on the Edit button to open the Edit menu.']


case 'Simulate..' then
  mess=[' Click on the Simulate.. button to open the';
        ' compilation/execution menu.']


case 'File..' then
  mess=[' Click on the File.. button to open the file '
       ' management menu.']
  
case 'Block..' then
  mess=[' Click on the Block.. button to open the block ';
        ' management menu.']

case 'Pal editor..' then
  mess=[' Click on the Palette.. button to open the palette '
        ' management menu';
	' '
	' In this mode user may create or modify a palette';
	' using blocks coming from other palettes, from a ';
	' loaded diagram or newly defined.'
	' '
	' At loading time scicos available palettes are defined'
	' by the scicos_pal variable (see help on scicos_pal)']
  
case 'View' then
  mess=[' To shift the diagram to left, right, up or down,';
      ' click first on the View button, then on a point in';
      ' the diagram where you want to appear in the middle';
      ' of the graphics window. ']


case 'Exit' then
  mess=[' Click on the Exit button to leave Scicos and';
        ' return to Scilab session. Save your diagram ';
	' or palette before leaving.']


case 'Palettes' then
  mess=[' Click on the Palettes button to open a new palette.']


case 'Move' then
  mess=[' To move a block in  the active editor Scicos window';
        'or in edited palette,'
        ' click first on the Move button, '
	' then click on the selected block,'
	' drag the mouse to the desired new block position '
	' and click again to fix the position.'
	' '
	' The lower left corner of the block is placed';
	' at the selected point.'
	' '
	' To move a segment of a link in the active editor '
        ' Scicos window,click first on the Move button, '
	' then click on the selected segment, '
	' drag the mouse to the desired new segment position '
	' and click again to fix the position.']


case 'Copy' then
  mess=['*To copy a block in the active editor Scicos window';
         ' Click first on the Copy button, then'
	 ' click (with left button) on the to-be-copied block'
	 ' in Scicos windows or in a palette) ,  and'
	 ' finally click where you want the copy';
	 ' to be placed in the active editor Scicos window.';
	 ' '
	 ' The lower left corner of the block is placed';
	 ' at the selected point.';
	 ' ' 
	 '*To copy a region in the active editor Scicos window';
         ' Click first on the Copy button, then'
	 ' click (with right button) on a corner of the desired';
	 ' region (in Scicos windows or in a palette), drag to '
	 ' define the region, click to fix the region  and'
	 ' finally click where you want the copy.' 
	 ' to be placed in the active editor Scicos window.';
	 ' NOTE: If source diagram is big be patient,';
	 ' region selection may take a while.'
	 ' '
	 ' The lower left corner of the block is placed';
	 ' at the selected point.';
	   ]


case 'Align' then
  mess=[' To obtain nice diagrams, you can align ports of';
        ' different blocks, vertically and horizontally.';
	' Click first on the Align button, then on the first';
	' port and finally on the second port.';
	' The block corresponding to the second port is moved.';
	' '
	' A connected block cannot be aligned.']


case 'Link' then
  mess=[' To connect an output port to an input port,';
        ' click first on the Link button, then on the output';
	' port and finally on the input port.';
	' To split a link, click first on the Link button,';
	' then on the link where the split should be placed,';
	' and finally on an input port.'
	' ';
	' Only one link can go from and to a port.';
	' Link color can be changed directly by clicking';
	' on the link.']


case 'Delete' then
  mess=['*To delete a block or a link, click first on the Delete'
        ' button, then on the selected object (with left button).';
	' '
	' If you delete a block all links connected to it';
	' are deleted as well.';
	' '
	'*To delete a blocks in a region, click first on the Delete'
        ' button, then click (with right button) on a corner of the ';
	' desired region, drag to define the region, and click to ';
	' fix the region. All connected links will be destroyed as';
	' well']


case 'Flip' then
    mess=[' To reverse the positions of the (regular) inputs'
	  ' and outputs of a block placed on its sides,';
	  ' click on the Flip button first and then on the';
	  ' selected block. This does not affect the order,';
	  ' nor the position of the input and output event';
	  ' ports which are numbered from left to right.'
	  ' '
	  ' A connected block cannot be flipped.']


case  'Undo' then
  mess=[' Click on the Undo button to undo the last edit operation.']


case 'Replot' then
  mess=[' Click on the Replot button to replot the content of'
        ' the graphics window. Graphics window stores complete';
	' history of the editing session in memory.';
	' '
	' Replot is usefull for ''cleaning'' this memory.']


case 'Back' then
  mess=[' Click on the Back button to go back to the main menu.']


case 'Compile' then
  mess=[' Click on the Compile button to compile the block diagram.';
        ' This button need never be used since compilation is';
	' performed automatically, if necessary, before';
	' the beginning of every simulation (Run button).';
	' '
	' Normally, a new compilation is not needed if only';
	' system parameters and internal states are modified.';
        ' In some cases however these modifications are not';
	' correctly updated and a manual compilation may be';
	' needed before a Restart or a Continue.';
	' Please report if you encounter such a case.']


case 'Run' then
  mess=[' Click on the Run button to start the simulation.';
        ' If the system has already been simulated, a';
	' dialog box appears where you can choose to Continue,'
        ' Restart or End the simulation.'
        ' '
	' You may interrupt the simulation by clicking on the '
	' ""stop"" button, change any of the block parameters'
	' and continue the simulation with the new values.']


case 'Purge' then
   mess=[' Click on the Purge button to get a clean data structure:';
         ' If diagram has been hugely modified many deleted blocks';
	 ' may remain in the data structure. It may be  usefull to';
	 ' suppress then before saving.']


case 'Save' then
   mess=[' Click on the save button to save the block diagram';
         ' in a binary file already selected by a previous';
	 ' click on the Save As button. If you click on this';
	 ' button and you have never clicked on the Save As';
	 ' button, the diagram is saved in the current direcotry';
	 ' as <window_name>.cos where <window_name> is the name';
	 ' of the window appearing on top of the window (usually';
	 ' Untitled or Super Block).']


case 'Save As' then
  mess=[' Click on the Save As button to save the block diagram';
         ' or palette in a binary file. A dialog box allows choosing ';
	 ' the file which must have a .cos extension. The diagram';
	 ' takes the name of the file (without the extension).']


case 'FSave' then
   mess=[' Click on the FSave button to save the current diagram';
         ' or palette in a formatted ascii file. '
	 ' A dialog box allows choosing the file which must have a';
	 ' "".cosf"" extension.';
	 ' '
	 ' Formatted save is slower than regular save but';
	 ' has the advantage that the generated file is';
	 ' system independent (usefull for exchanging data';
	 ' on different computers.']


case 'Newblk' then
   mess=[' Click on the Newblk button to save the Super Block'
         ' as a new Scicos block. A Scilab function is generated'
	 ' and saved in a file <window_name>.sci in a requested';
	 ' directory. <window_name> is the name of the';
	 ' Super Block appearing on top of the window.';
	 ' A dialog allows choosing the directory.']

case 'Load' then
  mess=[' Click on the Load button to load an ascii or binary file';
	' containing a saved block diagram or palette.'
	' A dialog box allows user choosing the file.']
case 'Window' then
 mess=[' In the active editor Scicos window, clicking on the ';
       ' Window button invokes a dialog box that allows you to change ';
       ' window dimensions'];
    
case 'Setup' then
  mess=[' In the main Scicos window, clicking on the Setup button';
        ' invokes a dialog box that allows you to change ';
	' integration parameters: ';
	'   *final integration time';
	'   *absolute and relative error tolerances' ;
	'   *time tolerance (the smallest time interval for which ';
	'         the ode solver is used to update continuous states)';
        '   *deltat : the maximum time increase realized by a single';
	'         call to the ode solver'];

case 'New' then
  mess=[' Clicking on the New button loads an empty diagram in the';
        ' active editor Scicos window. If the previous content of the';
	' window is not saved, it will be lost.']
    
case 'Replace' then	
 mess=[' To replace a block in the active editor Scicos window';
         ' Click first on the Replace button, then'
	 ' click on the replacement block (in'
	 ' Scicos window or in a palette) ,  and'
	 ' finally click on the to-be-replaced block']
     
case 'Eval' then     
 mess=[' All dialogs user answers may be scilab instructions';
       ' they are evaluated immediatly and stored as character strings.'
       ' Click on this button to have them re-evaluated according to'; 
       ' new values of underlying scilab variables. '
       ' '
       ' These underlying scilab variables may be user global variables'
       ' defined before scicos was launch, They may also be defined in'
       ' by the scicos context (see Context button)']

case 'Resize' then     
 mess=[' To change the size of a block , click first on this button,';
       ' click next on the desired block. A dialog appear that allows ';
       ' you to change the width and/or height of the block shape.'];
   
case 'Icon' then     
 mess=[' To change the icon of a block, click first on this button,';
       ' click next on the desired block. A dialog appear that allows ';
       ' you to enter scilab instructions used to draw the icon'] ;
   
   
case 'Color' then     
 mess=[' To change the background color of a block, click first on ';
       ' this button, click next on the desired block. A dialog appear';
       ' that allows you to choose the desired color'];
   
case 'Label' then     
 mess=[' To add a label to block, click first on this button, click next';
       ' on the desired block. A dialog appear that allows you to enter ';
       ' the desired label.';
       ' labels are used to import data from a block in an other one'];
 
 
case 'AddNew' then 
  mess=[' To add a newly defined block to the current palette ';
      ' click first on this button, A dialog box will popup ';
      ' asking for the name of the GUI function associated '
      ' with the block. If this function is not already loaded';
      ' it was search in the current directory. The user may then'
      ' click at the desired position of the block icon in the palette']

case 'Calc' then 
  mess=[' When you click on this button you switch Scilab to ';
      ' the pause mode (see the help on pause).';
      ' In the Scilab main window and you may enter Scilab instructions';
      ' to compute whatever you want.';
      ' to go back to Scicos you need enter the ""return"" or';
      ' ""[...]=return(...)"" Scilab instruction.';
      ' '
      ' If you use ""[...]=return(...)"" Scilab instruction take care';
      ' not to modify Scicos variables such as ""scs_m"",""scs_gc"",';
      ' ""menus"",""datam"",...';
      ' '
      ' If you have modified scicos graphic window you may retore it ';
      ' using the Scicos ""Replot"" menu.']

case 'Context' then
  mess=[' When you click on this button you get a dialogue to';
    ' enter scilab instructions for defining symbolic scicos parameters';
    '  used in block definitions or to do whatever you want';
    ' ';
    ' These instructions will be evaluated each time the diagram ';
    ' is loaded.'
    ' ';
    ' If you  change the value of a symbolic scicos parameters in ';
    ' the contextyou can either click on the block(s) that use this';
    ' variable or on the Eval button to update actual block parameter';
    ' value.']
end
if exists('mess')==0 then
  mess='No help available on this topic. Sorry.';
end
message(mess)












