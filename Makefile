#
# 2010/12/16 by D. Grant Starkweather
#

MVPVERSION = 0.0.0

HFLS	= mvptree.h
OBJS	= mvptree.o

CC	= cc

CFLAGS	= -g -O3 -I. -Wall $(DEFINES)

CPPFLAGS += -pthread -I /usr/include

LDFLAGS	=
RANLIB	= ranlib

DDIR	= $(DESTDIR)/usr
TEST	= testmvp
TEST2	= testmvp2
TEST3   = imget

LIBRARY	= libmvptree.a

DEPS_LIBS = -lm

IMGET_DEFINES = -Dcimg_use_xshm -Dcimg_use_xrandr -Dcimg_use_jpeg
IMGET_LIBS = -lX11 -lXext -lXrandr -ljpeg

#uncomment to use libprng.a library for random number generation
#DEPS_LIBS += /usr/lib/libprng.a


all : $(TEST) $(TEST2)

clean :
	rm -f a.out core *.o *.t
	rm -f $(LIBRARY) $(UTIL) $(TEST) $(TEST2) $(TEST3)

install : $(HFLS) $(LIBRARY) 
	mkdir -p $(DDIR)/include
	mkdir -p $(DDIR)/lib
	install -m 755 $(HFLS) $(DDIR)/include
	install -m 755 $(LIBRARY) $(DDIR)/lib
	$(RANLIB) $(DDIR)/lib/$(LIBRARY)

$(LIBRARY) : $(OBJS) $(HFLS)
	ar cr $(LIBRARY) $?
	$(RANLIB) $@

tests : $(TEST) $(TEST2) $(TEST3)

$(TEST) : $(LIBRARY) $(TEST).o 
	rm -f $@
	$(CC) $(CFLAGS) $(LDFLAGS) $(TEST).o $(LIBRARY) $(DEPS_LIBS)
	mv a.out $@

$(TEST2): $(LIBRARY) $(TEST2).o
	rm -f $@
	$(CC) $(CFLAGS) $(LDFLAGS) $(TEST2).o $(LIBRARY) $(DEPS_LIBS)
	mv a.out $@

imget: $(LIBRARY) imget.o
	rm -f $@
	g++ $(CFLAGS) $(IMGET_DEFINES) $(CPPFLAGS) $(LDFLAGS) imget.o $(LIBRARY) $(DEPS_LIBS) $(IMGET_LIBS)
	mv a.out $@

.c.o :
	rm -f $@
	$(CC) $(CFLAGS) -c $< -o $@

imget.o : imget.cpp
	rm -f $@
	g++ $(CFLAGS) $(CPPFLAGS) -c imget.cpp -o $@
