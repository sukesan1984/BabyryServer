package Babyry::Logic::Session;
use strict;
use warnings;
use utf8;

use parent qw/Babyry::Logic/;

sub set {
    my ($self, $user_id, $session_id) = @_;

    my $t = time() + 31 * 86400;
    my $dbh = $self->dbh('TEST_W');
    my $sth = $dbh->prepare("delete from session where user_id = ?");
    $sth->execute($user_id);
    $sth = $dbh->prepare("insert into session (user_id, session_id, expired_at) values (?, ?, ?)");
    $sth->execute($user_id, $session_id, $t);
    $dbh->commit();
}

sub get {
    my ($self, $session_id) = @_;

    my $t = time();
    my $dbh = $self->dbh('TEST_R');
    my $sth = $dbh->prepare("select user_id from session where session_id = ? and expired_at > ?");
    $sth->execute($session_id, $t);
    my $row = $sth->fetchrow_hashref();
    my $user_id = $row->{user_id};
    $dbh->disconnect();

    return $user_id;
}

1;

