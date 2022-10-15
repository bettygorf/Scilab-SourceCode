function do_help
  
while %t do
  [btn,xc,yc,cwin]=xclick();
  if cwin==curwin then 
    [nm,pt,btn]=getmenu(datam,pt)
    if nm>0 then 
      name=menus(nm)
      break,
    else
      k=getobj(x,[xc;yc])
      o=x(k)
      name=o(5)
      break
    end
  elseif or(windows(find(windows(:,1)<0),2)==cwin) then
    kwin=find(windows(:,2)==cwin)
    pal=objs(-windows(kwin,1))
    k=getobj(pal,[xc;yc])
    o=pal(k)
    name=o(5)
    nm=0
    break
  end
end
if nm==0 then 
  unix_s('$SCI/bin/scilab -help ""'+name+'"" | $SCI/bin/xless &')
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
  mess=[' Click on the File.. button to open the file management menu.']

case 'View' then 
  mess=[' To shift the diagram to left, right, up or down,';
      ' click first on the View button, then on a point in';
      ' the diagram where you want to appear in the middle';
      ' of the graphics window. ']
  
case 'Exit' then 
  mess=[' Click on the Exit button to leave Scicos and';
        ' return to Scilab session. Save your diagram';
	' before leaving Scicos or it will be lost.']
   
case 'Palettes' then 
  mess=[' Click on the Palettes button to open a new palette.']
   
case 'Move' then 
  mess=[' To move a block in main Scicos window,'
        ' click first on the Move button, then'
	' click on the selected block, drag the'
	' mouse to the desired new block position and'
	' click again to fix the position.'
	' '
	' The lower left corner of the block is placed';
	' at the selected point.']
	  
case 'Copy' then 
  mess=[' To copy a block in main Scicos window';
         ' Click first on the Copy button, then'
	 ' click on the to-be-copied block (in'  
	 ' Scicos window or in a palette) ,  and'
	 ' finally click where you want the copy';
	 ' to be placed in the Scicos window.';
	 ' '
	 ' The lower left corner of the block is placed';
	 ' at the selected point.']  
	   
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
  mess=[' To delete a block or a link, click first on the Delete'  
        ' button, then on the selected object.';
	' '
	' If you delete a block all links connected to it';
	' are deleted as well.']
    
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
         ' in a binary file. A dialog box allows choosing the';
	 ' file which must have a .cos extension. The diagram';
	 ' takes the name of the file (without the extension).']
     
case 'FSave' then
   mess=[' Click on the FSave button to save the diagram';
         ' in a formatted ascii file. A dialog box allows';
	 ' choosing the file which must have a .cosf extension.';
	 ' '
	 ' Formatted save is slower than regular save but';
	 ' has the advantage that the generated file is';
	 ' system independent (usefull for exchanging data';
	 ' on different computers.']    
     
case 'Newblk' then
   mess=[' Click on the Newblk button to save the Super Block'
         ' as a new Scicos block. A Scilab function is generated'
	 ' and saved in a file <window_name>.sci in a user';
	 ' palette directory. <window_name> is the name of the';
	 ' Super Block appearing on top of the window.';
	 ' A dialog allows choosing the palette directory.';
	 ' ';
	 ' To make Scicos recognize your palettes, you should';
	 ' define the Scilab variable user_pal_dir as a column';
	 ' vector of strings containing the paths to your';
	 ' palette directories. This can, for example, be done';
	 ' in your .scilab (user initialization) file.';
	 ' You should also make sure the functions included in';
	 ' your palettes exists in Scilab environment before';
	 ' using Scicos (lib or getf)']
     
case 'Load' then
  mess=[' Click on the Load button to load an ascii or binary file';
        ' containing a saved block diagram.  A dialog box allows';
	' choosing the file.']
     
     
case 'Setup' then
  mess=[' In the main Scicos window, clicking on the Setup button';
        ' invokes a dialog box that allows you to change window';
	' dimensions, integration parameters: absolute and';
	' relative error tolerances and the time tolerance';
	' (the smallest time interval for which the ode';
	' solver is used to update continuous states), and';
        ' the simulation mode (1 or 2).';
	' '
	' In a Super Block window, clicking on this button';
        ' invokes a dialog box that allows changing the window';
	' name (Super Block name) and window dimensions.']
    
case 'New' then
  mess=[' Clicking on the New button loads an empty diagram in the';
        ' main Scicos window. If the previous content of the';
	' window is not saved, it will be lost.']
	     
end
if exists('mess')==0 then 
  mess='No help available on this topic. Sorry.';
end
x_message(mess)

  
 
  
 
