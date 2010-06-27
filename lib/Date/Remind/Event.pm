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

our $VERSION = '0.03';
our $ERROR = '';
our $BFLAG = 0;


sub new {
    my $proto = shift;
    my $text  = shift || croak 'usage: new($text)';

    my ( $date, $special, $tag, $duration, $time, $body )
        = split(/ /, $text, 6);

    my ( $y, $mon, $d ) = split( /\//, $date );

    my $dt = DateTime->new(
        year => $y,
        month => $mon,
        day => $d,
        hour => $time eq '*' ? 0 : floor( $time / MINUTES_PER_HOUR ),
        minute => $time eq '*' ? 0 : $time % MINUTES_PER_HOUR,
    );

    my $dtduration;

    if ( $duration eq '*' ) {
        my $end = $dt->clone;
        $end->add( days => 1 );
        $end->truncate( to => 'day' );
        $dtduration = $end - $dt;
    }
    else {
        $dtduration = DateTime::Duration->new(
            minutes => $duration,
        );

        # Depending on what value of -b remind is called with, the body
        # is prefixed with human-readable duration text. Lets remove
        # (only) that text if it is there.
        if ( $BFLAG != 2 ) {
            $body =~ s/^.*? //;
        }
    }
    
    my $self  = {
        dt   => $dt,
        tag  => $tag,
        body => $body,
        duration  => $dtduration,
    };

    my $class = ref($proto) || $proto;
    bless( $self, $class);
    return $self;
}

sub date { shift->{dt} };
sub tag { shift->{tag} };
sub body { shift->{body} };
sub duration { shift->{duration} };

sub end {
    my $self = shift;
    return $self->{dt}->clone->add( $self->{duration} );
};


1;

__END__

=head1 NAME

Date::Remind::Event - Manipulate 'remind' output with Perl

=head1 SYNOPSIS

  use Date::Remind::Event;
  $Date::Remind::Event::BFLAG = 1;

  my $e = Date::Remind::Event->new(
    '2010/07/06 * * 60 1080 18:00-19:00 My Event'
  );

  print 'Start:       '. $e->date->hms         ."\n";
  print 'Duration:    '. $e->duration->hours   ." hour\n";
  print 'Description: '. $e->body              ."\n";

=head1 DESCRIPTION

B<Date::Remind::Event> provides a Perl object interface to textual
events emitted by L<remind>(1). The expected format of the input is the
same as what is produced by "remind -s" (as defined in the L<rem2ps>(1)
manpage under "REM2PS INPUT FORMAT").

L<remind>(1) produces slightly different output depending on the value
of the -b flag. To make sure that B<Date::Remind::Event> handles this
correctly you should set B<$Date::Remind::Event::BFLAG> to the same
value (default is 0).

=head1 CONSTRUCTOR

=head2 new($text) => Date::Remind::Event

Converts $text into a single Date::Remind::Event object.

=head1 ATTRIBUTES

=head2 date => DateTime

The start of the event.

=head2 duration => DateTime::Duration

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

