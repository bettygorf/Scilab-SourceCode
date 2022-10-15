clear;lines(0);
plot2d([0;1],[0;1],0)
xstring(0.5,0.5,["Scilab" "is"; "not" "esilaB"])
//Other example
alphabet=["a" "b" "c" "d" "e" "f" "g" ..
          "h" "i" "j" "k" "l" "m" "n" ..
          "o" "p" "q" "r" "s" "t" "u" ..
          "v" "w" "x" "y" "z"];
xbasc()
plot2d([0;1],[0;2],0)
xstring(0.1,1.8,alphabet)     // alphabet
xstring(0.1,1.6,alphabet,0,1) // alphabet in a box
xstring(0.1,1.4,alphabet,20)  // angle
xset("font",1,1)              // use symbol fonts
xstring(0.1,0.1,alphabet)
xset("font",1,3)              // change size font
xstring(0.1,0.3,alphabet)
xset("font",1,24); xstring(0.1,0.6,"a") //big alpha
xset("default")
