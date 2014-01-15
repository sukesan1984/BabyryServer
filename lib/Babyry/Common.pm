package Babyry::Common;

use strict;
use warnings;

use parent qw/Babyry/;
use Log::Minimal;
use Babyry::ConfigLoader;

sub env {
    return 'local' if !$ENV{APP_ENV};
    return $ENV{APP_ENV} eq 'production'  ?  'production'  :
           $ENV{APP_ENV} eq 'development' ?  'development' :
                                             'local'       ;
}

sub config { Babyry::ConfigLoader->new(env())->config }

1;

