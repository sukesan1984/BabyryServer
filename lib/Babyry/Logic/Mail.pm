package Babyry::Logic::Mail;
use strict;
use warnings;
use utf8;

use parent qw/Babyry::Logic/;

use Jcode;
use Net::SMTP;
use MIME::Entity;
use Log::Minimal;

use Babyry::Common;

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

    die 'there is no subject or body or address.' if (!$self->{body} || !$self->{address} || !$self->{subject});

    my $smtp_server = '10.0.0.1';

    my $mail_subject = jcode($self->{subject})->jis;
    $mail_subject = jcode($mail_subject)->mime_encode;
    my $mail_to = jcode($self->{address})->jis;
    $mail_to = jcode($mail_to)->mime_encode;
    my $mail_from = jcode($Secret::gmail->{address})->jis;
    $mail_from = jcode($mail_from)->mime_encode;
    my $mail_body = jcode($self->{body})->jis;

    my $err;
    my $oSmtp;
    my $oMime;

    $oSmtp = Net::SMTP->new($smtp_server);

    $oSmtp->mail($mail_from);
    $oSmtp->to($mail_to);
    $oSmtp->data();
    $oMime = MIME::Entity->build(
        From     => $mail_from,
        To       => $mail_to,
        Subject  => $mail_subject,
        Data     => $mail_body
    );
    $oSmtp->datasend($oMime->stringify);
    $oSmtp->dataend();
    $oSmtp->quit;
}

1;

