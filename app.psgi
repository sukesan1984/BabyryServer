#!perl
use strict;
use utf8;
use File::Spec;
use File::Basename;
use lib File::Spec->catdir(dirname(__FILE__), 'lib');
use Plack::Builder;

use Babyry::Web;
use Babyry;
use URI::Escape;
use File::Path ();

my $app = builder {
    enable 'Plack::Middleware::Static',
        path => qr{^(?:/static/)},
        root => File::Spec->catdir(dirname(__FILE__), '..');
    enable 'Plack::Middleware::Static',
        path => qr{^(?:/robots\.txt|/favicon\.ico)$},
        root => File::Spec->catdir(dirname(__FILE__), '..', 'static');
    enable 'Plack::Middleware::ReverseProxy';
    enable_if { $ENV{PLACK_ENV} ne 'production' } 'BetterStackTrace',
	        application_caller_subroutine => 'Amon2::Web::handle_request';

    Babyry::Web->to_app();
};
