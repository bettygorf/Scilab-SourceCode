SHELL = /bin/sh

include ../Path.incl
include ../Makefile.incl

CH1 = Programming
DIR1 = programming

CH2 = Graphics
DIR2 = graphics

CH3 = Elementary
DIR3 = elementary

CH4 = Control
DIR4 = control

CH5 = Robust
DIR5 = robust

CH6 = Nonlinear
DIR6 = nonlinear

CH7 = Signal
DIR7 = signal

CH8 = Polynomials
DIR8 = polynomials

CH9 = Linear
DIR9 = linear

CH10 = Comm
DIR10 = comm

CH11 = Metanet
DIR11 = metanet

CH12 = Arma
DIR12 = arma

CH13 = Tdcs
DIR13 = tdcs

CH14 = Scicos
DIR14 = scicos

CH15 = Sound
DIR15 = sound

CH16 = Dcd
DIR16 = dcd

CH17 = Fraclab
DIR17 = fraclab

CH18 = Translation
DIR18 = translation

CH19 = Pvm 
DIR19 = pvm

CH20 = Tksci
DIR20 = tksci

DIRS = $(DIR1) $(DIR2) $(DIR3) $(DIR4) $(DIR5) $(DIR6) $(DIR7) $(DIR8) \
	$(DIR9) $(DIR10) $(DIR11) $(DIR12) $(DIR13) $(DIR14) $(DIR15) \
	$(DIR16) $(DIR17) $(DIR18) $(DIR19) $(DIR20)

all:: 
	@./formatman $(DIRS)

world: all

$(CH1):
	@./formatman $(DIR1)

$(CH2):
	@./formatman $(DIR2)

$(CH3):
	@./formatman $(DIR3)

$(CH4):
	@./formatman $(DIR4)

$(CH5):
	@./formatman $(DIR5)

$(CH6):
	@./formatman $(DIR6)

$(CH7):
	@./formatman $(DIR7)

$(CH8):
	@./formatman $(DIR8)

$(CH9):
	@./formatman $(DIR9)

$(CH10):
	@./formatman $(DIR10)

$(CH11):
	@./formatman $(DIR11)

$(CH12):
	@./formatman $(DIR12)

$(CH13):
	@./formatman $(DIR13)

$(CH14):
	@./formatman $(DIR14)

$(CH15):
	@./formatman $(DIR15)

$(CH16):
	@./formatman $(DIR16)

$(CH17):
	@./formatman $(DIR17)

$(CH18):
	@./formatman $(DIR18)

$(CH19):
	@./formatman $(DIR19)

$(CH20):
	@./formatman $(DIR20)


clean::
	for i in $(DIRS) ;\
	do \
		(cd $$i ; echo "making clean in man/$$i..."; \
		$(RM)  $(FILES_TO_CLEAN)); \
	done
