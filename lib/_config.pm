package _config;
use warnings;
use strict;
use DBI;

use FindBin qw($Bin);
use lib "$Bin";
use _config::override;

sub new { bless @_[1] || {}, shift }
sub dbh {
    my $self = shift;
    my $override = _config::override::init;
    my $port = $override->{'db_port'} || 3306;
    my $host = $override->{'db_host'} || 'localhost';
    my $name = $override->{'db_name'} or die "DB name required";
    my $user = $override->{'db_user'} or die "DB username required";
    my $pass = $override->{'db_pass'} or die "DB password required";
    return $self->{dbh} ||= DBI->connect(
        "DBI:mysql:database=$name;host=$host;port=$port",
        $user,
        $pass,
        {'RaiseError' => 1},
    );
}
sub salt { 'nurnucnu[cy [ [ y [y1[ 8x1[ y4123[h  uqr [uq  py&BN*( IOU{ ;eh r h1;h DFp qdwfashdp by13413$!@#$&#($J#&KCBFDFL!' }
sub base {
    my $override = _config::override::init;
    return $override->{'base'};
}
1;
