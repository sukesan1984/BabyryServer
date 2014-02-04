package Babyry::Service::Register;

use strict;
use warnings;
use utf8;
use parent qw/Babyry::Base/;
use Log::Minimal;

use Babyry::Model::Sequence;
use Babyry::Model::User;
use Babyry::Model::User_Auth;
use Babyry::Model::Register_Token;
use Babyry::Model::Common;
#use Babyry::Model::Maill;

sub execute {
    my ($self, $params) = @_;

    my $error = '';

    # password varidation
    $error = $self->varidate_password($params->{password});
    return { error => $error } if ($error);

    # passowrd match check
    $error = $self->match_password($params->{password}, $params->{password_confirm});
    return { error => $error } if ($error);

    # insert user table
    my $user_id = Babyry::Model::Sequence->new()->get_id('seq_user');
    my $teng = $self->teng('BABYRY_MAIN_W');
    my $user = Babyry::Model::User->new();
    my $user_auth = Babyry::Model::User_Auth->new();
    my $token = Babyry::Model::Register_Token->new();
#    my $mail = Babyry::Model::Maill->new();
    my $unixtime = time();

    eval {
        $user->create(
            $teng,
            {
                user_id => $user_id,
                created_at => $unixtime,
                updated_at => $unixtime,
            }
        );

        $user_auth->create(
            $teng,
            {
                user_id => $user_id,
                email         => $params->{email},
                password_hash => Babyry::Model::Common->new->enc_password($params->{password}),
            }
        );

        $token->create(
            $teng,
            {
                user_id    => $user_id,
                token      => $token,
                expired_at => $self->get_expired_at($unixtime),
            }
        );

#        $mail->send();
    };
    if ($@) {
        $teng->txn_rollback;
        critf($@);
        return { error => 'FAILED_TO_REGISTER' };
    }
    $teng->txn_commit;
    $teng->disconnect();
    return;
}

sub varidate_password {
    my ($self, $password) = @_;
    if($password eq '') {
        return 'NO_PASSWRD';
    }
    if(length($password) < 4 ) {
        return 'TOO_SHORT_PASSWRD';
    }
    return 0;
}

sub match_password {
    my ($self, $password, $password_confirm) = @_;

    return 'NOT_MATCH_PASSWORD' if ($password ne $password_confirm);

    return 0;
}

sub get_expired_at {
    my ($self, $unixtime) = @_;
    return $unixtime + 3600 * 24; # TODO move to config
}

1;
