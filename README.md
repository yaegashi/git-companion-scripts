# Git Companion Scripts

## Introduction

Useful script collection for Git.

They are expected to work in most Git environment with no additional software
installation.  Git for Windows (msysgit) is also supported.

* `hooks` - Hook scripts for `.git/hooks`
 * `pre-commit-encoding` - pre-commit script to verify file encoding.

* `utils` - Utility scripts
 * `ipconv` - In-place converter of text encoding and newline characters.

* `tests` - Test scripts
 * `shunit2` - [shUnit2](http://code.google.com/p/shunit2/)
               Unix shell unit testing framework.
 * `test-*` - Individual test scripts.

* `runtests.sh` - Script to run all tests.

## License

`tests/shunit2` is taken from [shUnit2](http://code.google.com/p/shunit2/)
 and licensed under LGPL.

Other files are licensed under MIT.

Copyright (c) 2012 Takeshi Yaegashi.
