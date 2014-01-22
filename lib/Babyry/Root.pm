package Babyry::Root;
use strict;
use warnings;
use utf8;
use parent qw/Babyry/;

use Babyry::Logic::Session;

sub certify {
    my ($self, $session_id) = @_;

    my $user_id = Babyry::Logic::Session->new->get($session_id) || 0;

    return { user_id => $user_id };
}


1;

