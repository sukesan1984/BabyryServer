package Babyry::ConfigLoader;

use strict;
use warnings;
use utf8;

use Babyry;
use Class::Accessor::Lite (
    ro  => [qw/config/],
);

my $CONFIG;

sub new {
    my $class = shift;
    my $env   = shift;

    $CONFIG ||= _load($env);

    my $self = { config => $CONFIG };
    bless $self, $class;
    $self;
}

sub _load {
    my ($env) = @_;

    my $config_path = sprintf('%s/config/%s.conf', Babyry->base_dir, $env);
    my $config = do($config_path);
    return $config;
}

1;

