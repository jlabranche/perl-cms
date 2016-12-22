package App;
use warnings;
use strict;

use _config;
use User;

use base qw( CGI::Ex::App );
use FindBin qw($Bin);
use CGI::Ex::Dump qw(debug);

sub template_path { '../tt' }
#sub base_dir_rel  { 'tt' }
sub ext_print     { 'html' }

sub config { shift->{'_config'} ||= _config->new() }
sub dbh    { shift->config->dbh }
sub base   { shift->config->base }
sub user   { shift->{'user'} ||= User->new->user }

sub site_options {
    my $self = shift;
    my $select = {
        site_options => qq{
            SELECT *
              FROM site_options
        },
    };
    my $options_array = $self->dbh->selectall_arrayref($select->{'site_options'}, { Slice => {} } );
    my $site_options;
    for my $so (@$options_array) {
        $site_options->{$so->{'name'}} = $so->{'value'};
    }
    return $site_options;
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

sub cms_info {
    my $self = shift;
    return {
        base => $self->base,
    }
}


sub hash_common {
    my $self = shift;
    return {
        step            => $self->form->{'step'} || 'main',
        base            => $self->base,
        nav_items       => $self->nav_items,
        site_options    => $self->site_options,
        user            => $self->user,
        cmsinfo         => $self->cms_info,
    };
}

1;

