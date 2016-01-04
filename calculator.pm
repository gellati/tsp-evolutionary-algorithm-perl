#!/usr/bin/perl -w

package calculator;
use strict;
use Math::Round;
use Data::Dumper;

sub new{
    my $class = shift;
    my $self = {
    };
    bless $self, $class;
    return $self;
}

sub routedistance{
  my $self = shift;
  my $route = shift;
  my $data = shift;

  my ($i, $j);


#print "routedistance route" . "\n";
#print Dumper($route);

my $tmp = @{$route};
  my $routepoints = scalar($tmp);

#print "routedistance tmp" . "\n";
#print Dumper($tmp);
#print "routepoints " . $routepoints . "\n";




#print Dumper(@route);
#$routepoints = scalar(@{@{$route}->[0]}); #deprecated message
#$routepoints = scalar(@$route);

  my $routedist = 0;
  for ($i = 0; $i < $routepoints; $i++){
#      print @$route[$i] . "\n";
#      $j = @$route[$i];
#     print @$route[$i] . " " . @$data[@$route[$i]]->{state} . "\t";
#     print @$route[$i+1] . " " . @$data[@$route[$i+1]]->{state} . "\n";

if($i == $routepoints - 1){
## to return to the starting point
    $routedist += round((sqrt( (@{$data}[@$route[0]]->{xcoord} - 
                                @{$data}[@$route[$i]]->{xcoord})**2 +
                               (@{$data}[@$route[0]]->{ycoord} - 
                                @{$data}[@$route[$i]]->{ycoord})**2)
                                ));
}
else{
    $routedist += round((sqrt( (@{$data}[@$route[$i]]->{xcoord} - 
                                @{$data}[@$route[$i+1]]->{xcoord})**2 + 
                               (@{$data}[@$route[$i]]->{ycoord} - 
                                @{$data}[@$route[$i+1]]->{ycoord})**2)));


}


  } # for $i




#     print @$route[$i] . " " . @$data[@$route[$i]]->{state} . "\t";
#     print @$route[0] . " " . @$data[@$route[0]]->{state} . "\n";

  return $routedist;
}

1;

