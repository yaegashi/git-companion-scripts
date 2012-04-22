#!/usr/bin/env perl

use utf8;
use strict;
use warnings;
use Encode;

my $en0 = "This is English text without newline characters.";
my $en1 = "This is\012English text\012\012with newline characters.\012";
my $ja0 = "これは改行文字を含まない日本語のテキストです。";
my $ja1 = "これは\012改行文字を含む\012\012日本語のテキストです。\012";
my @encodings = qw/ascii utf8 utf8-with-signature UTF-16 shiftjis euc-jp 7bit-jis/;
my %newlines = ( dos => "\015\012", mac => "\015", unix => "\012" );

for (@encodings) {

        /(.*?)(-with-signature)?$/;
        my $e = $1;
        my $s = $2;
        my $fn;
        my $t0;
        my $t1;
        if ($e eq "ascii") { $fn = "en"; $t0 = $en0; $t1 = $en1; }
        else { $fn = "ja"; $t0 = $ja0; $t1 = $ja1; }
        if ($s) { $t0 = "\x{feff}$t0"; $t1 = "\x{feff}$t1"; }

        my $fh;

        open $fh, ">", "${fn}0-$_-unknown.txt";
        binmode $fh;
        print $fh encode($e, $t0);
        close $fh;

        while ((my $n, my $c) = each %newlines) {
                my $t1dup = $t1;
                $t1dup =~ s/\012/$c/g;
                open $fh, ">", "${fn}1-$_-$n.txt";
                binmode $fh;
                print $fh encode($e, $t1dup);
                close $fh;
        }
}
