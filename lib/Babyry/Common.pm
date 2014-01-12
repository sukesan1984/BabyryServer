package Babyry::Common;

use warnings;

use parent qw/Babyry/;
use Log::Minimal;
use Babyry::ConfigLoader;
use Digest::SHA qw/hmac_sha256_hex/;

sub env {
    return 'local' if !$ENV{APP_ENV};
    return $ENV{APP_ENV} eq 'production'  ?  'production'  :
           $ENV{APP_ENV} eq 'development' ?  'development' :
                                             'local'       ;
}

sub config { Babyry::ConfigLoader->new(env())->config }

# TODO implement more strictly
sub enc_password {
    my ($password) = @_;
    my $secret = __PACKAGE__->config->{'register_secret'};
    return hmac_sha256_hex($password . $secret);
}

1;

