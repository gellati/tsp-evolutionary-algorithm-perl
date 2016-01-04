package parser;

#!/usr/bin/perl -w

use warnings;
use strict;
use Math::Round;

use Data::Dumper;

use JSON;

sub new{
    my $class = shift;
    my $self = {
    };
    bless $self, $class;
    return $self;
}

sub parsexjson{
  my $self = shift;
  my $file = shift;
#  my $file = '48uscaps.json';
  open(FILE, $file) || die "cannot open file";

  my $lines;
  my $line;
  while(<FILE>){
    $lines .= $_;
  }

  close(FILE);

  my $decoded = decode_json($lines);
  my @citis = @{ $decoded };

#print "latitude" . $citis[1]->{latitude} . "\n";
#print "xcoord" . $citis[1]->{xcoord} . "\n";

  return \@citis;

}





















sub parse_and_print_to_json_file{

  my $file1 = '48uscaps.txt';
  my $file2 = 'uscaps_latitude_longitude.txt';

  open(FILE1, $file1) || die "cannot open file";
  my @lines1;
  while(<FILE1>){
    next if $. < 5;
    chomp;
    push(@lines1, $_);
  }
  close(FILE1);

  open(FILE2, $file2) || die "cannot open file";
  my @lines2;
  while(<FILE2>){
#  next if $. < 5;
    next if $_ =~ /^$/; # next if empty line #check if correct
    chomp;
    push(@lines2, $_);
  }
  close(FILE2);

#print "@lines";

  my %data;

  my @data;
  my ($i, $j);
  my $nlines1 = scalar(@lines1);
  my @line;
  my $line_elements;
  for($i = 0; $i < $nlines1; $i++){
    chomp($lines1[$i]);
    @line = split(/\s+/, $lines1[$i]);
    $line_elements = scalar(@line);

    for($j = 0; $j < $line_elements; $j++){
#print $line[$j];
#    $data[$i][$j] = $line[$j];
    }
    $data[$i]{id} = $line[0];
    $data[$i]{xcoord} = $line[1];
    $data[$i]{ycoord} = $line[2];
  }

  my $counter = 0;
  my $nlines2 = scalar(@lines2);
  my $s;
  for($i = 0; $i < $nlines2; $i++){
#  next if $lines2[$i] =~ /^$/; # next if empty line #check if correct

    chomp($lines2[$i]);
    @line = split(/:/, $lines2[$i]);

  #print "@line" . "\n";
  #print "$line[0]" . "\n";
    $line[0] =~ s/\s*//;
  #$s =~ s/\s*//;
  #print $s . "\n";
  #print $line[0] . " -- " . $line[1] . "\n";

    if($line[0] =~ m/^Name/ && $line[0] !~ /Capital$/){
  #print $line[1] . "\n";
      $line[1] =~ s/\s*//;
      $data[$counter]{state_name} = $line[1];
    }


#=comment
    if($line[0] =~ /^Capital/ && $line[0] =~ m/Name$/){
      $line[1] =~ s/\s*//;
      $data[$counter]{capital_name} = $line[1];
    }

    if($line[0] =~ m/Latitude$/){
      $data[$counter]{latitude} = $line[1];
    }

    if($line[0] =~ m/Longitude$/){
  #print $line[1] . "\n";
      $data[$counter]{longitude} = $line[1];
      $counter++;
    }
#=cut

  }

#open(OUTFILE, '>:encoding(UTF-8)', '48uscaps.json');

  open(OUTFILE, '>48uscaps.json');
  binmode(STDOUT, ":utf8");


  print OUTFILE "[" . "\n";
  for($i = 0; $i < $nlines1; $i++){
    print OUTFILE "{";
    print OUTFILE "\"id\": " . $data[$i]{id} . "," . "\n";
    print OUTFILE "\"state\"" . ":" . "\"" . $data[$i]{state_name} . "\"" .  "," . "\n";
    print OUTFILE "\"capital\"" . ":" . "\"" . $data[$i]{capital_name} . "\"" . "," . "\n";
    print OUTFILE "\"latitude\"" . ":" . $data[$i]{latitude} . "," . "\n";
    print OUTFILE "\"longitude\"" . ":" . $data[$i]{longitude} . "," . "\n";
    print OUTFILE "\"xcoord\"" . ":" . $data[$i]{xcoord} . "," . "\n";
    print OUTFILE "\"ycoord\"" . ":" . $data[$i]{ycoord} . "\n";
    if($i < $nlines1 - 1){
      print OUTFILE "}," . "\n";
    }
    else{
      print OUTFILE "}" . "\n";
    }
  }

  print OUTFILE "]" . "\n";

  close (OUTFILE);

#print "h2llo" . "\n";

return;

}

# make a distance matrix from json data about us cities
sub distance_matrix{
  my $self = shift;
  my $data = shift;

  my @distances;
  my $n = 0;
  my $nlines = scalar(@{$data});

  my($i, $j);
  my $scaler = 1;
  print "\t";
  for($i = 0; $i < $nlines/$scaler; $i++){
    if($i == $nlines/$scaler - 1){
      print @{$data}[$i]->{state} . "\n";
      next;
    }
    else{
      print @{$data}[$i]->{state} . "\t";
    }
  }

#  print "\n";

  for($i = 0; $i < $nlines/$scaler; $i++){
    print @{$data}[$i]->{state} . "\t";
    for($j = 0; $j < $nlines/$scaler; $j++){
      if($j == $nlines/$scaler - 1){
#      print round((sqrt( (@{$data}[$j]->{xcoord} - @{$data}[$i]->{xcoord})**2 + (@{$data}[$j]->{ycoord} - @{$data}[$i]->{ycoord})**2))) . "\n";

      print nearest(.01, (sqrt( (@{$data}[$j]->{xcoord} - @{$data}[$i]->{xcoord})**2 + (@{$data}[$j]->{ycoord} - @{$data}[$i]->{ycoord})**2))) . "\n";

next;
      }
      else{

#    $distance[$j][$j] = $data[$i]
#print @{$data}[$j]->{xcoord} . "\n";

#      print round((sqrt( (@{$data}[$j]->{xcoord} - @{$data}[$i]->{xcoord})**2 + (@{$data}[$j]->{ycoord} - @{$data}[$i]->{ycoord})**2))) . "\t";

      print nearest(0.01, (sqrt( (@{$data}[$j]->{xcoord} - @{$data}[$i]->{xcoord})**2 + (@{$data}[$j]->{ycoord} - @{$data}[$i]->{ycoord})**2))) . "\t";
 
     }
    }
#  print "\n";
#$n++;

  }
  return;
}

1;






############################ used up code #############################




=comment
open(FILE, $file) || die "cannot open file";

my @lines;

while(<FILE>){
  next if $. < 5;
  chomp;
  push(@lines, $_);
}


#@lines = <FILE>;

close(FILE);

#print "@lines";

my @data;
my ($i, $j);
my $nlines = scalar(@lines);
my @line;
my $line_elements;
for($i = 0; $i < $nlines; $i++){

  chomp($lines[$i]);
  @line = split(/\s+/, $lines[$i]);
  $line_elements = scalar(@line);

  for($j = 0; $j < $line_elements; $j++){
#print $line[$j];
    $data[$i][$j] = $line[$j];
  }

}

#print Dumper(@data);

#print $data[3][0] . " " . $data[3][1] . " " . $data[3][2] . "\n";



print $data[3][1] . " " . $data[3][2] . "\n";



my @distances;
my $n = 0;
for($i = 0; $i < $nlines/4; $i++){
  for($j = 0; $j < $nlines/4; $j++){
#    $distance[$j][$j] = $data[$i]
print round((sqrt( ($data[$j][1] - $data[$i][1])**2 + ($data[$i][2] - $data[$j][2])**2))) . " ";

  }
print "\n";
$n++;
}
=cut




=comment
sub parsexydata{

my $file = '48uscaps.txt';

open(FILE, $file) || die "cannot open file";

my @lines;

while(<FILE>){
  next if $. < 5;
  chomp;
  push(@lines, $_);
}

close(FILE);

my @data;
my ($i, $j);
my $nlines = scalar(@lines);
my @line;
my $line_elements;
for($i = 0; $i < $nlines; $i++){

  chomp($lines[$i]);
  @line = split(/\s+/, $lines[$i]);
  $line_elements = scalar(@line);

  for($j = 0; $j < $line_elements; $j++){
#print $line[$j];
    $data[$i][$j] = $line[$j];
  }

}
#print $data[3][0] . " " . $data[3][1] . " " . $data[3][2] . "\n";

return \@data;

#print Dumper(@data);

}
=cut


=comment

    Name: Alaska

    Capital Name: Juneau

    Capital Latitude: 58.301935

    Capital Longitude: -134.419740

    Name: Hawaii

    Capital Name: Honolulu

    Capital Latitude: 21.30895

    Capital Longitude: -157.826182



=cut

