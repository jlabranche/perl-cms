package App::Admin::Users;
use warnings;
use strict;

use base qw{App::Admin};
use CGI::Ex::Dump qw(debug);

sub users_hash_swap {
    my $self = shift;
    my $users = qq{
        SELECT id, user_name
          FROM users
    };
    return {
        users => $self->dbh->selectall_arrayref($users, { Slice => {} }),
    }
}

1;