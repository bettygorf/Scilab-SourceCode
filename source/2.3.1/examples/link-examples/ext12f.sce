//sharing common data
host("make /tmp/ext12f.o");
a=1:10;
link('/tmp/ext12f.o',['ext12if','ext12of'])  //Must be linked together
n=10;a=1:10;
fort('ext12if',n,1,'i',a,2,'r','out',2);  //loads b with a
c=fort('ext12of',n,1,'i','out',[1,10],2,'r');  //loads c with b
c-a



