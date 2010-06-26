use strict;
use warnings;
use Test::More;

BEGIN { plan tests => 16 };

use_ok('Date::Remind::Event');
can_ok('Date::Remind::Event', qw/
    new
    date
    dur
    tag
    body
    end
/);


my $i = Date::Remind::Event->new(
    '2010/08/15 * * * * Adi away'
);

isa_ok( $i, 'Date::Remind::Event');

my $dt = $i->date;
isa_ok( $dt, 'DateTime' );
is( $dt->year, 2010, 'year' );
is( $dt->month, 8, 'month' );
is( $dt->day, 15, 'day' );
is( $dt->hour, 0, 'hour' );
is( $dt->minute, 0, 'minute' );
is( $dt->second, 0, 'seconds' );

my $dur = $i->dur;
isa_ok( $dur, 'DateTime::Duration' );
is( $dur->days, 1, 'day duration' );
is( $dur->minutes, 0, 'minutes' );

my $end = $i->end;
isa_ok( $end, 'DateTime' );

is( "$dt", '2010-08-15T00:00:00', 'start date');
is( "$end", '2010-08-16T00:00:00', 'end date');
