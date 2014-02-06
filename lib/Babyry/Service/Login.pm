package Babyry::Service::Login;

use strict;
use warnings;
use utf8;
use Log::Minimal;
use parent qw/Babyry::Base/;

use Babyry::Logic::Common;
use Babyry::Model::User_Auth;

sub execute {
    my ($self, $params) = @_;
    my $user_auth = Babyry::Model::User_Auth->new();

    # login
    my $common = Babyry::Logic::Common->new;
    my $enc_pass = $common->enc_password($params->{password});
    my $teng = $self->teng('BABYRY_MAIN_R');
    my $user_id = $user_auth->login(
        $teng, 
        { email => $params->{email}, enc_pass => $enc_pass}
    );
    $teng->disconnect();
infof("user_id : $user_id");
    if ($user_id) {
        # if user_id session set
        return { user_id => $user_id};
    } else {
        # uness user_id redirect to index with error message
        return { user_id => $user_id};
    }

    return;
}

1;
