package Babyry::Web::C::Regist;

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

    return $c->render('regist/index.tt', {});
}


1;

