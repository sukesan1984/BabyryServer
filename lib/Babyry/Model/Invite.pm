package Babyry::Model::Invite;

use strict;
use warnings;
use utf8;
use parent qw/Babyry::Base/;
use String::Random;
use Log::Minimal;

use constant {
    INVITE_CODE_LENGTH => 8,
};

sub create {
    my ($self, $params, $now) = @_;

    $now ||= time;

    my $invite_code = '';
    my $row;
    for (1 .. 3) {

        $row = eval {
            $self->teng->insert(
                'invite',
                {
                    user_id     => $params->{user_id},
                    invite_code => _create_invite_code(),
                    created_at  => $now,
                }
            );
        };
        if ($@ || ! $row) {
            warnf('insert into invite error:%s', $@ || '');
            next;
        }
        last;
    }

    if (! $row ) {
        critf('Failed to invite params:%s error:%s', $self->dump($params), $@);
    }
use YAML;
warnf( Dump $row->get_columns );
    return $row->get_columns;
}

sub _create_invite_code {
    return String::Random->new->randregex(sprintf('[A-Za-z0-9]{%s}',  INVITE_CODE_LENGTH));
}

1;

