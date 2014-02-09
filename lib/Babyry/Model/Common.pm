package Babyry::Model::Common;


use strict;
use warnings;

use parent qw/Babyry::Base/;
use Digest::SHA qw/hmac_sha256_hex/;

# TODO implement more strictly
sub enc_password {
    my ($self, $password) = @_;
    my $secret = Babyry::Common->get_key_vault('register_secret');
    return hmac_sha256_hex($password . $secret);
}

1;

