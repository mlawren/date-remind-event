package Date::Remind::Event;
use strict;
use warnings;
use Carp qw/croak/;
use DateTime;
use DateTime::Duration;
use POSIX qw/floor/;
use constant {
    MINUTES_PER_HOUR => 60,
};

our $VERSION = '0.02';
our $ERROR = '';


sub new {
    my $proto = shift;
    my $text  = shift || croak 'usage: new($text)';

    my ( $date, $special, $tag, $dur, $time, $body )
        = split(/ /, $text, 6);

    my ( $y, $mon, $d ) = split( /\//, $date );

    my $dt = DateTime->new(
        year => $y,
        month => $mon,
        day => $d,
        hour => $time eq '*' ? 0 : floor( $time / MINUTES_PER_HOUR ),
        minute => $time eq '*' ? 0 : $time % MINUTES_PER_HOUR,
    );

    my $dtdur;

    if ( $dur eq '*' ) {
        my $end = $dt->clone;
        $end->add( days => 1 );
        $end->truncate( to => 'day' );
        $dtdur = $end - $dt;
    }
    else {
        $dtdur = DateTime::Duration->new(
            minutes => $dur,
        );

        # There is an extra duration field, not documented in rem2ps
        $body =~ s/.*? //;
    }
    
    my $self  = {
        dt   => $dt,
        tag  => $tag,
        body => $body,
        dur  => $dtdur,
    };

    my $class = ref($proto) || $proto;
    bless( $self, $class);
    return $self;
}

sub date { shift->{dt} };
sub tag { shift->{tag} };
sub body { shift->{body} };
sub dur { shift->{dur} };

sub end {
    my $self = shift;
    return $self->{dt}->clone->add( $self->{dur} );
};


1;

__END__

=head1 NAME

Date::Remind::Event - A 'remind' event object

=head1 SYNOPSIS

  use Date::Remind::Event;

  my $e = Date::Remind::Event->new(
    '2010/08/15 * * * * My Event'
  );

  print 'Start:       ' . $e->date->hms . "\n";
  print 'Duration:    ' . $e->dur->minutes . "min\n";
  print 'Description: ' . $e->body . "\n";

=head1 DESCRIPTION

B<Date::Remind::Event> provides an object interface to L<remind>(1)
generated events.

=head1 CONSTRUCTOR

=head2 new($text) => Date::Remind::Event

Converts $text into a single Date::Remind::Event object.  $text is
expected to be a line of the output produced by the '-s' argument to
L<remind>(1), as defined in the rem2ps(1) manpage under "REM2PS INPUT
FORMAT".

=head1 ATTRIBUTES

=head2 date => DateTime

The start of the event.

=head2 dur => DateTime::Duration

The length of the event.

=head2 end => DateTime

The end of the remind event.

=head2 tag => string

The TAG value of the event.

=head2 body => string

The body of the remind event.

=head1 SEE ALSO

L<DateTime>, L<DateTime::Duration>, L<remind>(1), L<rem2ps>(1)

=head1 AUTHOR

Mark Lawrence E<lt>nomad@null.netE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 Mark Lawrence <nomad@null.net>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

=cut

