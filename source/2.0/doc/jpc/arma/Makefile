
%.audit : %.bas 
	@echo "On fait executer par Basile " $<
	cat $< > temp$$$$ ; echo "quit;" >> temp$$$$ ;\
	echo "exec('temp$$$$')" > temp1$$$$ ;\
	basile < temp1$$$$ > temp2$$$$ ;\
	tail +25 temp2$$$$ > $@ ;\rm -f temp$$$$ temp1$$$$ temp2$$$$ ;\
	echo "C'est fait, voir " $@

all	: armap.audit armas.audit1 armaid.audit1
	latex Doc


armas.audit1	: armas.bas 
	cat armap.bas > temp$$$$ ;\
	echo "save('Temp$$$$',ar);quit;" >> temp$$$$ ;\
	echo "exec('temp$$$$')" > temp1$$$$ ;\
	basile < temp1$$$$ > /dev/null ;\
	echo "Partie 1 OK";\
	echo "load('Temp$$$$');" > temp$$$$;\
	cat  armas.bas >> temp$$$$;\
	echo "quit;" >> temp$$$$;\
	echo "exec('temp$$$$')" > temp1$$$$ ;\
	basile < temp1$$$$ > temp2$$$$ ;\
 	tail +25 temp2$$$$ > $@ ;
	\rm -f temp$$$$ temp1$$$$ temp2$$$$ Temp*;\
	mv armas.ps0 armas.ps;\
	Blatexpr 0.8 0.8 armas.ps;
	echo "C'est fait, voir " $@

armaid.audit1	: armas.bas 
	cat armap.bas > temp$$$$ ;\
	cat armas.bas >> temp$$$$ ;\
	echo "save('Temp$$$$',ar,zd,u);quit;" >> temp$$$$ ;\
	echo "exec('temp$$$$')" > temp1$$$$ ;\
	basile < temp1$$$$ > /dev/null ;\
	echo "Partie 1 OK";\
	echo "load('Temp$$$$');" > temp$$$$;\
	cat  armaid.bas >> temp$$$$;\
	echo "quit;" >> temp$$$$;\
	echo "exec('temp$$$$')" > temp1$$$$ ;\
	basile < temp1$$$$ > temp2$$$$ ;\
 	tail +25 temp2$$$$ > $@ ;\
	\rm -f temp$$$$ temp1$$$$ temp2$$$$ Temp*;\
	echo "C'est fait, voir " $@
	

clean	:
	\rm -f temp* Temp*

superclean: clean
	\rm -f *.audit*
