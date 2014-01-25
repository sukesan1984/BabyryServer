#!/usr/bin/env perl

use strict;
use warnings;
use Babyry::Logic;

my $logic = Babyry::Logic->new;
my $dbh = $logic->dbh('BABYRY_MAIN_R');


use YAML;
print Dump $dbh->selectall_arrayref('select * from channel where channel_id < ?', {Slice => {}}, 111);
