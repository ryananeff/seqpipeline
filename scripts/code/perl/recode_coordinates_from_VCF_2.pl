#################
#
# recode_coordinates_from_VCF
# Ryan Neff
# September 26, 2012
#
# Reads in a VCF file and tallies changes in size cause by
# insertions and deletions to the reference sequence. 
# Outputs hg19 chromosome location, new chromosome 
# location, difference introduced, total difference, and line number
# in the input VCF. 
#
# NOTE: There should not be any multiallelic sites in the VCF, since
# it's being used to create a new alternate reference sequence. If there
# is, this program will not work as it is optimized for speed.
#
##################

#!usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use Scalar::Util qw(looks_like_number);

# declare variables
my $inputfilename;
my $includeinfo;

# validate init
GetOptions( 'vcffile=s' => \$inputfilename,
		    'includeinfo' => \$includeinfo );
		    
open FILE, '<'.$inputfilename or 
die "Usage: perl recode_coordinates_from_VCF.pl --vcffile FILENAME.vcf > output.txt";

# start analysis
print STDERR ("Starting analysis...\n");
print STDOUT ("##recode_coordinates_fron_VCF\n");
print STDOUT ("##inputfile=$inputfilename\n");
print STDOUT ("#CHROM\tREF_START\tREF_END\tALT_START\tALT_END\tDELTA\tTOTAL\n");

# stats
my $lineinVCF = 0;
my @chr_delta_array;

# globals
my $current_chr= "0";
my $delta_pos = 0;
my $insertions;
my $deletions;
my $last_alt_pos = 0;
my $last_alt_end = 0;
my $last_ref_pos = 0;
my $last_ref_end = 0;

# read in each line of VCF
while (<FILE>){
	
	$lineinVCF++; # count lines 
	# print friendly updates
	my $rem = $lineinVCF % 10000;
	if($rem == 0){
		print STDERR ("Read $lineinVCF lines\n");
	}
	
	# check if header
	my $firstchar = (split "",$_,2)[0]; # split it into characters
	if($firstchar eq "#"){ # if there's a comment mark, print nothing
		next;
	}
	
	# split line into 6 parts -- first 5 columns plus remainder
	my @linearray = split(/\t/,$_,6);
	my $chr_num = substr($linearray[0],3);
	my $ref_pos = $linearray[1];
	
	# when we change chromosomes, write and reset
	if ($current_chr ne $chr_num){
		if ($current_chr ne "0"){
			#stats handling
			my @stats;
			$stats[0] = 'chr' . $current_chr;
			$stats[1] = $insertions;
			$stats[2] = $deletions;
			$stats[3] = $delta_pos;
			push(@chr_delta_array, \@stats);
			
			#clear variables out for next chromosome
			$delta_pos = $insertions = $deletions = 0;
			$last_ref_pos = $last_ref_end = $last_alt_pos = $last_alt_end = 0;
		}
		$current_chr = $chr_num;
	}
	
	# get size difference at that line
	my $ref_bases;
	if ($linearray[3] ne ".") {$ref_bases = length($linearray[3]);}
	else{$ref_bases = 0;}
	
	my $alt_bases;
	if ($linearray[4] ne ".") {$alt_bases = length($linearray[4]);}
	else{$alt_bases = 0;}
	
	my $delta = $alt_bases - $ref_bases;
	my $alt_pos;
	if ($ref_pos + $delta_pos >= $last_alt_pos){
		$alt_pos = $last_alt_pos = $ref_pos + $delta_pos;
	}
	else{
		$alt_pos = $last_alt_pos;
		$delta = 0;
	}
	my $ref_end;
	my $alt_end;
	if    ($delta < 0) {
		$deletions  += $delta;
		$ref_end = $ref_pos - $delta;
		$alt_end = $alt_pos;
	}
	elsif ($delta > 0) {
		$insertions += $delta;
		$ref_end = $ref_pos;
		if($alt_pos + $delta >= $last_alt_end){
			$alt_end = $last_alt_end = $alt_pos + $delta;
		}
		else{
			$alt_end = $last_alt_end;
			$delta = 0;	
		}
	}
	if ($ref_pos <= $last_ref_pos){
		if ($ref_end > $last_ref_end){
			$ref_pos = $last_ref_pos;
		}
		else{
			$delta = 0;
		}
	}
	#print change in coordinates if it has occurred
	if ($delta != 0){
		$delta_pos += $delta;
		$last_ref_pos = $ref_pos;
		$last_ref_end = $ref_end;
		if($current_chr eq "X"){
			$chr_num=24;
		}
		elsif ($current_chr eq "Y"){
			$chr_num=25;
		}
		else{
			$chr_num = $current_chr+1;
		}
		my $delta_file = $delta*-1;
		my $delta_pos_file = $delta_pos*-1;
		print STDOUT ("$chr_num\t$alt_pos\t$alt_end\t$ref_pos\t$ref_end\t$delta_file\t$delta_pos_file\t");
		if ($includeinfo){ # allows us to get back a VCF with all indels if set
			print STDOUT ("$_");
		}
		else{ print STDOUT ("line$lineinVCF\n"); }
	}
}

# add final stats to array
my @stats;
$stats[0] = 'chr' . $current_chr;
$stats[1] = $insertions;
$stats[2] = $deletions;
$stats[3] = $delta_pos;
push(@chr_delta_array, \@stats);

# print statistics
print STDOUT ("STOP\n-----------------------------------\n");
print STDOUT ("Changes by chromosome:\n");
print STDOUT ("CHROM\tINSERT\tDEL\tTOTAL\n");
foreach my $row(@chr_delta_array){
   foreach my $val(@$row){
      print STDOUT ("$val\t");
   }
   print STDOUT ("\n");
}
print STDERR ("Recode coordinates from VCF complete.\n");
print STDERR ("Lines read: $lineinVCF\n");

# end of program
close(FILE);
exit 0;
