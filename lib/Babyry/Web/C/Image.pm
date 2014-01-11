package Babyry::Web::C::Image;

use strict;
use warnings;
use parent qw/Babyry::Web::C/;

use Babyry::Logic::Image;

sub image_upload {
    my ($class, $c) = @_;

    my $signature = Babyry::Logic::Image->new->create_signature();

    return $c->render_json($signature);
}

1;

