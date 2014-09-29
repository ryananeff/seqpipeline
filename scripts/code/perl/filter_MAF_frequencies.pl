#################
#
# Filter MAF Frequencies
# Ryan Neff
# July 18, 2012
#
# Reads in a VCF file with AF field and removes out variants below an 
# AF threshold. Outputs to STDOUT, info to STDERR. 
#
##################

#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use Scalar::Util qw(looks_like_number);

# declare variables
my $inputfilename;
my $cutoff;
my $maffieldpos = 1;
my $inverse;
my $line = "";

# validate init
GetOptions('vcffile=s', \$inputfilename, 'cutoff=f', \$cutoff, 'inverse', \$inverse, 'pos=n', \$maffieldpos);
if (($cutoff > 100) || ($cutoff < 0)){
	print STDERR ("ERROR: MAF cutoff value outside of range 0-100.\n");
	exit 1;
}
$maffieldpos--;

# open input file
open FILE, '<'.$inputfilename or die $!;
print STDERR ("Starting analysis...\n");
print STDOUT ("##source=FilterAlleleFrequencies\n");

# stats
my $numlinesprinted = 0;
my $numlinesomitted = 0;
my $numlinestotal = 0;

# read in each line of VCF
while (<FILE>){
	
	$numlinestotal++; # count lines 
	# print friendly updates
	my $rem = $numlinestotal % 10000;
	if($rem == 0){
		print STDERR ("Read $numlinestotal lines\n");
	}
	
	# start processing the line, determine type of line
	my $line  = $_; # collect line variable
	my @linearray = split(/\t/,$line,9);
	my $firstchar = (split "",$_,2)[0]; # split it into characters
	my $secondchar = (split "",$_,3)[1]; # split it into characters
	
	if($firstchar eq "#" && $secondchar eq "#"){ # if we're in the header, just print the header
		print STDOUT $_;
		next;
	}
	elsif($firstchar eq "#"){ # when we've reached the labels, reformat
		print STDOUT ("#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\n");
		next;
	}
	my $info = (split /\t/, $line)[7]; # split out INFO field
	my @afsfieldarray = (split ';', $info); # collect all properties
	my $afsfield = (split ';', $info,6)[4]; # get AF field
	my $afslabel = (split '=', $afsfield)[0]; # get AF label
	my $afsnums = (split '=', $afsfield)[1]; # get AF label
	my $afsvalue = (split ',', $afsnums)[$maffieldpos]; # get AF value
	
	# in case we didn't get the AF field in the predicted spot, loop
	# over all values in the INFO section
	my $i = 0;
	while (($afslabel ne "MAF") && ($i < $#afsfieldarray)){
		$afsfield = $afsfieldarray[$i];
		$afsvalue = (split '=', $afsfield)[$maffieldpos];
		$afslabel = (split '=', $afsfield)[0];
		$i++;
	}
	
	# check for multiallelic - pass to subroutine to handle this case 
	if(! looks_like_number($afsvalue)){
		print STDERR ("WARNING: Line $numlinestotal has a malformed MAF tag (omitted).\n");
		next;
	}
	
	
	# check it actually got set to AF, else print line information to STDERR
	if($afslabel ne 'MAF'){
		print STDERR ("WARNING: Line $numlinestotal does not have an MAF tag (omitted).\n");
		$numlinesomitted++;
	}
	else{
		# print all lines over the cutoff - under if inverse is set
		if ((($cutoff < $afsvalue) && ! $inverse) || ($cutoff > $afsvalue && $inverse)){
			print STDOUT ("$linearray[0]\t$linearray[1]\t$linearray[2]\t$linearray[3]\t$linearray[4]\t$linearray[5]\t$linearray[6]\tZZ=Single;MAF=$afsvalue;\n");
			$numlinesprinted++;
		}
		else{
			$numlinesomitted++;
		}
	}
}
# print run statistics
print STDERR ("Filtering complete for $numlinestotal input lines.\n");
print STDERR ("\tNumber of lines printed: $numlinesprinted\n");
print STDERR ("\tNumber of lines discarded: $numlinesomitted\n");

# end of program
close(FILE);
exit 0;

sub handleMultiAllelic {
	my $inputline = $_[0];
	my @linearray = split(/\t/,$inputline,9);
	my @allelefreq = split(',',$_[1]);
	my @alleles = split(',', $linearray[4]);
	
	# loop over all alleles at that site
	my $int = 0;
	foreach(@alleles){
		if((($allelefreq[$int] > $cutoff) && ! $inverse) || ($cutoff > $allelefreq[$int] && $inverse)){
			print STDOUT ("$linearray[0]\t$linearray[1]\t$linearray[2]\t$linearray[3]\t$alleles[$int]\t$linearray[5]\t$linearray[6]\tZZ=Multiallelic;MAF=$allelefreq[$int];\n");
		}
		$int++;
	}
	return 0;
}
