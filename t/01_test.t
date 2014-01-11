use strict;
use warnings;
use utf8;
use lib 't/lib';
use Test::More;
use Test::Babyry::Loader;
use Babyry::Logic;

my $loader = Test::Babyry::Loader::factory('db', [
    +{
        database => 'babyry_main',
        node     => [qw/TEST_W TEST_R/],
    }
])->load;


my $logic = Babyry::Logic->new;
my $dx = $logic->dx('TEST_R');
$dx->select(
    'test_table',
    'count(*)',
)->into(my $count);

is $count, 0;

done_testing;
