package Babyry::Logic::Test;
use strict;
use warnings;
use utf8;

use parent qw/Babyry::Logic/;

use SQL::Abstract;

sub message_get {
    my ($self) = @_;

    $self->create_table();

    my $dx = $self->dx('TEST_R');
    my $rs = $dx->select(
        'test_message',
        [qw/message/]
    );
    my @messages = $rs->flat;
    return \@messages;
}

sub message_add {
    my ($self, $message) = @_;

    $self->create_table();

    my $sqla = SQL::Abstract->new;
    my ($stmt, @bind) = $sqla->insert(
        'test_message',
        { message => $message }
    );
    my $dbh = $self->dbh('TEST_W');
    my $sth = $dbh->prepare($stmt);
    $sth->execute(@bind);
    $dbh->commit;
}

sub create_table {
    my ($self) = @_;

    my $dbh = $self->dbh('TEST_W');
    my $create_sql = <<'SQL';
    CREATE TABLE IF NOT EXISTS test_message (
        message TEXT NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8
SQL

    $dbh->do($create_sql);
    $dbh->commit;
}

1;

