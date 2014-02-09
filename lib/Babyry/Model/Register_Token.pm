package Babyry::Model::Register_Token;

use strict;
use warnings;
use utf8;
use parent qw/Babyry::Base/;


sub create {
    my ($self, $teng, $params) = @_;

    $teng->insert(
        'register_token',
        {
            user_id     => $params->{user_id},
            token       => $params->{token},
            expired_at  => $params->{expired_at},
        }
    );
}

sub get_user_id {
    my ($self, $teng, $params) = @_;

    my $res = $teng->single(
        'register_token',
        {
            token       => $params->{token},
        }
    );

    return $res->user_id;
}

sub delete {
    my ($self, $teng, $params) = @_;

    $teng->delete(
        'register_token',
        {
            token => $params->{token},
        },
    );

    return;
}


1;

