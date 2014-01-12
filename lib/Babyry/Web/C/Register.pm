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

# memo ここでは既にsessionを持っているかは見ない
#      受け取り可能なemailアドレスかどうかのチェックができればいいため
sub verify {
    my ($class, $c) = @_;

    my $token = $c->req->param('token');
    if ( ! $token ) {
        return $c->redirect('/');
    }

    my $logic = Babyry::Logic::Register->new;
    my $error = eval { $logic->verify($token) };
    if ($@) {
        return $c->res_500();
    }
    if ( $error ) {
        # $errorには'EXPIRED' or 'NOT_EXIST'が返る
        # 既にverify済の場合はerrorにはならない
        return $c->render('register/verify_error.tt', { error_message => $error });
    }
    # 一回sessionをクリアしてからloginページへリダイレクト
    $c->session->remove('session_id');
    $c->redirect('/login');
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

