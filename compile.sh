#!/bin/sh

 BIBCONTENT=bibcontent
 BIBAUTHOR=bibauthor
 UTILFILE=util
 DATABASE=cs348

 DB2HOME=`eval echo ~"$DB2INSTANCE"`
 DB2PATH="$DB2HOME"/sqllib

 CC=gcc 
 CFLAGS=-I"$DB2PATH"/include
 LIBS="-L$DB2PATH/lib -ldb2"

 set -x

 rm -f "$BIBCONTENT" "$BIBCONTENT".c "$BIBCONTENT".o "$BIBCONTENT".bnd
 rm -f "$BIBAUTHOR" "$BIBAUTHOR".c "$BIBAUTHOR".o "$BIBAUTHOR".bnd
 rm -f "$UTILFILE" "$UTILFILE".o "$UTILFILE".bnd

 db2 connect to "$DATABASE"
 db2 prep "$BIBCONTENT".sqc bindfile
 db2 bind "$BIBCONTENT".bnd
 db2 prep "$BIBAUTHOR".sqc bindfile
 db2 bind "$BIBAUTHOR".bnd
 db2 connect reset
 "$CC" "$CFLAGS" -c "$BIBCONTENT".c
 "$CC" "$CFLAGS" -c "$BIBAUTHOR".c
 "$CC" "$CFLAGS" -c -Wno-format "$UTILFILE".c
 "$CC" "$CFLAGS" -o "$BIBCONTENT" "$BIBCONTENT".o "$UTILFILE".o $LIBS
 "$CC" "$CFLAGS" -o "$BIBAUTHOR" "$BIBAUTHOR".o "$UTILFILE".o $LIBS
 