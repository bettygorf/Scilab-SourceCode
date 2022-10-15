SHELL = /bin/sh
SCIDIR=../..
include ../../Makefile.incl

all:: info

world: info

info:
	@echo "Type \"make test\" to compile all programs (in /tmp)"
	@echo "Type \"make /tmp/pgm.o\" to compile pgm program"

FFLAGS = $(FC_OPTIONS)

CFLAGS = $(CC_OPTIONS)

OBJSF = /tmp/ext1f.o /tmp/ext2f.o /tmp/ext3f.o /tmp/ext4f.o /tmp/ext5f.o /tmp/ext6f.o /tmp/ext7f.o /tmp/ext8f.o /tmp/ext9f.o /tmp/ext10f.o /tmp/ext11f.o

OBJSC = /tmp/ext1c.o /tmp/ext2c.o /tmp/ext3c.o /tmp/ext4c.o /tmp/ext5c.o /tmp/ext6c.o /tmp/ext7c.o /tmp/ext8c.o /tmp/ext9c.o /tmp/ext10c.o /tmp/ext11c.o

test : $(OBJSF) $(OBJSC)

/tmp/ext1f.o: ext1f.f
	$(FC) $(FFLAGS) -c ext1f.f  -o /tmp/ext1f.o

/tmp/ext2f.o: ext2f.f
	$(FC) $(FFLAGS) -c ext2f.f  -o /tmp/ext2f.o

/tmp/ext3f.o: ext3f.f
	$(FC) $(FFLAGS) -c ext3f.f  -o /tmp/ext3f.o

/tmp/ext4f.o: ext4f.f
	$(FC) $(FFLAGS) -c ext4f.f  -o /tmp/ext4f.o

/tmp/ext5f.o: ext5f.f
	$(FC) $(FFLAGS) -c ext5f.f  -o /tmp/ext5f.o

/tmp/ext6f.o: ext6f.f
	$(FC) $(FFLAGS) -c ext6f.f  -o /tmp/ext6f.o

/tmp/ext7f.o: ext7f.f
	$(FC) $(FFLAGS) -c ext7f.f  -o /tmp/ext7f.o

/tmp/ext8f.o: ext8f.f
	$(FC) $(FFLAGS) -c ext8f.f  -o /tmp/ext8f.o

/tmp/ext9f.o: ext9f.f
	$(FC) $(FFLAGS) -c ext9f.f  -o /tmp/ext9f.o

/tmp/ext10f.o: ext10f.f
	$(FC) $(FFLAGS) -c ext10f.f  -o /tmp/ext10f.o

/tmp/ext11f.o: ext11f.f
	$(FC) $(FFLAGS) -c ext11f.f  -o /tmp/ext11f.o

/tmp/ext12f.o: ext12f.f
	$(FC) $(FFLAGS) -c ext12f.f  -o /tmp/ext12f.o

/tmp/ext1c.o: ext1c.c
	$(CC) $(CFLAGS) -c ext1c.c  -o /tmp/ext1c.o

/tmp/ext2c.o: ext2c.c
	$(CC) $(CFLAGS) -c ext2c.c  -o /tmp/ext2c.o

/tmp/ext3c.o: ext3c.c
	$(CC) $(CFLAGS) -c ext3c.c  -o /tmp/ext3c.o

/tmp/ext4c.o: ext4c.c
	$(CC) $(CFLAGS) -c ext4c.c  -o /tmp/ext4c.o

/tmp/ext5c.o: ext5c.c
	$(CC) $(CFLAGS) -c ext5c.c  -o /tmp/ext5c.o

/tmp/ext6c.o: ext6c.c
	$(CC) $(CFLAGS) -c ext6c.c  -o /tmp/ext6c.o

/tmp/ext7c.o: ext7c.c
	$(CC) $(CFLAGS) -c ext7c.c  -o /tmp/ext7c.o

/tmp/ext8c.o: ext8c.c
	$(CC) $(CFLAGS) -c ext8c.c  -o /tmp/ext8c.o

/tmp/ext9c.o: ext9c.c
	$(CC) $(CFLAGS) -c ext9c.c  -o /tmp/ext9c.o

/tmp/ext10c.o: ext10c.c
	$(CC) $(CFLAGS) -c ext10c.c  -o /tmp/ext10c.o

/tmp/ext11c.o: ext11c.c
	$(CC) $(CFLAGS) -c ext11c.c  -o /tmp/ext11c.o

/tmp/ext12c.o: ext12c.c
	$(CC) $(CFLAGS) -c ext12c.c  -o /tmp/ext12c.o

clean::
	$(RM) /tmp/ext*.o so_locations *.o
distclean::
	$(RM) /tmp/ext*.o so_locations *.o




