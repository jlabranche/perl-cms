#!/usr/bin/perl
use warnings;
use strict;

use Data::Dumper;
use FindBin qw($Bin);
use lib "$Bin/../../lib";
use _config;

local $/;

#TODO
#add comparison to tables so we know if the schema doesn't match
#let user know
if (opendir(my $dh, "$Bin/../main")) {
    while (my $file = readdir $dh) {
        next if $file =~ /^\.\.?$/;
        if ($file =~ /\.sql$/) {
            if (open(my $fh, "<", "$Bin/../main/$file")) {
                my $sql = <$fh>;
                my $dbh = _config->dbh;
                eval{$dbh->do($sql)};
                if ($@) {
                    print "Error: $file : $@";
                }
                close($fh);
            }
        }
    }
}
