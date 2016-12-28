package App::Admin::Pages;
use warnings;
use strict;

use base qw{App::Admin};
use CGI::Ex::Dump qw(debug);

sub pages_pre_step {
    my $self = shift;
    if($self->form->{'page_id'} eq 'new') {
        my $insert = $self->dbh->prepare(qq{INSERT INTO pages (title, author_id) VALUES ('New Page', ?)});
        $insert->execute($self->user->{'id'});
        my @pages = $self->dbh->selectall_arrayref(qq{SELECT id, date_created FROM pages ORDER BY date_created DESC});
        $self->cgix->location_bounce("admin/pages/" + $pages[0][0][0]);
        $self->exit_nav_loop;
    }
    return 0;
}

sub pages_hash_swap {
    my $self    = shift;
    my $form    = $self->form;
    my $page_id = $form->{'page_id'};
    my $select  = {
        pages => qq{
            SELECT p.id, p.title, p.href, p.content, u.user_name as author, p.date_modified, p.date_published, ps.name as status
              FROM pages p
              JOIN page_status ps
                ON p.page_status_id=ps.id
              JOIN users u 
                ON p.author_id=u.id 
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
            WHERE p.id = ?
        };
    } else {
        $select->{'pages'} .= qq{
            ORDER BY p.title 
        }
    }

    return {
        pages => $self->dbh->selectall_arrayref($select->{'pages'}, { Slice => {} }, (defined $page_id ? $page_id : ()) ),
    }
}

sub path_info_map {
    my $self = shift;
    return [
        [qr{^/\w+/(\w+)$}, 'page_id'],
    ];
}

sub name_step {
    return 'individual-page' if defined shift->form->{'page_id'};
    return 'pages';
}

1;
