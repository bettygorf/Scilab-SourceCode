clear;lines(0);
TK_EvalStr('toplevel .foo');
// creates a toplevel TK window. 
TK_EvalStr('label .foo.l -text ""TK married Scilab !!!""');
// create a static label
TK_EvalStr('pack .foo.l');
// pack the label widget. It appears on the screen.
text='button .foo.b -text close -command {destroy .foo}';
TK_EvalStr(text);
TK_EvalStr('pack .foo.b');
