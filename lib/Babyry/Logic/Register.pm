package Babyry::Logic::Register;
use strict;
use warnings;
use utf8;

use parent qw/Babyry::Logic/;

use Babyry::Common;
use Digest::MD5 qw/md5_hex/;

use SQL::Abstract;
use Babyry::Logic::Sequence;
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

    eval {
        $dx->insert('user', {
            user_id    => $user_id,
            created_at => $unixtime,
            updated_at => $unixtime,
        });
        $dx->insert('user_auth', {
            user_id       => $user_id,
            email         => $email,
            password_hash => Babyry::Common->enc_password($password), # TODO more strict
        });
        $dx->insert('register_token', {
            user_id    => $user_id,
            token      => $self->create_token($user_id),
            expired_at => $self->get_expired_at($unixtime),
        });
        $dx->dbh->commit;
    };
    if ($@) {
        $dx->dbh->rollback;
        critf('Failed to register user error:%s email:%s', $@, $email);
        return { error => 'Failed' }; # TODO error handling
    }
}

sub create_token {
    my ($self, $user_id) = @_;
    return md5_hex(time . $user_id . Babyry::Common->config->{register_secret});

}

sub get_expired_at {
    my ($self, $unixtime) = @_;
    return $unixtime + 3600 * 24; # TODO move to config
}

1;

