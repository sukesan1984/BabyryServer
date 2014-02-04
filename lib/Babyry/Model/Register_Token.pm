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

1;

