package Babyry::Logic::Register;
use strict;
use warnings;
use utf8;

use parent qw/Babyry::Logic/;

use Babyry::Common;
use Digest::MD5 qw/md5_hex/;

use SQL::Abstract;
use Babyry::Logic::Mail;
use Babyry::Logic::Sequence;
use Babyry::Logic::Common;
use Log::Minimal;

sub index {
    my ($self) = @_;
}

sub execute {
    my ($self, $params) = @_;

    my ($email, $password) = @{$params}{qw/email password/};

    my $dx = $self->dx('BABYRY_MAIN_W');
    my $unixtime = time();

    my $sequence = Babyry::Logic::Sequence->new();
    my $user_id = $sequence->get_id('seq_user');
    my $token = $self->create_token($user_id);

    eval {
        $dx->insert('user', {
            user_id    => $user_id,
            created_at => $unixtime,
            updated_at => $unixtime,
        });
        $dx->insert('user_auth', {
            user_id       => $user_id,
            email         => $email,
            password_hash => Babyry::Logic::Common->new->enc_password($password), # TODO more strict
        });
        $dx->insert('register_token', {
            user_id    => $user_id,
            token      => $token,
            expired_at => $self->get_expired_at($unixtime),
        });
        $dx->dbh->commit;

        $self->send_verify_mail($email, $token);

    };
    if ($@) {
        $dx->dbh->rollback;
        critf('Failed to register user error:%s email:%s', $@, $email);
        return { error => 'Failed' }; # TODO error handling
    }
}

sub create_token {
    my ($self, $user_id) = @_;
    return md5_hex(time . $user_id . Babyry::Common->get_key_vault('register_secret'));
}

sub get_expired_at {
    my ($self, $unixtime) = @_;
    return $unixtime + 3600 * 24; # TODO move to config
}

sub send_verify_mail {
    my ($self, $email, $token) = @_;

    $email = 'meaning.sys@gmail.com'; # override for safety

    my $mail = Babyry::Logic::Mail->new();
    $mail->set_subject('てすと');
    $mail->set_body(<<"TEXT");
    please click this link to verify your account.

    http://babyryserver5000/register/verify?token=$token
    http://babyryserver5001/register/verify?token=$token
    http://babyryserver5002/register/verify?token=$token
TEXT

    $mail->set_address($email);
    $mail->send_mail;
}

sub verify {
    my ($self, $token) = @_;

    my ($user_id, $expired_at) = $self->dx('BABYRY_MAIN_R')->select(
        'register_token',
        [qw/user_id expired_at/],
        { token => $token }
    )->flat;

    return 'NOT_EXIST' if !$user_id;
    return 'EXPIRED'   if $expired_at <= time();

    # TODO verifyされずにexpireされたtokenをbatchで掃除

    my $dxw = $self->dx('BABYRY_MAIN_W');
    eval {
        $dxw->delete(
            'register_token',
            {
                user_id => $user_id,
                token   => $token,
            }
        );
        $dxw->dbh->commit;
    };
    if ($@) {
        $dxw->dbh->rollback;
        croakf(
            'Failed to delete register_token user_id:%d token:%s error:%s',
            $user_id, $token, $@
        );
    }
}

1;

