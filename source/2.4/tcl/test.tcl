#! /usr/bin/wish -f

############################################
# TKSCILAB Gui Interface facility for Scilab
# Bertrand Guiheneuf - 1998 
############################################
#

source "$env(SCI)/tcl/misc.tcl"
source "$env(SCI)/tcl/callbacks.tcl"
source "$env(SCI)/tcl/tkcontrols.tcl"
source "$env(SCI)/tcl/set.tcl"
source "$env(SCI)/tcl/get.tcl"
source "$env(SCI)/tcl/figure.tcl"
source "$env(SCI)/tcl/uicontrol.tcl"
source "$env(SCI)/tcl/uimenu.tcl"






######################################################################################
######################################################################################
######################################################################################

#set Win(0) . ;

# the root object is the first tk object
set root .;


# figure are special objects
# their parent *must* be the root object
# and we must keep a list of all figures,
# delete them from the list when they are destroyed
# and remember their order of creation.
# This will allow to manage the gcf feature
# which allows to know in which figure to draw.
set FigList {};
# FreeFigHandle is also a global list 
# containing all the free figure handles.
set FreeFigHandle {};


set Win(0) $root;
# this is the first object handle
# the handle between 1 and 999 are reverved for figures handles
set WinIdx 1000;


set gcbo 0; # object which callback is currently executing 
set gcf 0; #current figure index
set gco 0; #current object handle 
#. configure -bg #d0d0d0 ;
wm withdraw .;


# default bindings 
bind figure <Destroy> {CloseFigure %W}

set f [CreateFigure 0]; 
set h [CreateUIControl $f scrolllistbox];

#SetField $h label toto;

SetField $h units normalized;
SetField $h position "0.05|0.1|0.4|0.8";
SetField $h string "a|b|c|d|e|f"

GetField $h "value"

set h2 [CreateUIControl $f scrolllistbox];

#SetField $h2 label toto;

SetField $h2 units normalized;
SetField $h2 position "0.55|0.1|0.4|0.8";
SetField $h2 string "a|b|c|d|e|f"

GetField $h2 "value"
DestroyFigure $h
set h [CreateUIControl $f popupmenu];


