package Babyry::Web::C::Image;

use strict;
use warnings;
use parent qw/Babyry::Web::C/;
use Log::Minimal;
use Data::Dumper;
use Imager;

use Babyry::Logic::Image;
use Babyry::Logic::Session;

my $image = Babyry::Logic::Image->new();

sub image_upload_sample_form {
    my ($class, $c) = @_;

    $c->render('/image/upload_sample.tx');
}

sub image_upload {
    my ($class, $c) = @_;

    my $upload = $c->req->uploads->get_all('file');
    my $path = $upload->path;

    my $img = Imager->new;
    $img->read(file => $upload->path) or warn $img->errstr;
    print $img->getwidth() . "\n";
    print $img->getheight() . "\n";

    my $time = time();
    my $session = Babyry::Logic::Session->new();
    my $user_id = $session->get($c->session->get('session_id'));

    if ($path =~ m{\.(jpg|jpeg)$}) {
        $img->write(file => "/data/image/${user_id}_${time}.jpg", jpegquality => 20) or warn $img->errstr;
    }

    return $c->render_json(+{path=>$path});
}

1;

