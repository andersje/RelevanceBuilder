#!/usr/bin/perl

# read in the file, figure out the names of the clauses -- anything that starts with "clause", and substitute appropriately

my $plan="./RelPlan";
my $result="./RESULT";
my $DEBUG=0;

open PLANFILE,$plan;
open RESULT,">$result";

while (<PLANFILE>) {
	if ($_ =~ /^#/) { next; }
	chomp $_;

	(@elements) = split, $_;
	foreach $element (@elements) {
		if ($DEBUG) {print "next element is $element\n"; }
		if ( $element =~ /clause/ ) {
			my $workingclause="";
			($marker, $clausefile) = split /\./, $element;
			chomp $clausefile;
			if (! ($clausefile =~ /\//)) { 
				#lets clean up that clausefile by pulling out parentheses, too, because sometimes they stick.
				$clausefile="./$clausefile"; 
				$clausefile =~ s/[\(\)]//g;
			}
			if ($DEBUG)  {print "going to read file $clausefile\n"; }	
			if ($DEBUG) {print "checking to see if $clausefile is a directory\n"; }
			if ( -d $clausefile ) {
				if ($DEBUG) {print "yep, $clausefile is a dir -- changing clausefile to be the RESULT file from it\n" };
				$clausefile="$clausefile/RESULT"; 
			}
			#$workingclause=`grep -v '^#' $clausefile` | grep -v ^$`;  #the shell way
			if ( -f $clausefile ) {
				open CLAUSEFILE,$clausefile;
				while (<CLAUSEFILE>) {
					if ($DEBUG) { print "reading a line from $clausefile\n"; }
					if (! ($_ =~ /^#/ ) && ! ($_ =~ /^$/)) {
						##no comment character at beginning.  declare this our good line and break
						chomp $_;
						$workingclause=$_;
						if ($DEBUG) { print "in file read routine, got $_ and stuck it in $workingclause\n"; }
						break;
					}
				}
			} else { die "$clausefile was not found\n"; }
			if ($DEBUG) { print "found clause  ( $workingclause ) \n"; }
			print RESULT " ( $workingclause ) ";
		} else { print RESULT "$element "; }
		if ($DEBUG) { if ($element =~ /[()]/) { print "printing a parenthesis\n"; }	 }
	}
	print RESULT "\n";
}

close PLANFILE;
close RESULT;
