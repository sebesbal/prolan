#
# Delphi Yacc & Lex
# Copyright (c) 2003,2004 by Michiel Rook
# Based on Turbo Pascal Lex and Yacc Version 4.1
#
# Test Makefile - Use GNU make!
#
# $Id: Makefile 1444 2005-02-18 10:47:27Z druid $
#


ifeq ($(OSTYPE),linux-gnu)
	LINUX=1
else
	WIN32=1
endif


ifdef WIN32
DCC=dcc32
UNITDIRS='..\src'
MAKE=$(CURDIR)/../make
DYACC='..\src\yacc\dyacc'
DLEX='..\src\lex\dlex'
ifeq ($(OS), Windows_NT)
	RM=cmd /c del
else
	RM=del
endif
endif


ifdef LINUX
DCC=/usr/local/bin/dcc
UNITDIRS=../src
DYACC=../src/yacc/dyacc
DLEX=../src/lex/dlex
RM=rm -f
endif


all: prolanlex.pas prolanyacc.pas

prolanyacc.pas: prolan.y
	$(DYACC) prolan.y prolanyacc.pas
	
prolanlex.pas: prolan.l
	$(DLEX) prolan.l prolanlex.pas
      
clean:
	$(RM) prolanyacc.pas
	$(RM) prolanlex.pas
	$(RM) *.map
	$(RM) *.dcu
	$(RM) *.dpu
	$(RM) *.drc
	$(RM) *.dcp
