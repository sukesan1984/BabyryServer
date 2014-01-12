package Babyry::Web::C::Register;

use strict;
use warnings;
use parent qw/Babyry::Web::C/;
use Log::Minimal;
use Babyry::Logic::Login;
use Babyry::Logic::Register;

sub index {
    my ($class, $c) = @_;

    my $session = $c->session->get('babyry_session') || '';
    my $login = Babyry::Logic::Login->new;
    if ( my $user_id = $login->certify($session) ) {
        $c->redirect('/');
    }

    return $c->render('register/index.tt', {});
}

sub execute {
    my ($class, $c) = @_;

    my $email    = $c->req->param('email');
    my $password = $c->req->param('password');
    my $password_confirm = $c->req->param('password_confirm');

    # validation
    $c->render('register/index.tt', {error => 'INVALID_PASSWORD'})
        if $class->validate_password($password);
    $c->render('register/index.tt', {error => 'INCONSISTENT_PASSWORD'})
        if $class->validate_password_inconsisence($password, $password_confirm);

    my $logic = Babyry::Logic::Register->new;
    $logic->execute({
        email    => $email,
        password => $password,
    });
    $c->redirect('/invite/email');
}

# TODO move to Filter
sub validate_password {
    my ($self, $password) = @_;
    # TODO validate used chars
    #
    # empty
    # too short
    # not email format
    # already registed
}

sub validate_password_inconsisence {
    my ($self, $password, $password_confirm) = @_;
    return 1 if $password ne $password_confirm;
}

1;

