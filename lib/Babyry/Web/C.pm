package Babyry::Web::C;

use strict;
use warnings;
use utf8;
use parent qw/Babyry::Web/;

sub set_validate_data_to_flash {
    my ($class, $c, $validator, $attr) = @_;

    $attr ||= +{};
    my $message_data = +{
        %$attr,
        form_messages => $validator->get_messages,
        params        => $c->req->parameters->as_hashref,
        #message       => $c->l("messages:validate_fail"),
        warning       => 1,
    };

    $c->flash($message_data);
}


1;

