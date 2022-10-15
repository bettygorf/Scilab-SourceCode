#! /usr/bin/wish -f



listbox .l1 -selectmode extended -exportselection 0;
listbox .l2 -selectmode multiple -exportselection 0;

pack .l1 .l2
.l1 insert 0 toto;
.l1 insert 0 titi;
.l2 insert 0 tata;
puts [winfo children .];
