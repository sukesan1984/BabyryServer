package Babyry::Web::C::Test;

use strict;
use warnings;
use parent qw/Babyry::Web::C/;

use Log::Minimal;

use Babyry::Logic::Test;
use Babyry::Logic::Session;
use Babyry::Logic::Channel;

sub index {
    my ($class, $c, $p, $v) = @_;

    my $user_id = $c->stash->{'user_id'};

    # redirect if there is no channel
    my $channel_num = Babyry::Logic::Channel->new()->get_channel_num($user_id);
    if(!$channel_num) {
        return $c->redirect('/channel/initial');
    }

    my $messages = Babyry::Logic::Test->new->message_get();
    return $c->render('index.tx', {
        messages => $messages,
        user_id  => $user_id,
    });
}

sub detail {
    my ($class, $c) = @_;
    return $c->render('detail/index.tx', {

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

sub json_validate_sample {
    my ($class, $c, $p, $validator) = @_;

    if ( $validator->has_error ) {
        $validator->set_error_message('test');
        return $c->render_json_validation_error($validator);
    }

    return $c->render_json( +{} );
}


1;

