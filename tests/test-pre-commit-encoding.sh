#!/bin/sh

# pre-commit-encoding tests.
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
        git init $REPOSDIR >/dev/null
        cp -R hooks utils fixtures $REPOSDIR
        cd $REPOSDIR
        echo "#!/bin/sh" >$PRE_COMMIT
        echo "exec >pre-commit.log 2>&1" >>$PRE_COMMIT
        chmod +x $PRE_COMMIT
        git config core.autocrlf false
}

tearDown() {
        cd $TOPDIR
        rm -rf $REPOSDIR
}

test_pre_commit() {
        echo "exec ./hooks/pre-commit-encoding" >>$PRE_COMMIT
        cat <<EOF >expected.log
fixtures/ja0-7bit-jis-unknown.txt: 7bit-jis-unknown
fixtures/ja0-UTF-16-unknown.txt: UTF-16-unknown
fixtures/ja0-euc-jp-unknown.txt: euc-jp-unknown
fixtures/ja0-shiftjis-unknown.txt: shiftjis-unknown
fixtures/ja0-utf8-with-signature-unknown.txt: utf8-with-signature-unknown
fixtures/ja1-7bit-jis-dos.txt: 7bit-jis-dos
fixtures/ja1-7bit-jis-mac.txt: 7bit-jis-mac
fixtures/ja1-7bit-jis-unix.txt: 7bit-jis-unix
fixtures/ja1-euc-jp-dos.txt: euc-jp-dos
fixtures/ja1-euc-jp-mac.txt: euc-jp-mac
fixtures/ja1-euc-jp-unix.txt: euc-jp-unix
fixtures/ja1-shiftjis-dos.txt: shiftjis-dos
fixtures/ja1-shiftjis-mac.txt: shiftjis-mac
fixtures/ja1-shiftjis-unix.txt: shiftjis-unix
fixtures/ja1-utf8-with-signature-dos.txt: utf8-with-signature-dos
fixtures/ja1-utf8-with-signature-mac.txt: utf8-with-signature-mac
fixtures/ja1-utf8-with-signature-unix.txt: utf8-with-signature-unix
Commit aborted! (allowed encodings: ascii utf-8)
EOF
        git add fixtures
        git commit -q -m Commit
        assertFalse $?
        cmp expected.log pre-commit.log
        assertTrue "$(echo; diff -u expected.log pre-commit.log)" $?
}

test_pre_commit_binary() {
        echo "exec ./hooks/pre-commit-encoding" >>$PRE_COMMIT
        echo "fixtures/*.txt binary" >.gitattributes
        git add fixtures
        git commit -q -m Commit
        assertTrue $?
}

test_pre_commit_aliases() {
        echo "exec ./hooks/pre-commit-encoding us-ascii utf-8 utf-8-with-signature utf16 sjis eucjp jis" >>$PRE_COMMIT
        git add fixtures
        git commit -q -m Commit
        assertTrue $?
}

. $SHUNIT2
