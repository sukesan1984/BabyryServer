package Babyry::Web::C::Image;

use strict;
use warnings;
use parent qw/Babyry::Web::C/;
use Log::Minimal;
use Babyry::Logic::Image;

my $image = Babyry::Logic::Image->new();

sub image_get_signature {
    my ($class, $c) = @_;

    my $signature = $image->create_signature();

    return $c->render_json($signature);
}

sub image_after_upload {
    my ($class, $c) = @_;

    my $bucket = $c->req->param('bucket');
    my $key = $c->req->param('key');

    $image->set_image_id($bucket, $key);

    my $url = $image->get_image_url($bucket, $key);
    # TODO
    # urlがおかしかったらアップロードが失敗していると見なしてエラー返す

    return $c->render_json(+{url=>$url});
}

1;

