###
#
# ke_time.pl
#
# Description: 
# This script displays the timestamp in ke to 4 decimal places
#
###

use Irssi;
use strict;

use vars qw($VERSION %IRSSI);

$VERSION="20110308";
%IRSSI = (
  authors     => 'Matt Mayers',
  contact     => 'matt@mattmayers.com',
  name        => 'ke_time',
  description => 'Prints the timestamp in ke',
  license     => 'GPL',
);

my $old_timestamp_format = Irssi::settings_get_str('timestamp_format');

sub ke_time {
  my @now  = localtime;
  my $hour = $now[2];
  my $min  = $now[1];

  my $ke = ($hour * 60 + $min) / 14.4;
  Irssi::command("^set timestamp_format " . sprintf("%0.4f", $ke));
}

sub script_unload {
  my ($script,$server,$witem) = @_;
  Irssi::command("^set timestamp_format $old_timestamp_format");
}

Irssi::timeout_add(1000, 'ke_time', undef);
Irssi::signal_add_first('command script unload', 'script_unload');