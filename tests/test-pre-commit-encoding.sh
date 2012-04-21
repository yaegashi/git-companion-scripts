#!/bin/sh

# pre-commit-encoding tests.
# Copyright (c) 2012 Takeshi Yaegashi.
# License: MIT

export LANG=C

TOPDIR=$PWD
REPOSDIR=$TOPDIR/repos
SHUNIT2=$TOPDIR/tests/shunit2

setUp() {
        cd $TOPDIR
        rm -rf $REPOSDIR
        git init $REPOSDIR
        cd $REPOSDIR
        cp -R $TOPDIR/fixtures $TOPDIR/utils .
        cp $TOPDIR/hooks/* .git/hooks
        cat <<EOF >.git/hooks/pre-commit
#!/bin/sh
.git/hooks/pre-commit-encoding
EOF
        chmod +x .git/hooks/pre-commit
}

tearDown() {
        cd $TOPDIR
        rm -rf $REPOSDIR
}

testPreCommit() {
        git add fixtures
        git commit -m 'First commit'
        assertFalse "$?"
}

. $SHUNIT2
