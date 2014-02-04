package Babyry::Web::C::Invite;

use strict;
use warnings;
use parent qw/Babyry::Web::C/;
use Log::Minimal;
use Babyry::Logic::Login;

sub index {
    my ($class, $c) = @_;

    return $c->render('invite/index.tx', {});
}

sub execute {
    my ($class, $c) = @_;

    my $params = {
        $email         => $c->req->param('email')         || '',
        $invite_method => $c->req->param('invite_method') || '',
        $invitee_user  => $c->stash->{user_id}            || 0,
    };
    my $logic = Babyry::Logic::Invite->new;

    my $ret = eval { $logic->execute($params); };
    if ( my $e = $@ ) {
        critf('Failed to invite params:%s error:%s', $self->dump($params), $e);
        $c->render_500();
    }
    if ( $ret->{error} ) {
        critf('Failed to invite params:%s error:%s', $self->dump($params), $self->dump( $ret->{error} ));
        $c->render_500();
    }

    $c->render('invite/completed.tt', +{});
}

1;

