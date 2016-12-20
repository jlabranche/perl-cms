package App;
use warnings;
use strict;

use _config;

use base qw( CGI::Ex::App );
use FindBin qw($Bin);
use CGI::Ex::Dump qw(debug);

sub template_path { '../tt' }
#sub base_dir_rel  { 'tt' }
sub ext_print     { 'html' }

sub config { shift->{'_config'} ||= _config->new() }
sub dbh    { shift->config->dbh }
sub base   { shift->config->base }
sub site_options {
    my $self = shift;
    my $select = {
        site_options => qq{
            SELECT *
              FROM site_options
        },
    };
    return $self->dbh->selectall_arrayref($select->{'site_options'}, { Slice => {} } );
}
sub nav_items {
    my $self = shift;
    my $select = {
        nav_items => qq{
            SELECT *
              FROM nav_items
          ORDER BY position
        },
    };
    return $self->dbh->selectall_arrayref($select->{'nav_items'}, { Slice => {} } );
}


sub hash_common {
    my $self = shift;

    return {
        base            => $self->base,
        nav_items       => $self->nav_items,
        site_options    => $self->site_options,
    };
}

1;

