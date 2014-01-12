package Babyry::Logic::Common;


use strict;
use warnings;

use parent qw/Babyry/;
use Log::Minimal;
use Digest::SHA qw/hmac_sha256_hex/;

# TODO implement more strictly
sub enc_password {
    my ($self, $password) = @_;
    my $secret = __PACKAGE__->config->{'register_secret'};
    return hmac_sha256_hex($password . $secret);
}

1;

