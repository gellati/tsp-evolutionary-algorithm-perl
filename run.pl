#!/usr/bin/perl -w

use warnings;
use strict;

# after 150 generations not lower than 35655



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
#my @vector1 = (3, 4, 6, 2, 1, 5);
my @vector2 = (4, 1, 5, 3, 2, 6);
my $mutation_rate = 0.9;
my $xorate = 0.95;
my $popsize = 1000;
my $tournaments = 4;
my $ngens = 1000;

my @vector1 = (0..47); # 71597 # 68177 # 57646 # 47632


my $xopoint = 2;
my $xoend = 3; # works if $xoend != vector length. indexing starts from 0, xoend = length - 1
       # last element alone can be swapped if xostart = vectorlength-2 and xoend = vectorlength-1 


my ($i, $j);
my $vector_length = scalar(@vector1);


=comment
my $pop = generate_arrays(\@vector1, 2);
print "p  " . "@$pop" . "\n";

my $n = scalar(@$pop);
for($i = 0; $i < $n; $i++){
my $m = scalar(@{$pop->[$i]});
print "p " . $m . "\n";
for($j = 0; $j < $m; $j++){
print @$pop[$i]->[$j];
}
}
print "\n";
=cut

for($i = 0; $i < $vector_length; $i++){
  if($i == $xopoint){
    print "|";
  }
  print $vector1[$i] . " ";
}
print "\n";


=comment
for($i = 0; $i < $vector_length; $i++){
  if($i == $xopoint){
    print "|";
  }
  if($i == $xoend){
    print "|";
  }
  print $vector2[$i] . " ";
}
print "\n";
=cut


#  print "@vector1" . "\n";
#  print "@vector2" . "\n";




#printVector(\@vector1);


my $datafile = '48uscaps.json';
my $parser = parser->new();
my $data = $parser->parsexjson($datafile);
#my $distance = routedistance(\@vector1, $data);
#print $distance . "\n";
my $temp = \@vector1;

my $calc = calculator->new;
my $dist = $calc->routedistance($temp, $data);
print "distance " . $dist . "\n";

my $evo = evolutionary->new;

#print "bfr population creation" . "\n";
#print Dumper($temp);
#my @pop = createPopulation(3, $temp);
my $temp = $evo->createPopulation($popsize, $temp);
#print "aftr population creation" . "\n";
#print Dumper($pop);


#$temp = \@pop;
#$temp = $pop;
my ($s, $t);
my $sum = 0;
#$temp = \@pop;

#($s, $t) =  $evo->findshortestroute($temp, $data);

for($i = 0; $i < $ngens; $i++){

#($s, $t) =  $evo->findshortestroute($temp, $data);

#printPopulation(\@pop);
#print "before tournament" . "\n";
#print Dumper($temp);


#$evo->swap2($temp->[0], $temp->[1], 1, 2);

$temp = $evo->popmutate($temp, $mutation_rate);
$temp = $evo->popcrossover($temp, $xorate);


#$temp->[0] = $t;

$temp = $evo->tournament($temp, $data, $tournaments);
$temp = $evo->tournament($temp, $data, $tournaments);


if($i % 10 == 0){

print "if 10 " . $i. "\n";

#($s, $t) =  $evo->findshortestroute($temp, $data);
#print $s . "\n";
#print Dumper($t);

for($j = 0; $j < 10; $j++){

$dist = $calc->routedistance($temp->[$j], $data);
$sum += $dist;

print $dist . "\t";

}
print ($sum / 10);
$sum = 0;
print "\n";

}


#print "after tournament" . "\n";
#print Dumper($temp);



}


($s, $t) =  $evo->findshortestroute($temp, $data);


$dist = $calc->routedistance($t, $data);
print "distance " . $dist . "\n";

print "after tournament" . "\n";
#print Dumper($temp);



#my ($v1, $v2) = pmx(\@vector1, \@vector2, $xopoint, $xoend);
#print "@$v1" . "\n";
#print "@$v2" . "\n";




my $d = GDplotUScities->new();
$d->drawUSmap($data);
$d->TSPUSroute($data, $t);


#my $g = googleV3GeoCode->new();
#$g->getCoords($data);



#$d->TSPcircleMap($data, $t, $map_width, $map_height);

  my $map_width = 1400;
  my $map_height = 1400;

my $tkc = TkDrawUSCitiesCanvas->new;
$tkc->drawTSPcanvas($data, \@vector1, $map_width, $map_height);


