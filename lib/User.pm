package User;
use warnings;
use strict;

use FindBin qw($Bin);
use lib "$Bin";
use base qw(CGI::Ex::App);
use _config;

sub config { shift->{'_config'} ||= _config->new }

sub user {
    my $self = shift;
    return $self->{'user'} ||= $self->_session;
}
sub _session {
    my $self = shift;
    my $dbh = $self->config->dbh;
    my $session = $self->cgix->cookies->{'login'};
    my $select = {
        sessions => qq{
            SELECT u.*
              FROM sessions s
              JOIN users u ON u.user_name = s.user_id
             WHERE s.expired = 0
               AND s.expiration > NOW()
               AND s.session = ?
        },
    };
    my $user = $dbh->selectrow_hashref($select->{'sessions'}, {}, $session);
    if ($user) {
      return $self->{'user'} = $user;
    }
    return {};
}

sub login {
    
}

sub logout {
}

1;
