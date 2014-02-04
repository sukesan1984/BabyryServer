package Babyry::Model::User;

use strict;
use warnings;
use utf8;
use parent qw/Babyry::Base/;


sub create {
    my ($self, $teng, $params) = @_;

    $teng->insert(
        'user',
        {
            user_id     => $params->{user_id},
            created_at  => $params->{created_at},
            updated_at  => $params->{updated_at},
        }
    );
}

1;

