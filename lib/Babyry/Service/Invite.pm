package Babyry::Service::Invite;

use strict;
use warnings;
use utf8;
use parent qw/Babyry::Base/;

use constant {
    INVITE_METHOD_EMAIL => 'email',
};

sub execute {
    my ($self, $params) = @_;

    my $model = Babyry::Model::InviteList->new;

    my $row = eval { $model->create($params); };
    if ( my $e = $@ ) {
        croak($e);
    }

    if ( $invite_method eq INVITE_METHOD_EMAIL ) {
        my $mail_body   = $self->_get_invite_mail_body( $row->{invite_code} );
        my $model_email = Babyry::Model::Mail->new;
        eval { $model_email->send(); };
        if ( my $e = $@ ) {
            croak($e);
        }
        return;
    }
    return $text;
}

sub _get_invite_mail_body {
    my ($self, $invite_code) = @_;

    # TODO implement
}

1;

