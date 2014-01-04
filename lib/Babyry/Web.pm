package Babyry::Web;
use strict;
use warnings;
use utf8;
use parent qw/Babyry Amon2::Web/;
use File::Spec;
use Log::Minimal;
use Carp;

# load plugins
__PACKAGE__->load_plugins(
    'Web::FillInFormLite',
    'Web::JSON',
    '+Babyry::Web::Plugin::Session',
);

# dispatcher
use Babyry::Web::Dispatcher;
sub dispatch {
    return ( Babyry::Web::Dispatcher->dispatch($_[0]) or __exception("response is not generated") );
}

sub __exception {
    my $msg = shift;
    critff($msg);
    croak($msg);
}


# setup view
use Babyry::Web::View;
{
    sub create_view {
        my $view = Babyry::Web::View->make_instance(__PACKAGE__);
        no warnings 'redefine';
        *Babyry::Web::create_view = sub { $view }; # Class cache.
        $view
    }
}


# for your security
__PACKAGE__->add_trigger(
    AFTER_DISPATCH => sub {
        my ( $c, $res ) = @_;

        # http://blogs.msdn.com/b/ie/archive/2008/07/02/ie8-security-part-v-comprehensive-protection.aspx
        $res->header( 'X-Content-Type-Options' => 'nosniff' );

        # http://blog.mozilla.com/security/2010/09/08/x-frame-options/
        $res->header( 'X-Frame-Options' => 'DENY' );

        # Cache control.
        $res->header( 'Cache-Control' => 'private' );
    },
);

1;
