#!/usr/bin/perl -w  
# yahooGeoCode.pl - lookup long/lat of an address using yahoo
use strict;

use Geo::Coder::Yahoo;
my $geocoder = Geo::Coder::Yahoo->new(appid => 'my_app' );

while( my $line = <STDIN> )
{
  chomp($line);
  my $location = "";
  $location = $geocoder->geocode( location => "$line" );

  for ( @{$location} )
  {
    my %hash = %{$_};
    print "$hash{longitude} $hash{latitude} # $line \n";
  } 
}#while stdin
