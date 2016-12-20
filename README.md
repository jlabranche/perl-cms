# perl-cms

Basic CGI::Ex::App for teaching simple functionality.



if manually installing yourself you need a override.pm file: lib/_config/override.pm

basic example:
package _config::override;

sub init {
    return {
        db_name => "jlabranc_cms",
        db_user => "jlabranc_cms",
        db_pass => "FireFox123!@#",
        db_host => "localhost",
        db_port => 3306,
        base    => "/perl-cms",
    }
}
1;
