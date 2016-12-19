package App::Admin;
use warnings;
use strict;

use base qw( App );
use CGI::Ex::Dump qw(debug);
use Clone 'clone';
use JSON;

sub main_hash_swap {
    my $self = shift;
    return {
        #page_name => "admin"
    };
}

sub post_navigate {
    # show what happened
    # debug shift->dump_history;
}
sub ajax_run_step {
    my $self = shift;
    my $form = $self->form;
    my $json   = JSON->new->utf8(1);
    my $action = $form->{'action'};
    my ($validation_error, $sub);

    #if form elements that end in [] are not an array, make them so.
    for my $element (keys %$form) {
        if ($element =~ /\[\]$/) {
            if (ref $form->{$element} ne 'ARRAY') {
                $form->{$element} = [$form->{$element}];
            }
        }
    }

    $form->{'data'} = clone($form);
    for my $input (keys %{$form->{'data'}}) {
        if ($input !~ /\[\]/ || $input eq 'type[]') {
            delete $form->{'data'}->{$input};
            next;
        }
        my $res = delete $form->{'data'}->{$input};
        $input =~ s/\[\]//g;
        $form->{'data'}->{$input} = $res;
    }

    $self->cgix->print_content_type('application/json','utf-8');

    if(my $val_sub = $self->can('_ajax_'.$action.'_hash_validation')) {
        my $hash = $val_sub->($self);

        if(ref($hash) && scalar keys %$hash) {
            my $err_obj = eval { $self->val_obj->validate($form, $hash, []) };
            die "Step ajax: $@" if $@ && ! $err_obj;

            $validation_error = $err_obj->as_hash if($err_obj);
            if(defined $validation_error) {
                my $parse_key = sub { my $k = shift; $k =~ s/^(.+)_error$/$1/; return $k; };
                $validation_error->{'error_keys'} ||= do {
                    [ map { $parse_key->($_) } grep { /_error$/ } keys %$validation_error ]
                };
                $validation_error->{'ok'} ||= 0;
            }
        }
    }

    print $json->encode(
        ( defined $validation_error )                               ? $validation_error
        : ( $sub = $self->can('_ajax_'.$action) )                   ? $sub->($self)
        : { 'error' => "Invalid action.", 'ok' => 0 }
        );

    $self->{'_no_post_navigate'} = 1;

    return 1;
}

sub _ajax_nav_items {
    my $self = shift;
    my $form = $self->form;
    return $self->modify_table;
}

sub modify_table {
    my $self  = shift;
    my $form  = $self->form;
    my $data  = $form->{'data'};
    my $table = $form->{'action'};
    my $types;
    
    my %create_keys = %$data;
    delete $create_keys{'id'};
    my $create_query = join(",", map("?", keys %create_keys));
    my $create_rows = join(",", keys %create_keys);

    my $update_query;
    for my $key (keys %$data) {
        if ($key ne 'id') {
            $update_query .= "," if defined $update_query;
            $update_query .= "$key=?";
        }
    }

    my $i = 0;
    for my $type (@{$form->{'type[]'}}) {
        if ($type eq 'update') {
            push(@{$types->{'update'}}, $i++);
        } else {
            push(@{$types->{'create'}}, $i++);
        }
    }

    my $sql = {
        create => qq{
            INSERT INTO $table
                       ($create_rows)
                 VALUES($create_query)
        },
        update => qq{
            UPDATE $table
               SET $update_query
             WHERE id = ?
        },
        delete => qq{
            DELETE
              FROM $table
             WHERE id = ?
        },
    };

    for my $type (keys %$types) {
        for my $i (@{$types->{$type}}) {
            my $capture;
            for my $key (keys %$data) {
                if ($type eq 'update' ||
                        ($type eq 'create' && $key ne 'id') ||
                        $type eq 'delete' && $key eq 'id') {
                    push( @$capture, $data->{$key}->[$i] );
                }
            }
            my $sth = $self->dbh->prepare($sql->{$type});
            $sth->execute(@$capture);
        }
    }

    return {
        sql  => $sql->{'update'},
    }
}
sub _ajax_nav_items_hash_validation {
    my $self = shift;
    return {
        "group no_confirm" => 1,
        "group no_alert"   => 1,
        'name[]' => {
            max_values => 99,
            required => 1,
            max_len => 20,
        },
        'href[]' => {
            max_values => 99,
            required => 1,
        },
        'type[]' => {
            max_values => 99,
            required => 1,
        },
    };
}

1;
