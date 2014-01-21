#!/usr/bin/env perl

use strict;
use warnings;

use File::Spec;
use File::Basename;
use lib File::Spec->catdir(dirname(__FILE__), '../../lib');
# temp
$ENV{APP_ENV} = "development";

use Log::Minimal;
use AWS::CLIWrapper;

use Babyry::Logic::Image;

my $aws = AWS::CLIWrapper->new();

my $BUCKET = 'bebyry-image-upload';
my $IMAGE_DIR = '/data/image';

while(1) {
    opendir my $dh, $IMAGE_DIR or die "$!:$IMAGE_DIR";
    while (my $file = readdir $dh) {
        my $path = "$IMAGE_DIR/$file";
        next unless ($path =~ m{^$IMAGE_DIR/\d+_\d+\.(jpg|jpeg|png)$});
        infof("send $path");
        &send_to_s3($path, $file);
    }
    closedir $dh;
    sleep 1;
}

sub send_to_s3 {
    my $path = shift;
    my $file = shift;
    
    my $params = +{
        body => $path,
        key => $file,
        bucket => $BUCKET,
    };
    my $res = $aws->s3api('put-object', $params);
    if (!$res) {
        warnf( $AWS::CLIWrapper::Error->{Code});
        warnf( $AWS::CLIWrapper::Error->{Message});
        return;
    }

    my $local_size = -s $path;
    my $s3_size = 0;
    $params = +{
        prefix => $file,
        bucket => $BUCKET,
    };
    $res = $aws->s3api('list-objects', $params);
    if($res) {
        $s3_size = $res->{Contents}[0]->{Size};
        if($local_size == $s3_size) {
            if (&register_db($file)) {
                unlink($path);
            }
        }
    } else {
        warnf( $AWS::CLIWrapper::Error->{Code});
        warnf( $AWS::CLIWrapper::Error->{Message});
    }
    return;
}

sub register_db {
    my $file = shift;
    
    my $image = Babyry::Logic::Image->new();
    my $res = $image->set_image_info($file);
    infof("failed to register db.")if (!$res);
    return $res;
}
