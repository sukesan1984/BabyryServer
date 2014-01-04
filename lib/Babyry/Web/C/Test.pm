package Babyry::Web::C::Test;

use strict;
use warnings;
use parent qw/Babyry::Web::C/;

sub index {
    my ($class, $c) = @_;

    my $counter = $c->session->get('counter') || 0;
    $counter++;
    $c->session->set('counter' => $counter);
    return $c->render('index.tx', {
        counter => $counter,
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


1;

