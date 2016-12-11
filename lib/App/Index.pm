package App::Index;

use base qw( App );

sub name_module   { '' }
sub main_hash_swap {
    return {
        dog => "bar",
        cat => "dog",
    };
}

1;
