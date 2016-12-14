package App::Index;

use base qw( App );

sub name_module   { '' }
sub main_hash_swap {
    return {
        #TODO grab conent from db
        content => "Hello world."
    };
}

1;
