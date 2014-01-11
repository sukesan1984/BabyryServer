package Babyry::Logic::Image;

use strict;
use warnings;

use utf8;
use JSON qw/encode_json/;
use MIME::Base64;
use Digest::SHA1;
use Digest::MD5;
use Digest::SHA qw(sha1 sha1_hex sha1_base64 hmac_sha1);

use parent qw/Babyry::Logic/;

use SQL::Abstract;

my $ACCESS_KEY = $ENV{AWS_SECRET_ACCESS_KEY};
my $KEY_ID = $ENV{AWS_ACCESS_KEY_ID};    

sub create_signature {
    my ($self) = @_;

    my $bucket = 'bebyry-image-upload';
    my $path = 'test/test.jpg';
    my $policy_document = {
        expiration => '2014-01-31T00:00:00Z',
        conditions => [
            { bucket => $bucket },
            [ "starts-with", "\$key", "test/" ],
            { "acl" => "private" },
            { "success_action_redirect" => "http://localhost/success.html" },
            [ "starts-with", "\$Content-Type", "" ],
            [ 'content-length-range', 0, 1073741824 ],
        ],
    };
    my $policy_json = encode_json($policy_document);

    my $policy = encode_base64($policy_json);
    $policy =~ s/\n//g;

    my $sha1 = Digest::SHA1->new;
    my $key = $ACCESS_KEY;

    my $digest = hmac_sha1($policy, $key);
    my $signature = encode_base64($digest);
    $signature =~ s/\n//g;

    my $res = {
        key_id => $KEY_ID,
        policy => $policy,
        signature => $signature,
    };
    return $res;
}

1;

