package App;

use base qw( CGI::Ex::App );
sub template_path { '../' }
sub base_dir_rel  { 'tt' }
sub ext_print     { 'html' }

1;

