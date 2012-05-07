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

test_pre_commit_without_attributes() {
        echo "exec ./hooks/pre-commit-encoding" >>$PRE_COMMIT
        git add fixtures
        git commit -q -m Commit
        assertTrue $?
}

test_pre_commit_with_attributes() {
        echo "exec ./hooks/pre-commit-encoding" >>$PRE_COMMIT
        echo "*.txt encoding=ascii,utf8" >>.gitattributes
        cat <<EOF >expected.log
fixtures/ja0-7bit-jis-unknown.txt: 7bit-jis-unknown (ascii,utf8)
fixtures/ja0-UTF-16-unknown.txt: UTF-16-unknown (ascii,utf8)
fixtures/ja0-euc-jp-unknown.txt: euc-jp-unknown (ascii,utf8)
fixtures/ja0-shiftjis-unknown.txt: shiftjis-unknown (ascii,utf8)
fixtures/ja0-utf8-with-signature-unknown.txt: utf8-with-signature-unknown (ascii,utf8)
fixtures/ja1-7bit-jis-dos.txt: 7bit-jis-dos (ascii,utf8)
fixtures/ja1-7bit-jis-mac.txt: 7bit-jis-mac (ascii,utf8)
fixtures/ja1-7bit-jis-unix.txt: 7bit-jis-unix (ascii,utf8)
fixtures/ja1-UTF-16-dos.txt: UTF-16-dos (ascii,utf8)
fixtures/ja1-UTF-16-mac.txt: UTF-16-mac (ascii,utf8)
fixtures/ja1-UTF-16-unix.txt: UTF-16-unix (ascii,utf8)
fixtures/ja1-euc-jp-dos.txt: euc-jp-dos (ascii,utf8)
fixtures/ja1-euc-jp-mac.txt: euc-jp-mac (ascii,utf8)
fixtures/ja1-euc-jp-unix.txt: euc-jp-unix (ascii,utf8)
fixtures/ja1-shiftjis-dos.txt: shiftjis-dos (ascii,utf8)
fixtures/ja1-shiftjis-mac.txt: shiftjis-mac (ascii,utf8)
fixtures/ja1-shiftjis-unix.txt: shiftjis-unix (ascii,utf8)
fixtures/ja1-utf8-with-signature-dos.txt: utf8-with-signature-dos (ascii,utf8)
fixtures/ja1-utf8-with-signature-mac.txt: utf8-with-signature-mac (ascii,utf8)
fixtures/ja1-utf8-with-signature-unix.txt: utf8-with-signature-unix (ascii,utf8)
Commit aborted!  (Use "git commit --no-verify" to skip this)
EOF
        git add fixtures
        git commit -q -m Commit
        assertFalse $?
        cmp expected.log pre-commit.log
        assertTrue "$(echo; diff -u expected.log pre-commit.log)" $?
}

test_pre_commit_with_complicated_attributes() {
        echo "exec ./hooks/pre-commit-encoding" >>$PRE_COMMIT
        echo "en*.txt encoding=ascii-dos" >>.gitattributes
        echo "en1*-unix.txt -encoding" >>.gitattributes
        cat <<EOF >expected.log
fixtures/en1-ascii-mac.txt: ascii-mac (ascii-dos)
Commit aborted!  (Use "git commit --no-verify" to skip this)
EOF
        git add fixtures
        git commit -q -m Commit
        assertFalse $?
        cmp expected.log pre-commit.log
        assertTrue "$(echo; diff -u expected.log pre-commit.log)" $?
}

test_pre_commit_default_encoding() {
        echo "exec ./hooks/pre-commit-encoding us-ascii,utf-8,utf-8-with-signature,utf16,sjis,eucjp,jis" >>$PRE_COMMIT
        echo "fixtures/*.txt encoding" >>.gitattributes
        git add fixtures
        git commit -q -m Commit
        assertTrue $?
}

test_pre_commit_endline_dos() {
        echo "exec ./hooks/pre-commit-encoding" >>$PRE_COMMIT
        echo "en*.txt encoding=ascii-dos" >>.gitattributes
        cat <<EOF >expected.log
fixtures/en1-ascii-mac.txt: ascii-mac (ascii-dos)
fixtures/en1-ascii-unix.txt: ascii-unix (ascii-dos)
Commit aborted!  (Use "git commit --no-verify" to skip this)
EOF
        git add fixtures
        git commit -q -m Commit
        assertFalse $?
        cmp expected.log pre-commit.log
        assertTrue "$(echo; diff -u expected.log pre-commit.log)" $?
}

test_pre_commit_endline_unix() {
        echo "exec ./hooks/pre-commit-encoding" >>$PRE_COMMIT
        echo "en*.txt encoding=ascii-unix" >>.gitattributes
        cat <<EOF >expected.log
fixtures/en1-ascii-dos.txt: ascii-dos (ascii-unix)
fixtures/en1-ascii-mac.txt: ascii-mac (ascii-unix)
Commit aborted!  (Use "git commit --no-verify" to skip this)
EOF
        git add fixtures
        git commit -q -m Commit
        assertFalse $?
        cmp expected.log pre-commit.log
        assertTrue "$(echo; diff -u expected.log pre-commit.log)" $?
}

test_pre_commit_endline_mac() {
        echo "exec ./hooks/pre-commit-encoding" >>$PRE_COMMIT
        echo "en*.txt encoding=ascii-mac" >>.gitattributes
        cat <<EOF >expected.log
fixtures/en1-ascii-dos.txt: ascii-dos (ascii-mac)
fixtures/en1-ascii-unix.txt: ascii-unix (ascii-mac)
Commit aborted!  (Use "git commit --no-verify" to skip this)
EOF
        git add fixtures
        git commit -q -m Commit
        assertFalse $?
        cmp expected.log pre-commit.log
        assertTrue "$(echo; diff -u expected.log pre-commit.log)" $?
}

test_pre_commit_unknown_encoding() {
        echo "exec ./hooks/pre-commit-encoding" >>$PRE_COMMIT
        echo "*.txt encoding=hoge" >>.gitattributes
        cat <<EOF >expected.log
Unknown encoding: hoge
EOF
        git add fixtures
        git commit -q -m Commit
        assertFalse $?
        cmp expected.log pre-commit.log
        assertTrue "$(echo; diff -u expected.log pre-commit.log)" $?
}

test_pre_commit_path_with_spaces() {
        echo "exec ./hooks/pre-commit-encoding" >>$PRE_COMMIT
        echo "en*.txt encoding=ascii" >>.gitattributes
        for i in fixtures/en*; do
                cp "$i" "$(echo $i | sed -e 's/-/ /g')"
        done
        git add fixtures
        git commit -q -m Commit
        assertTrue $?
}

test_pre_commit_path_with_colon_space_sequences() {
        echo "exec ./hooks/pre-commit-encoding" >>$PRE_COMMIT
        echo "en*.txt encoding=ascii" >>.gitattributes
        for i in fixtures/en*; do
                cp "$i" "$(echo $i | sed -e 's/-/: /g')"
        done
        git add fixtures
        git commit -q -m Commit
        assertFalse $?
}

. $SHUNIT2
