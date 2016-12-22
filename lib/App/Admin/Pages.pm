package App::Admin::Pages;
use warnings;
use strict;

use base qw{App::Admin};
use CGI::Ex::Dump qw(debug);

sub pages_hash_swap {
    my $self    = shift;
    my $form    = $self->form;
    my $page_id = $form->{'page_id'};
    my $select  = {
        pages => qq{
            SELECT *
              FROM pages 
              JOIN page_status 
                ON pages.page_status_id=page_status.id
          ORDER BY pages.title
        },
    };
    #$select = {
    #    pages => qq{
    #        SELECT *
    #          FROM page_status
    #      }
    #};
    if (defined $page_id) {
        $select->{'pages'} .= qq{
            WHERE id = ?
        };
    }
    return {
        pages => $self->dbh->selectall_arrayref($select->{'pages'}, { Slice => {} }, (defined $page_id ? $page_id : ()) ),
    }
}

sub path_info_map {
    my $self = shift;
    return [
        [qr{^/\w+/(\d+)$}, 'page_id'],
    ];
}

1;
