package Hardware::Awtrix;
use strict;
use utf8;
use open qw(:std :utf8);

BEGIN {
  use Exporter;
  use vars qw($VERSION @ISA @EXPORT);
  @ISA = qw(Exporter);

  $VERSION = '0.001';

  @EXPORT = qw(publish);
}

use JSON;
use IPC::Cmd qw(run);

my %message = (
  host     => '',
  topic    => '',
  user     => '',
  password => '',
  retain   => 0,
  message  => '',
);

# Ability to provide us with a hash of settings
# directly in a use statement
my $params = \%message;
sub import {
  goto &Exporter::import if ref $_[1] ne 'HASH';
  $params = splice @_, 1, 1;

  # let size be an alias to width
  if($params->{size} and not $params->{width}) {
    $message{width} = $params->{size};
  }

  # replace user provided args in options hash
  # while keeping what's not provided
  for my $p(keys(%{ $params })) {
    $message{$p} = $params->{$p};
  }

  goto &Exporter::import;
}


sub publish {
  my $m = shift;

  # be nice and convert the hash to json if it's not already
  $m = JSON->new->utf8->encode($m) if ref $m eq 'HASH';

  run(
    command => [
      'mosquitto_pub',
      '-h', $message{host},
      '-m', $message{message} ? $message{message} : "$m",
      '-t', $message{topic},
      '-u', $message{user},
      '-P', $message{password},
    ],
    verbose => 0,
  );
}




__END__

=pod

=head1 NAME

  Hardware::Awtrix - Perl interface to Awtrix

=head1 SYNOPSIS

  use Hardware::Awtrix {
    host     => $ENV{MQTT_HOST},
    user     => $ENV{MQTT_USER},,
    password => $ENV{MQTT_PASS},
    topic    => $ENV{AWTRIX_NOTIFY_TOPIC},
  };

  my %message = (
    text     => 'Hello world!',
    color    => '#ffff00',
    icon     => 1,
    rainbow  => 'true',
    duration => 15,
  );

  publish(\%message);

=head1 DESCRIPTION

Simple module that allows you to send messages to your esp32-based
awtrix device using mqtt.

The topic would be somethins similar to C<awtrix_d4924/notify>.

The icons need to be downloaded to your device, and then referenced by id.
You can see those ids in the web interface of your flashed clock.

Recommended to disable all the apps on the clock itself. This way, the clock
will be blank until it receives a message.

=head1 EXPORTS

  publish

=head1 FUNCTIONS

=head2 publish(\%message)

=head1 NOTES

Would rather use the L<Net::MQTT::Simple> module but I had zero luck getting it
to work with my specific broker.

Therefore, the L<mosquitto_pub> command is used for now.

=head1 TODO

Figure out all of the options that can be passed to the awtrix device.

=head1 REPORTING BUGS

Report bugs and/or feature requests on rt.cpan.org, the repository issue tracker
or directly to L<m@japh.se>

=head1 AUTHOR

  Magnus Woldrich
  CPAN ID: WOLDRICH
  m@japh.se
  japh@irc.libera.chat #perl
  L<~/|http://japh.se>
  L<git|http://github.com/trapd00r>

=head1 CONTRIBUTORS

None required yet.

=head1 COPYRIGHT

Copyright 2023- B<THIS MODULE>s L</AUTHOR> and L</CONTRIBUTORS> as listed above.

=head1 LICENSE

This library is free software; you may redistribute it and/or modify it under
the same terms as Perl itself.

=cut
