clear;lines(0);
// Gain:
Sys=ssrand(0,2,5,list('st',2,3,3));
A=Sys('A');B=Sys('B');F=stabil(A,B);
spec(A) //2 controllable modes 2 unstable uncontrollable modes
//and one stable uncontrollable mode
spec(A+B*F) //the two controllable modes are set to -1.
// Compensator:
Sys=ssrand(3,2,5,list('st',2,3,3)); //3 outputs, 2 inputs, 5 states
//2 controllables modes, 3 controllable or stabilizable modes.
K=stabil(Sys,-2,-3);  //Compensator for Sys.
spec(Sys('A'))
spec(h_cl(Sys,K))   //K Stabilizes what can be stabilized.
