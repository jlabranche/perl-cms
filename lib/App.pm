package App;
use _config;

use base qw( CGI::Ex::App );
sub template_path { '../tt' }
#sub base_dir_rel  { 'tt' }
sub ext_print     { 'html' }

sub config { shift->{'_config'} ||= _config->new() }
sub dbh    { shift->config->dbh }

1;

