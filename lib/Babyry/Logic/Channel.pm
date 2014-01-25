package Babyry::Logic::Channel;

use strict;
use warnings;
use utf8;

use Log::Minimal;
use Encode;

use parent qw/Babyry::Logic/;
use Babyry::Logic::Sequence;

sub create {
    my ($self, $channel_name, $user_id) = @_;

    my $t = time();
    my $sequence = Babyry::Logic::Sequence->new();
    my $channel_id = $sequence->get_id('seq_channel');

    my $dbh = $self->dbh('TEST_W');
    #$dbh->do("set names utf8");
    # create channel
    my $sth = $dbh->prepare("insert into channel (channel_id, name, created_by, disabled, updated_at, created_at) values (?, ?, ?, ?, ?, ?)");
warnf($channel_name);
    $sth->execute($channel_id, encode('UTF-8', $channel_name), $user_id, 0, $t, $t);
    $dbh->commit;

    # make mapping
    $sth = $dbh->prepare("insert into user_channel_map (user_id, channel_id) values (?, ?)");
    $sth->execute($user_id, $channel_id);
    $dbh->commit;

    $dbh->disconnect();

    return 1;
}

sub get_channel_num {
    my ($self, $user_id) = @_;

    my $dbh = $self->dbh('TEST_R');
    my $sth = $dbh->prepare("select count(*) as num from user_channel_map where user_id = ?");
    $sth->execute($user_id);
    my $row = $sth->fetchrow_hashref();
    my $num = $row->{num};
    $sth->finish();
    $dbh->disconnect();

    return $num;
}

1;

