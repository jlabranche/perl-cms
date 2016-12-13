package App::Install;

use base qw( App );

sub main_hash_swap {
    my $self = shift;
    return {
        connection => !!$self->dbh,
    };
}

sub main_finalize {
    my $self = shift;
    my $form = $self->form;
    return 1;
}

1;
