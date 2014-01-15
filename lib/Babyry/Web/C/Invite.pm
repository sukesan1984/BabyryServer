package Babyry::Web::C::Invite;

use strict;
use warnings;
use parent qw/Babyry::Web::C/;
use Log::Minimal;
use Babyry::Logic::Login;

sub email {
    my ($class, $c) = @_;

    return $c->render('invite/email.tt', {});
}


1;

