package Babyry::DBI;

use 5.014;
use warnings;

use Log::Minimal;
use DBIx::DBHResolver;
use Babyry;

our $resolver;
{
    my $env = $ENV{APP_ENV} || 'local';
    my $db_yamls = sprintf Babyry->base_dir . '/config/db/%s.yaml', $env;

    $resolver = DBIx::DBHResolver->new;

    # load YAML
    my $db_conf_path = sprintf Babyry->base_dir . '/config/db/%s.yaml', $env;
    die sprintf("db config not found in: %s", $db_conf_path) unless -f $db_conf_path;
    $resolver->load($db_conf_path);
}

sub resolver {
    my ($self) = @_;
    return $resolver ||
        croakf("not exists DBHResolver");
}

1;
