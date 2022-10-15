clear;lines(0);
// creates a toplevel TK window. TK_EvalStr('label .foo.l -textvariable tvar');
// create a static label
TK_EvalStr('pack .foo.l');
// pack the label widget. It appears on the screen.
TK_SetVar('tvar','This text has been set directly within scilab');
