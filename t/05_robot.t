use strict;
use warnings;

use HTTP::BrowserDetect ();
use List::Util          ();
use Test::More;

my $detect = HTTP::BrowserDetect->new;

my %names = $detect->_robot_names;
my @ids   = $detect->all_robot_ids;
my %fixup = $detect->_robot_ids;
is( scalar @ids, 75, 'correct number of ids' );

foreach my $id (@ids) {
    subtest $id => sub {
        ok( $names{$id}, 'name' );
        unlike(
            $id, qr{[^0-9a-z-]},
            'id contains only lower case letters or dashes'
        );
    };
}

my @tests = $detect->_robot_tests;

for my $test (@tests) {
    my $id = $test->[1];
    subtest "$id check" => sub {
        unlike(
            $id, qr{[^0-9a-z-]},
            "$id contains only lower case letters or dashes"
        );
        ok(
            ( List::Util::any { $_ eq $id } @ids ),
            "$id found in all_robot_ids()"
        );
    };
}

for my $id ( values %fixup ) {
    ok( $names{$id}, "$id exists in names list" );
}

done_testing();
