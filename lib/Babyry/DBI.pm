package Babyry::DBI;

use 5.014;
use warnings;

use Log::Minimal;
use DBIx::DBHResolver;
use Babyry;
use Babyry::Common;

our $resolver;
{
    my $env = $ENV{APP_ENV} || 'local';

    $resolver = DBIx::DBHResolver->new;

    my $config = Babyry::Common->config;
    $resolver->config($config->{db});
}

sub resolver {
    my ($self) = @_;
    return $resolver ||
        croakf("not exists DBHResolver");
}

1;
