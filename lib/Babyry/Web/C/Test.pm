package Babyry::Web::C::Test;

use strict;
use warnings;
use parent qw/Babyry::Web::C/;

use Log::Minimal;

use Babyry::Logic::Test;
use Babyry::Logic::Session;

sub index {
    my ($class, $c) = @_;

    my $session = Babyry::Logic::Session->new();
    my $user_id = $session->get($c->session->get('session_id'));
    my $messages = Babyry::Logic::Test->new->message_get();
    return $c->render('index.tt', {
        messages => $messages,
        user_id  => $user_id,
    });
}

sub reset_counter {
    my ($class, $c) = @_;
    $c->session->remove('counter');
    return $c->redirect('/');
}

sub account_logout {
    my ($class, $c) = @_;
    $c->session->expire();
    return $c->redirect('/');
}

sub message_add {
    my ($class, $c) = @_;
    my $logic = Babyry::Logic::Test->new;

    my $message = $c->req->param('message');
    $logic->message_add($message);
    return $c->redirect('/');
}


1;

