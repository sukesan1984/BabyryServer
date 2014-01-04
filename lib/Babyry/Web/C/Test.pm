package Babyry::Web::C::Test;

use strict;
use warnings;
use parent qw/Babyry::Web::C/;

use Babyry::Logic::Test;

sub index {
    my ($class, $c) = @_;

    my $counter = $c->session->get('counter') || 0;
    $counter++;
    $c->session->set('counter' => $counter);

    my $messages = Babyry::Logic::Test->new->message_get();
    return $c->render('index.tx', {
        counter  => $counter,
        messages => $messages,
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

