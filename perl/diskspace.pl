#!/usr/bin/perl
# Quelle : http://szabgab.com/talks/fundamentals_of_perl/read-excel-file.html
use strict;
use warnings;

use Filesys::Df qw(df);

my $df = df("/", 1024 * 1024 * 1024);
print "Percent Full:               		$df->{per}\n";
print "Superuser Blocks:           		$df->{blocks}\n";
print "Superuser Blocks Available: 		$df->{bfree}\n";
print "User Blocks:                		$df->{user_blocks}\n";
print "User Blocks Available:      		$df->{bavail}\n";
print "Blocks Used:                		$df->{used}\n"
