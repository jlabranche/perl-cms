package App::Login;

use base qw( App );

sub main_hash_swap {
    return {
        bar => "dog",
        foo => "bar"
    }
}

1;
