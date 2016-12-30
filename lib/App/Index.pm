package App::Index;
use warnings;
use strict;

use base qw( App );
use CGI::Ex::Dump qw(debug);

sub name_module   { '' }

sub name_step { 'main' }

sub path_info_map {
    my $self = shift;
    return [
        [qr{/(.+)}, 'location'],
    ];
}

sub hash_swap {
    my $self = shift;
    my $location = $self->form->{'location'};
    my $select = {
        'content' => qq{
            SELECT *
              FROM pages
             WHERE href = '$location'
        },
    };
    my @result = $self->dbh->selectall_arrayref($select->{'content'}, { Slice => {} } );
    return {
        page_content => $result[0][0]
    };
}

1;
