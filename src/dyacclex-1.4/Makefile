#
# Delphi Yacc & Lex - Parser generator toolset for Delphi and Kylix
# Copyright (c) 2003,2004 by Michiel Rook
# Based on Turbo Pascal Lex and Yacc Version 4.1
#
#
# Copyright (c) 1990-2000 by Albert Graef
#                       <ag@muwiinfa.geschichte.uni-mainz.de>
# Copyright (c) 1996 by Berend de Boer
#                       <berend@pobox.com>
# Copyright (c) 1998 by Michael Van Canneyt
#                       <Michael.VanCanneyt@fys.kuleuven.ac.be>
#
# Main Makefile - Use GNU make!
#
# $Id: Makefile 1448 2005-02-18 11:36:21Z druid $
#

BIN = $(DESTDIR)/usr/bin
SHARE = $(DESTDIR)/usr/share/dyacclex

all:	
	$(MAKE) -C src

prolan: all
	$(MAKE) -C prolan

install: prolan
	install -d $(BIN) $(SHARE)
	install src/lex/dlex $(BIN)
	install src/yacc/dyacc $(BIN)
	
	install src/lex/yylex.cod $(SHARE)
	install src/yacc/yyparse.cod $(SHARE)
                
clean:
	$(MAKE) -C src clean
	$(MAKE) -C prolan clean
