package Babyry::Web::C::Login;

use strict;
use warnings;
use parent qw/Babyry::Web::C/;
use Log::Minimal;
use Babyry::Logic::Login;

sub index {
    my ($class, $c) = @_;

    my $session = $c->session->get('babyry_session') || '';
    my $login = Babyry::Logic::Login->new;
    if ( my $user_id = $login->certify($session) ) {
        $c->redirect('/');
    }

    return $c->render('login/index.tt');
}

sub execute {
    my ($class, $c) = @_;

    my $email    = $c->req->param('email');
    my $password = $c->req->param('password');
    my $password_confirm = $c->req->param('password_confirm');

    if ($password != $password_confirm) {
        return $c->render('/login/index.tt', {error => 'UNMATCH_CONFIRM'});
    }

    my $login = Babyry::Logic::Login->new;
    my $user_id = $login->login($email, $password);

    if ($user_id) {
        return $c->redirect('/');
    } else {
        return $c->render('/login/index.tt', {error => 'INVALID_PASSWORD'});
    }
}

1;

