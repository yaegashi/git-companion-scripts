# Git Companion Scripts

## Introduction

Useful script collection for [Git](http://git-scm.com/).  Currently it
contains file encoding validation and conversion scripts especially for
multi-platform development.

They are expected to work in most Git environments with no additional software
installation.  Git for Windows ([msysgit](http://msysgit.github.com/)) is also
supported.

More specifically, it's assumed the following software pieces are available:

- Perl 5.8 or later (with [Encode](http://perldoc.perl.org/Encode.html) module).
- Bourne shell (`/bin/sh`) and standard unix commands for tests.

Directories and files:

    - hooks - Hook scripts for .git/hooks
      - pre-commit-encoding - pre-commit script to verify file encoding.

    - utils - Utility scripts
      - ipconv - In-place converter of text encoding and newline characters.

    - tests - Test scripts
      - shunit2 - shUnit2 Unix shell unit testing framework.
      - test-* - Individual test scripts.

    - fixtures - Test fixtures
      - txtgen.pl - Text fixture generator.
      - *.txt - Text fixtures.

    - runtests.sh - Script to run all tests.

## Usage

### hooks/pre-commit-encoding

Call this script from pre-commit hook `.git/hooks/pre-commit`.
You can specify encodings allowed to be committed by script arguments,
or by modifying `@allowed` variable in the script.

It accepts emacs-like encoding notation like
`utf-8` `utf-8-unix` `utf-8-with-signature-unix`.

Specifying no newline character means 'dont care.'
Any newline characters will be accepted.

### utils/ipconv

ipconv is in-place converter of text encoding and newline characters.

Specify the output encoding with `-e` option,
or modify `$output_encoding` variable in the script.

It accepts emacs-like encoding notation like
`utf-8` `utf-8-unix` `utf-8-with-signature-unix`.

Specyfing no newline character means 'dont touch.'
Newline characters are not modified.

It creates backup files with suffix `.orig`.

## License

`tests/shunit2` is taken from [shUnit2](http://code.google.com/p/shunit2/)
 and licensed under LGPL.

Other files are licensed under MIT.

Copyright (c) 2012 Takeshi Yaegashi.
