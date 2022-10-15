SHELL = /bin/sh


all: get check

get :
	@./get_examples.sh
check:
	@./check.sh >check.log
visual:
	@./visualcheck.sh >check.log
world: all


clean:
	$(RM)  *.log *.dia

distclean:
	$(RM)  *.log *.dia *.tst 
