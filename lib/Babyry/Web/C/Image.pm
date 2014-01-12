package Babyry::Web::C::Image;

use strict;
use warnings;
use parent qw/Babyry::Web::C/;
use Log::Minimal;
use Babyry::Logic::Image;

sub image_get_signature {
    my ($class, $c) = @_;

    my $signature = Babyry::Logic::Image->new->create_signature();

    return $c->render_json($signature);
}

sub image_get_url {
    my ($class, $c) = @_;

    my $bucket = $c->req->param('bucket');
    my $key = $c->req->param('key');

    my $home_dir = Babyry->base_dir;
    my $ruby = "/home/babyry/.rbenv/shims/ruby $home_dir/lib/Babyry/Logic/get_onetime_url.rb";
    my $url = `$ruby $bucket $key`;
    chomp($url);

    # TODO
    # urlがおかしかったらアップロードが失敗していると見なしてエラー返す

    return $c->render_json(+{url=>$url});
}

1;

