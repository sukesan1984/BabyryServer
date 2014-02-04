package Babyry::Logic::Invite;

use strict;
use warnings;
use utf8;
use parent qw/Babyry::Base/;

use  Babyry::Service::Invite;

sub execute {
    my ($self, $params) = @_;

    my $service = Babyry::Service::Invite->new;
    return $service->invite($params);
}

1;

