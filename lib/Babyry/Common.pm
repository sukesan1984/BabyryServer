package Babyry::Common;

use warnings;

use parent qw/Babyry/;
use Log::Minimal;
use Babyry::ConfigLoader;
use Digest::MD5 qw/md5_hex/;

sub env {
    my ($self) = @_;

    return 'local' if !$ENV{APP_ENV};
    return $ENV{APP_ENV} eq 'production'  ?  'production'  :
           $ENV{APP_ENV} eq 'development' ?  'development' :
                                             'local'       ;
}

sub config { Babyry::ConfigLoader->new(env())->config }

sub enc_password {
    my ($self, $password) = @_;
    my $secret = $self->config('regist_secret');
    return md5_hex($password . $secret);
}

1;

