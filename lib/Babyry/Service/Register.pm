package Babyry::Service::Register;

use strict;
use warnings;
use utf8;
use parent qw/Babyry::Base/;
use Digest::MD5 qw/md5_hex/;
use Log::Minimal;

use Babyry::Model::Sequence;
use Babyry::Model::User;
use Babyry::Model::User_Auth;
use Babyry::Model::Register_Token;
use Babyry::Model::Common;
use Babyry::Model::AmazonSES;

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
    my $register_token = Babyry::Model::Register_Token->new();
    my $mail = Babyry::Model::AmazonSES->new();
    my $unixtime = time();
    my $expired_at = $self->get_expired_at($unixtime);
    my $token = $self->create_token($user_id);

    $teng->txn_begin;
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
                created_at => $unixtime,
                updated_at => $unixtime,
            }
        );

        $register_token->create(
            $teng,
            {
                user_id    => $user_id,
                token      => $token,
                expired_at => $expired_at,
            }
        );
    };
    if ($@) {
        $teng->txn_rollback;
        $teng->disconnect();
        return { error => 'FAILED_TO_REGISTER' };
    }
    $teng->txn_commit;
    $teng->disconnect();

    $mail->set_subject("Babyryにようこそ");
    $mail->set_body(<<"TEXT");
        Please click this url to verify your account.

        http://babyryserver5000/register/verify?token=$token
        http://babyryserver5001/register/verify?token=$token
        http://babyryserver5002/register/verify?token=$token
TEXT
    #$mail->set_address($params->{email});
    $mail->set_address('meaning.sys@gmail.com');
    $mail->send_mail();

    return;
}

sub verify {
    my ($self, $params) = @_;

    my $user = Babyry::Model::User->new(); 
    my $register_token = Babyry::Model::Register_Token->new();
    my $teng = $self->teng('BABYRY_MAIN_R');

    # get user_id by token
    my $user_id = $register_token->get_user_id( $teng, { token => $params->{token} } );
    if (!$user_id) {
        $teng->disconnect;
        return {error => 'INVALID TOKEN'};
    }

    $teng = $self->teng('BABYRY_MAIN_W');
    $teng->txn_begin;
    my $error = $user->update_status( $teng, { status => '1', user_id => $user_id } );
    if ($error) {
        $teng->txn_rollback;
        $teng->disconnect;
        return {error => $error};
    }

    $error = $register_token->delete( $teng, { token => $params->{token} } );
    if ($error->{error}) {
        $teng->txn_rollback;
        $teng->disconnect;
        return {error => $error};
    }

    $teng->txn_commit;
    $teng->disconnect;

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

sub create_token {
    my ($self, $user_id) = @_;
    return md5_hex(time . $user_id . Babyry::Common->get_key_vault('register_secret'));
}

1;
