#!/usr/bin/perl
#Quelle : http://szabgab.com/talks/fundamentals_of_perl/read-excel-file.html
#spreadsheet.xls is your excel file.
use strict;
use warnings;


use Spreadsheet::ParseExcel::Simple qw();
my $xls = Spreadsheet::ParseExcel::Simple->read("spreadsheet.xls");
foreach my $sheet ($xls->sheets) {
    while ($sheet->has_data) {
        my @data = $sheet->next_row;
        print join "|", @data;
        print "\n";
    }
}
