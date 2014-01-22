package Babyry::Logic::Login;
use strict;
use warnings;
use utf8;

use Log::Minimal;

use parent qw/Babyry::Logic/;
use Babyry::Logic::Common;

sub login {
    my ($self, $email, $password) = @_;

    my $common = Babyry::Logic::Common->new;
    my $enc_pass = $common->enc_password($password);

    my $dbh = $self->dbh('BABYRY_MAIN_R');
    my $sth = $dbh->prepare("select * from user_auth where email = ? and password_hash = ?");
    $sth->execute($email, $enc_pass);
    my $row = $sth->fetchrow_hashref();
    my $user_id = $row->{user_id};

    if ($user_id) {
        return $user_id;
    } else {
        return 0;
    }
}

1;

