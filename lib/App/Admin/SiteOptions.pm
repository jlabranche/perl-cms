package App::Admin::SiteOptions;
use warnings;
use strict;

use base qw{App::Admin};
use CGI::Ex::Dump qw(debug);

sub site_options_hash_swap {
    my $dir = './../media/themes';
    my @files;

    opendir(DIR, $dir) or die $!;
    while (my $file = readdir(DIR)) {
        # Ignore files beginning with a period
        next if ($file =~ m/^\./);
        push(@files, $file);
    }
    closedir(DIR);

    return {
        themes => \@files,
    }
}

1;