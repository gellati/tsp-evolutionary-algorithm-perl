#!/usr/bin/perl -w

use warnings;
use strict;

use POSIX;
use List::Util 'shuffle';
use Math::Round;
use Data::Dumper;

use parser;
use TkDrawUSCitiesCanvas;
use GDplotUScities;
use evolutionary;
use calculator;

# shortest path 4,5,6,2,1,3 distance 17540
my @vector1 = (3, 4, 6, 2, 1, 5);
my @vector2 = (4, 1, 5, 3, 2, 6);
#my $mutation_rate = 1.0;
my $xorate = 0.95;
#my $popsize = 200;
my $tournaments = 4;
#my $ngens = 4000;

my $v1 = \@vector1;
print "main " . "@{$v1}" . "\n";

my $evo = evolutionary->new;

#$evo->insertion_mutation($v1, $mutation_rate);

#$evo->displace($v1, 3, 1);
#$evo->displace($v1, 3, 0);
#$evo->displace($v1, 5, 0);



#$evo->displace($v1, 1, 5);
#$evo->displace($v1, 0, 3);
#$evo->displace($v1, 0, 5);




#print "@vector1" . "\n";

print "main " . "@{$v1}" . "\n";

my $ngens = 100;
my $mutrate = 1.0;
my $i;
my $popsize = 100;

$v1 = $evo->createPopulation($popsize, $v1);

for($i = 0; $i < $ngens; $i++){

#$v1 = $evo->popmutate($v1, $mutrate);
#$v1 = $evo->insertion_mutation($v1, $mutrate);

#print "mut " . "@{$v1}" . "\n";

}









