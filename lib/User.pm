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
    return $self->{'user'} || $self->_session;
}
sub _session {
    my $self = shift;
    my $db = $self->config->dbh;
    my $session = $self->cgix->cookies->{'login'};
    my $select = {
        session => qq{
            SELECT u.*
              FROM session s
              JOIN users u ON u.username = s.user_id
             WHERE s.expired = 0
               AND s.expiration > NOW()
               AND s.session = ?
        },
    };
    my $user = $db->selectrow_hashref($select->{'session'}, {}, $session);
    if (!$user && $ENV{PATH_INFO} !~ /admin.*/) {
        $self->cgix->location_bounce("/".$self->config->base."/login");
    }
    $self->{'user'} = $user;
    return $user;
}

sub login {
    
}

sub logout {
}

1;
