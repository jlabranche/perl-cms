package App;
use warnings;
use strict;

use _config;

use base qw( CGI::Ex::App );
use CGI::Ex::Dump qw(debug);

sub template_path { '../tt' }
#sub base_dir_rel  { 'tt' }
sub ext_print     { 'html' }

sub config { shift->{'_config'} ||= _config->new() }
sub dbh    { shift->config->dbh }

sub hash_common {
    my $self = shift;

    my $nav_items = $self->dbh->selectall_arrayref("SELECT * FROM nav_items ORDER BY position", { Slice => {} }, );

    my $site_title = "My Site";
    
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    $year += 1900;
    my $completion_date = $year + 1;

    return {
        nav_items => $nav_items,
        site_title => $site_title,
        completion_date => $completion_date
    };
}

1;

