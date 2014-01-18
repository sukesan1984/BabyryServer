package Babyry::Logic::AmazonSES;
use strict;
use warnings;
use utf8;

use AWS::CLIWrapper;
use Jcode;

use parent qw/Babyry::Logic/;

sub set_subject {
    my ($self, $subject) = @_;
    $self->{subject} = $subject;
}

sub set_body {
    my ($self, $msg) = @_;
    $self->{body} = $msg;
}

sub set_address {
    my ($self, $address) = @_;
    $self->{address} = $address;
}

sub send_mail {
    my ($self) = @_;
    return 'there is no subject or body or address.' if (!$self->{body} || !$self->{address} || !$self->{subject});

    my $aws = AWS::CLIWrapper->new(
        region => 'us-east-1',
    );

    my $mail_subject = jcode($self->{subject})->jis;
    $mail_subject = jcode($mail_subject)->mime_encode;
    my $mail_to = jcode($self->{address})->jis;
    $mail_to = jcode($mail_to)->mime_encode;
    my $mail_from = jcode($Secret::gmail->{address})->jis;
    $mail_from = jcode($mail_from)->mime_encode;
    my $mail_body = jcode($self->{body})->jis;

    my $params = {
        from => 'meaning.sys@gmail.com',
        to => $mail_to,
        subject => $mail_subject,
        text => $mail_body,
    };

    my $res = $aws->ses('send-email', $params);
    if(!$res) {
        return "$AWS::CLIWrapper::Error->{Code}, $AWS::CLIWrapper::Error->{Message}"
    }
    return 0;
}

1;
