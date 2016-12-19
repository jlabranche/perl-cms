package _config;
use DBI;

sub new { bless @_[1] || {}, shift }
sub dbh {
    return $self->{dbh} ||= DBI->connect(
        "DBI:mysql:database=jlabranc_cms;
        host=localhost",
        "jlabranc_cms",
        "FireFox123!@#",
        {'RaiseError' => 1},
    );
}
sub salt { 'nurnucnu[cy [ [ y [y1[ 8x1[ y4123[h  uqr [uq  py&BN*( IOU{ ;eh r h1;h DFp qdwfashdp by13413$!@#$&#($J#&KCBFDFL!' }
sub base { }
1;
