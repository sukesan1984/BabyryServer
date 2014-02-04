package Babyry::Model::Invite;

use strict;
use warnings;
use utf8;
use parent qw/Babyry::Base/;
use String::Random;

use constant {
    INVITE_CODE_LENGTH => 8,
};

sub create {
    my ($self, $params, $now) = @_;

    $now ||= time;

    my $teng = $self->teng('BABYRY_MAIN_W');

    my $invite_code = '';
    my $row;
    for (1 .. 3) {

        $row = eval {
            $teng->insert(
                'invite',
                {
                    user_id     => $params->{user_id},
                    email       => $params->{email},
                    invite_code => $self->create_invite_code,
                    created_at  => $now,
                }
            );
        };
        if ($@ || ! $row) {
            next;
        }
        last;
    }
    return $row->get_columns;
}

sub create_invite_code {
    my $self = shift;

    return String::Random->new->randregex("[A-Za-z0-9]{ INVITE_CODE_LENGTH() }");
}

1;

