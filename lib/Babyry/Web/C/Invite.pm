package Babyry::Web::C::Invite;

use strict;
use warnings;
use parent qw/Babyry::Web::C Babyry::Base/;
use Log::Minimal;
use Babyry::Logic::Invite;

sub index {
    my ($self, $c) = @_;

    return $c->render('invite/index.tx', {});
}

sub execute {
    my ($self, $c) = @_;

    warnf("Web/C/Invite");

    return $c->render_500() if ! $c->stash->{user_id};

    my $params = {
        user_id       => $c->stash->{user_id},
        invite_method => $c->req->param('invite_method'),
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
    $c->render('invite/completed.tx', $ret);
}

1;

