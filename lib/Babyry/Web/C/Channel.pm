package Babyry::Web::C::Channel;

use strict;
use warnings;

use parent qw/Babyry::Web::C/;
use Log::Minimal;

use Babyry::Logic::Channel;

my $channel = Babyry::Logic::Channel->new();

sub initial {
    my ($class, $c) = @_;

    $c->render('/channel/initial.tx');
}

sub create {
    my ($class, $c) = @_;

    my $channel_name = $c->req->param('channel_name');
    $channel->create($channel_name, $c->stash->{user_id});
    $c->redirect('/');
}

sub join {
    my ($class, $c) = @_;

    $c->redirect('/');
}

1;

