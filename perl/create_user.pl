#!/usr/bin/perl
#Quelle http://szabgab.com/talks/fundamentals_of_perl/read-excel-file.html
use strict;
use warnings;

my $adduser = '/usr/sbin/adduser';

use Getopt::Long qw(GetOptions);

my %opts;
GetOptions(\%opts,
    'fname=s',
    'lname=s',
) or usage();

if (not $opts{fname} or $opts{fname} !~ /^[a-zA-Z]+$/) {
    usage("First name must be alphabetic");
}
if (not $opts{lname} or $opts{lname} !~ /^[a-zA-Z]+$/) {
    usage("Last name must be alphabetic");
}
my $username = lc( substr($opts{lname}, 0, 1) . $opts{fname});
my $home     = "/opt/$username";

print "Username: $username\n";

my $cmd = qq($adduser --home $home --disabled-password --gecos "$opts{fname} $opts{lname}" $username);

print "$cmd\n";
system $cmd;

sub usage {
    my ($msg) = @_;
    if ($msg) {
        print "$msg\n\n";
    }
    print "Usage: $0 --fname FirstName --lname LastName\n";
    exit;
}
