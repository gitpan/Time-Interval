# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test;
BEGIN { plan tests => 10 };
use Time::Interval;
ok(1); # If we made it this far, we're ok.

#########################

#test getInterval
my $str1 = "1/15/03 12:34:32 EDT 2003";
my $str2 = "4/25/03 11:24:00 EDT 2003";
print "testing getInterval between:\n\t$str1\n\t$str2\n";
if (my $data = getInterval($str1,$str2)){
	foreach (keys %{$data}){ print "[$_]: $data->{$_}\n"; }
	ok(1);
}else{
	ok(0);
}

#test convertInterval
my %data = (
	'days'		=> 70,
	'hours'		=> 16,
	'minutes'	=> 56,
	'seconds'	=> 18
);

print "testing convertInterval on:\n";
foreach (keys %data){ print "[$_]: $data{$_}\n"; }
foreach ('days','hours','minutes','seconds'){
	my $num = convertInterval(
		ConvertTo	=> $_,
		%data
	) || ok(0);
	print "converting to $_ ...: $num\n";
	ok(1);
}

#test parseInterval
print "testing parseInterval (data):\n";
foreach ('days','hours','minutes','seconds'){
	print "123456 $_ is: ...\n";
	my $string = parseInterval(
		$_		=> 12345,
		String	=> 1
	) || ok(0);
	print "\t$string\n";
	ok(1);
}