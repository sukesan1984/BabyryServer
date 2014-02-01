package Babyry::Web::C::Login;

use strict;
use warnings;
use parent qw/Babyry::Web::C/;
use Log::Minimal;
use Babyry::Logic::Login;
use Babyry::Logic::Session;

sub index {
    my ($class, $c) = @_;

    return $c->render('login/index.tx');
}

sub execute {
    my ($class, $c) = @_;

    my $email    = $c->req->param('email');
    my $password = $c->req->param('password');

    my $login = Babyry::Logic::Login->new;
    my $user_id = $login->login($email, $password);

    if ($user_id) {
        my $session = Babyry::Logic::Session->new();
        my $session_id = $session->create($user_id);
        $c->session->set('session_id' => $session_id);
        $session->set($user_id, $session_id);
        return $c->redirect('/');
    } else {
        return $c->render('/login/index.tx', {error => 'INVALID_PASSWORD'});
    }
}

sub logout {
    my ($class, $c) = @_;

    $c->session->remove('session_id');
    $c->redirect('/login');
}

1;

