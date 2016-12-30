package App::Login;
use warnings;
use strict;

use FindBin qw($Bin);
use lib "$Bin";
use base qw( App );
use CGI::Ex::Dump qw(debug);
use Digest::SHA qw(sha256_hex);

sub main_hash_swap {
    my $self = shift;
    return {};
}

sub main_hash_validation {
    return {
        user_name => {
            required => 1,
        },
        password => {
            required => 1,
        }
    }
}

sub main_finalize {
    my $self = shift;
    my $form = $self->form;
    my $user = $form->{user_name};
    my $pass = $self->pass($form->{password});
    my $dbh  = $self->dbh;
    if ($self->pass_confirm($user,$pass)) {
        $self->login;
    } else {
        $self->add_to_errors({failed_login => 'incorrect user_name / password combination'});
    }
    return 0;
}

sub login {
    my $self = shift;
    my $form = $self->form;
    my $dbh  = $self->dbh;
    my $user = $form->{user_name};
    my $pass = $self->pass($form->{password});
    my $id   = sha256_hex(join(':', $self->config->salt,$user,$pass,time));
    my $insert = {
        sessions => qq{
            INSERT INTO sessions
                        (session, expired, expiration, user_id)
                 VALUES (?, 0, NOW() + INTERVAL 1 DAY, ?)
        },
    };
    my $insert_sth = $dbh->prepare($insert->{'sessions'});
    $insert_sth->execute($id, $user);
    $self->cgix->set_cookie({
        -name    => "login",
        -value   => $id,
        -expires => '1d',
        -path    => '/',
    });
    $self->cgix->location_bounce($self->base."admin");
}

sub logout_hash_swap {{}}
sub logout_file_print {
    my $self = shift;
    $self->logout;
    return \"You've been logged out";
}
sub logout {
    my $self    = shift;
    my $form    = $self->form;
    my $session = $self->cgix->cookies->{'login'};
    my $dbh     = $self->dbh;
    my $update  = {
        sessions => qq{
            UPDATE sessions 
               SET expired = 1
             WHERE session = ?
        },
    };
    my $sth = $dbh->prepare($update->{'sessions'});
    $sth->execute($self->pass($session));
    $self->cgix->set_cookie({
        -name    => "login",
        -value   => '',
        -expires => '1s',
        -path    => '/',
    });
    $self->cgix->location_bounce("/".$self->base."/admin/login");
}

sub forgot_hash_swap { {} }
sub forgot_file_print { \"[% PROCESS tt/admin/login.html %]" }
sub forgot_hash_validation {
    return {
        user_name => {
            required => 1,
            validate_if => '!email',
        },
        email => {
            required => 1,
            validate_if => '!user_name',
        }
    }
}
sub forgot_finalize {
    my $self = shift;
    my $form = $self->form;
    #can debug $self->forgot for errors
    $self->forgot;
    $self->add_to_form({user_name_error => "If we found a combination with both user_name / email address we'll send an email"});
    return 0; 
}


sub forgot {
    my $self = shift;
    my $form = $self->form;
    if (!$form->{'user_name'}) {
        $self->add_to_form({user_name_error => 'Please type a user_name'});
    }
    if ($self->does_user_match_email($form->{'user_name'},$form->{email})) {
        BEGIN {
            my $b__dir = (-d '/home2/jlabranc/perl'?'/home2/jlabranc/perl':( getpwuid($>) )[7].'/perl');
            unshift @INC,$b__dir.'5/lib/perl5',$b__dir.'5/lib/perl5/x86_64-linux-thread-multi',map { $b__dir . $_ } @INC;
        }
        require Email::Sender::Simple;# qw(sendmail);
        require Email::Sender::Transport::SMTP;
        require Email::Simple;
        require Email::Simple::Creator;
        my $to = $form->{email};
        my $new_password = $self->random_password;
        $self->change_password($form->{user},$new_password);
        my $transport = Email::Sender::Transport::SMTP->new({
            debug => 1,
            sasl_user_name => $self->email->{user},
            sasl_password => $self->email->{pass},
        });
        my $email = Email::Simple->create(
            header => [
                To      => $to,
                From    => $self->email->{user},
                Subject => 'Requested forgot password email',
            ],
            body => "
The following user: ".$form->{user_name}." has requested a forgot password with this email address ".$form->{email}."
The Password is:
$new_password
.",
        );
        return sendmail($email, { transport => $transport });
    }
    return "no user_name provided";
}

sub post_navigate {
   my $self = shift;
   #debug $self->dump_history;
}
#sub register_info_complete { 1 }
sub register_hash_validation {
    return {
        user_name => {
            required    => 1,
            match       => 'm/^(\w+)$/',
            match_error => 'user_names may only contain alphabetical and numeric characters',
            max_len     => 20,
        },
        password => {
            required => 1,
            match       => 'm/\d/',
            match_error => 'Passwords must contain a digit',
            match2       => 'm/[A-Z]/',
            match2_error => 'Passwords must contain an upper case',
            match3       => 'm/[a-z]/',
            match3_error => 'Passwords must contain a lower case',
            match4       => 'm/[\W]/',
            match4_error => 'Passwords must contain a symbol',
            max_len  => 20,
            min_len  => 8,
        },
        password_verify  => {
            validate_if  => 'password',
            equals       => 'password',
            equals_error => 'Password confirmation does not match password',
        },
        'group no_alert'   => 1,
        'group no_confirm' => 1,
    }
}
sub register_finalize {
    my $self = shift;
    my $form = $self->form;
    my $dbh  = $self->dbh;
    if (defined($form->{'password'}) && $form->{'user_name'}) {
        my $user    = $form->{'user_name'};
        my $pass    = $self->pass($form->{'password'});
        my $email   = $form->{'email'};

        if (!$self->user_exists($user)) {
            my $_sth1   = $dbh->prepare("INSERT INTO users (user_name, password, email) VALUES (?, ?, ?)");
            $_sth1->execute($user, $pass, $email);
            $self->login;
        } else {
           $self->add_to_errors({user_name_error => "user_name already taken, use a unique user_name."}); 
        }
    }
    return 0;
}
sub user_exists {
    my $self = shift;
    my $user = shift;
    my $dbh  = $self->dbh;

    my $select = {
        user_name => qq {
            SELECT 1
              FROM users
             WHERE user_name = ?
        }
    };
    my $result = $dbh->selectall_arrayref($select->{'user_name'}, {Slice => {}}, $user);
    return scalar @$result ? 1 : 0;
}
sub pass {
    my $self = shift;
    my $form = $self->form;
    my $pass = shift || $form->{'password'};
    return sha256_hex($self->config->salt.$pass);
}
sub pass_confirm {
    my $self = shift;
    my $form = $self->form;
    my $dbh  = $self->dbh;
    my $user = shift || $form->{'user_name'};
    my $pass = $self->pass;
    my $select = qq{
            SELECT user_name
              FROM users
             WHERE user_name = ?
               AND password = ?
        };
    return $dbh->selectrow_hashref($select, {}, $user, $pass);
}

sub does_user_match_email {
    my $self  = shift;
    my $user  = shift;
    my $email = shift;
    my $dbh   = $self->dbh;
    my $select = qq{
            SELECT 1
              FROM users
             WHERE user_name = ?
               AND email = ?
        };
    my $result = $dbh->selectall_arrayref($select, {Slice => {}}, $user, $email);
    return scalar @$result ? 1 : 0;
}

1;
