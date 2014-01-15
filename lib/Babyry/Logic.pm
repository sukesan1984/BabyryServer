package Babyry::Logic;
use strict;
use warnings;
use utf8;
use parent qw/Babyry/;

use Babyry::DBI;
use DBIx::Simple;
use Teng::Schema::Loader;

sub dbh {
    my ($self, $label) = @_;

    my $resolver = Babyry::DBI->resolver();
    my $dbh = $resolver->connect($label);
    $dbh;
}

sub dx {
    my ($self, $label) = @_;

    my $dbh = $self->dbh($label);
    my $dx = DBIx::Simple->new($dbh);
    return $dx;
}

sub teng {
    my ($self, $label) = @_;
    $self->{teng} ||= Teng::Schema::Loader->load(
        namespace => 'Babyry::Teng',
        dbh       => $self->dbh($label),
    );
    $self->{teng};
}

1;

