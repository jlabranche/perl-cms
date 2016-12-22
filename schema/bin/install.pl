#!/usr/bin/perl
use warnings;
use strict;

use Data::Dumper;
use FindBin qw($Bin);
use lib "$Bin/../../lib";
use _config;

#TODO
#add comparison to tables so we know if the schema doesn't match
#let user know
if (opendir(my $dh, "$Bin/../main")) {
    while (my $file = readdir $dh) {
        next if $file =~ /^\.\.?$/;
        if ($file =~ /\.sql$/) {
            my $sql_base = $file;
            $sql_base =~ s/\.sql//;
            install("$Bin/../main/$sql_base.sql");
            if (-f "$Bin/../main/$sql_base.inserts") {
                install("$Bin/../main/$sql_base.inserts");
            }
        }
    }
}



sub install {
    my $file = shift;
    if (open(my $fh, "<", $file)) {
        local $/;
        my $sql = <$fh>;
        my $dbh = _config::dbh;
        eval{$dbh->do($sql)};
        if ($@) {
            print "Error: $file : $@";
        } else {
            print "Installed $file\n";
        }
        close($fh);
    }

}
