#!/bin/sh

# ipconv tests.
# Copyright (c) 2012 Takeshi Yaegashi.
# License: MIT

export LANG=C

TOPDIR=$PWD
REPOSDIR=$TOPDIR/repos
SHUNIT2=$TOPDIR/tests/shunit2
PRE_COMMIT=.git/hooks/pre-commit

setUp() {
        cd $TOPDIR
        rm -rf $REPOSDIR
        mkdir $REPOSDIR
        cp fixtures/*.txt utils/ipconv $REPOSDIR
        cd $REPOSDIR
}

tearDown() {
        cd $TOPDIR
        rm -rf $REPOSDIR
}

do_ipconv() {
        cp $3 actual.txt
        ./ipconv -e $1 actual.txt
        assertTrue "Failed $*" $?
        cmp $2 actual.txt
        assertTrue "Unmatched $*" $?
}

test_ipconv_utf8() {
        for i in ja1-*.txt; do
                do_ipconv utf8 ja1-utf8-${i##*-} $i
        done
}

test_ipconv_utf8_dos() {
        for i in ja1-*.txt; do
                do_ipconv utf8-dos ja1-utf8-dos.txt $i
        done
}

test_ipconv_utf8_mac() {
        for i in ja1-*.txt; do
                do_ipconv utf8-mac ja1-utf8-mac.txt $i
        done
}

test_ipconv_utf8_unix() {
        for i in ja1-*.txt; do
                do_ipconv utf8-unix ja1-utf8-unix.txt $i
        done
}


. $SHUNIT2
