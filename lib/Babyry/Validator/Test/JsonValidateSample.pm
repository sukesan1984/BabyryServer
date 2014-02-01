package Babyry::Validator::Test::JsonValidateSample;

use strict;
use warnings;
use parent qw/Babyry::Validator/;

sub form_validator_conf {
    +{
        name_f => [qw/EMAIL_LOOSE INT NOT_NULL/],
        name_l => [qw/NOT_NULL INT EMAIL_LOOSE/],
    };
}

sub do_logic_validate {
}

1;

