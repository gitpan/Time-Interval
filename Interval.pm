###################################################
## Interval.pm		(Time::Interval)
## Andrew N. Hicox	<andrew@hicox.com>
## http://www.hicox.com
##
## a module for dealing with time intervals
###################################################


## Global Stuff ###################################
package Time::Interval;
use strict;
require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(&parseInterval &convertInterval &getInterval);
our $VERSION = "1.0.1";
#what everything is worth in seconds
our %intervals = (
	'days'		=> ((60**2) * 24),
	'hours'		=> (60 **2),
	'minutes'	=> 60,
	'seconds'	=> 1
);


## getInterval ####################################
sub getInterval {
	my $date1 = shift();
	my $date2 = shift();
	my $string = shift();
	if (! $string){ $string = 0; }
	if ( (! $date1) || (! $date2) ){
		warn ("two dates are required for the getInterval method");
		return (undef);
	}
	require Date::Parse;
	foreach ($date1, $date2){
		$_ = Date::Parse::str2time($_) || do {
			warn ("failed to parse date: $!\n");
			return (undef);
		};
	}
	my $data = parseInterval(
		seconds	=> abs($date1 - $date2),
		String	=> $string
	);
	return ($data);
}


## convertInterval ################################
#'days'		=> $num,
#'hours'	=> $num,
#'minutes'	=> $num,
#'seconds'	=> $num,
#'ConvertTo'	=> 'days'|'hours'|'minutes'|'seconds'
sub convertInterval {
	my %p = @_;
	#ConvertTo, default is seconds
	exists($p{'ConvertTo'}) || do {
		$p{'ConvertTo'} = "seconds";
		warn ("convertInterval: using default ConvertTo (seconds)") if $p{'Debug'};
	};
	#convert everything to seconds
	my $seconds = 0;
	foreach ("days","hours","minutes","seconds"){
		if (exists($p{$_})){ $seconds += ($intervals{$_} * $p{$_}); }
	}
	#send it back out into the desired output
	return (($seconds/$intervals{$p{'ConvertTo'}}));
}


## parseInterval ##################################
#'days'		=> $num,
#'hours'	=> $num,
#'minutes'	=> $num,
#'seconds'	=> $num,
sub parseInterval {
	my %p = @_;
	#convert everything to seconds
	my $seconds = convertInterval(%p);
	#do the thang
	my %time = (
		'days'		=> 0,
		'hours'		=> 0,
		'minutes'	=> 0,
		'seconds'	=> 0
	);
	while ($seconds > 0){
		foreach ("days","hours","minutes","seconds"){
			if ($seconds >= $intervals{$_}){
				$time{$_} ++;
				$seconds  -= $intervals{$_};
				last;
			}
		}
	}
	#return data
	if ($p{'String'} != 0){
		#return a string?
		my @temp = ();
		foreach ("days","hours","minutes","seconds"){
			if ($time{$_} > 0){
				push (@temp, "$time{$_} $_");
			}
		}
		return (join (", ", @temp));
	}else{
		#return a data structure
		return (\%time);
	}	
}