package Babyry::Model::User_Auth;

use strict;
use warnings;
use utf8;
use parent qw/Babyry::Base/;


sub create {
    my ($self, $teng, $params) = @_;

    $teng->insert(
        'user_auth',
        {
            user_id     => $params->{user_id},
            email        => $params->{email},
            password_hash  => $params->{password_hash},
            created_at => $params->{created_at},
            updated_at => $params->{updated_at},
        }
    );
}

1;

