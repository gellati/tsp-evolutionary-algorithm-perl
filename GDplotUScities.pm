#!/usr/bin/perl -w

package GDplotUScities;
# worldCompositeMap.pl - overlay text, images and shapes on map image
use strict;
use GD;
use Math::Round;
use Math::Trig;

sub new{
    my $class = shift;
    my $self = {
    };
    bless $self, $class;
    return $self;
}

# us map uses alber projection
sub drawUSmap{
  my $self = shift;
  my $data = shift;

  my $newMap = GD::Image->newFromPng( 'USA100.png' );

  my $map_top_lat = 50;
  my $map_top_long = -125;

  my $map_bottom_lat = 24;
  my $map_bottom_long = -66;

  my ($i, $j);
  my ($xpos, $ypos);
  my ($lat, $long);
  my $imageWidth = $newMap->width();
  my $imageHeight = $newMap->height();

  ($imageWidth, $imageHeight) = $newMap->getBounds();

  my $map_lat_scale = $imageHeight / ($map_top_lat - $map_bottom_lat);
  my $map_long_scale = $imageWidth / ($map_bottom_long - $map_top_long);


#MAP USA100 USA100.png 50 -125 24 -66
  my $data_length = scalar(@$data);

  my $black = $newMap->colorAllocate(0,0,0);       
  my $red = $newMap->colorAllocate(255,0,0);      
  my $blue = $newMap->colorAllocate(0,0,255);

  for($i = 0; $i < $data_length; $i++){
    $lat = @$data[$i]->{latitude};
    $long = @$data[$i]->{longitude};

# unknown projection
#    $ypos = $map_lat_scale * ($map_top_lat - $lat);
#    $xpos = $map_long_scale * ($long - $map_top_long);


    ($xpos, $ypos) = $self->convert_latlong_to_xy_alber($lat, $long);

    $newMap->filledRectangle($xpos + 3, $ypos - 3, $xpos - 3, $ypos + 3, $black);
    $newMap->string(gdSmallFont,$xpos, $ypos,@$data[$i]->{capital},$black);
    $newMap->string(gdSmallFont,$xpos, $ypos+10,@$data[$i]->{abbreviation},$black);

  }

  open(IMG, '>pic.png') or die $!;
  binmode IMG;
  print IMG $newMap->png;
  close(IMG);

return;

}


sub TSPUSroute{
  my $self = shift;
  my $data = shift;
  my $route = shift;

  $self->drawUSmap($data);

#  my $newMap = GD::Image->newFromPng( 'USA100.png' );
  my $newMap = GD::Image->newFromPng( 'pic.png' );

  my $map_top_lat = 50;
  my $map_top_long = -125;

  my $map_bottom_lat = 24;
  my $map_bottom_long = -66;

  my ($i, $j);
  my ($xpos1, $ypos1, $xpos2, $ypos2);
  my ($lat1, $long1, $lat2, $long2);
  my $imageWidth = $newMap->width();
  my $imageHeight = $newMap->height();

  ($imageWidth, $imageHeight) = $newMap->getBounds();

  my $map_lat_scale = $imageHeight / ($map_top_lat - $map_bottom_lat);
  my $map_long_scale = $imageWidth / ($map_bottom_long - $map_top_long);


#MAP USA100 USA100.png 50 -125 24 -66
  my $data_length = scalar(@$data);
  my $route_length = scalar(@$route);

  my $black = $newMap->colorAllocate(0,0,0);       
  my $red = $newMap->colorAllocate(255,0,0);      
  my $blue = $newMap->colorAllocate(0,0,255);

  for($i = 0; $i < $route_length; $i++){

if($i == $route_length - 1){
    $lat1 = @$data[$i]->{latitude};
    $long1 = @$data[$i]->{longitude};

    $lat2 = @$data[0]->{latitude};
    $long2 = @$data[0]->{longitude};


    ($xpos1, $ypos1) = $self->convert_latlong_to_xy_alber($lat1, $long1);
    ($xpos2, $ypos2) = $self->convert_latlong_to_xy_alber($lat2, $long2);

    $newMap->line($xpos1, $ypos1, $xpos2, $ypos2, $red);

}
else{

    $lat1 = @$data[$i]->{latitude};
    $long1 = @$data[$i]->{longitude};

    $lat2 = @$data[$i+1]->{latitude};
    $long2 = @$data[$i+1]->{longitude};


    ($xpos1, $ypos1) = $self->convert_latlong_to_xy_alber($lat1, $long1);
    ($xpos2, $ypos2) = $self->convert_latlong_to_xy_alber($lat2, $long2);

    $newMap->line($xpos1, $ypos1, $xpos2, $ypos2, $red);

}

#    $newMap->filledRectangle($xpos + 3, $ypos - 3, $xpos - 3, $ypos + 3, $black);
#    $newMap->string(gdSmallFont,$xpos, $ypos,@$data[$i]->{capital},$black);
#    $newMap->string(gdSmallFont,$xpos, $ypos+10,@$data[$i]->{abbreviation},$black);


  }

  open(IMG, '>pic2.png') or die $!;
  binmode IMG;
  print IMG $newMap->png;
  close(IMG);

  return;

}



sub convert_latlong_to_xy_alber{
  my ($self, $lat, $long) = @_;

  my $PI = 3.141592654;

#PROJECTION USA100 ALBER 1406.35 30.8 45.5 21.7 -99.9 464 781

my @F = (0, 1406.35, 30.8, 45.5, 21.7, -99.9, 464, 781);

  my ($R, $false_easting, $false_northing) = @F[1,6,7];
  my ($phi_1, $phi_2, $phi_0, $lambda_0) = @F[2..5];

  my $PHI_1 = ($phi_1 * $PI) / 180.0;
  my $PHI_2 = ($phi_2 * $PI) / 180.0;
  my $PHI_0 = ($phi_0 * $PI) / 180.0;
  my $LAMBDA_0 = ($lambda_0 * $PI) / 180.0;

  my $N = (sin($PHI_1) + sin($PHI_2)) / 2.0;
  my $C = cos($PHI_1) ** 2 + 2.0 * $N * sin($PHI_1);

######

  my $phi = ($lat * $PI) / 180.0;
  my $lambda = ($long * $PI) / 180.0;

  my $p   = ($R * sqrt($C - 2.0 * $N * sin($phi))) / $N;
  my $p_0 = ($R * sqrt($C - 2.0 * $N * sin($PHI_0))) / $N;
  my $theta = $N * ($lambda - $LAMBDA_0);

  my $x = $false_easting + round($p * sin($theta));
  my $y = $false_northing - round($p_0 - $p * cos($theta));

  return ($x, $y);
}








########## code applied from TkDrawUSCitiesCanvas drawing package #############

sub TSPcircleMap{
  my $self = shift;
#  my $can = shift;
  my $data = shift;
  my $route = shift;
  my $map_width = shift;
  my $map_height = shift;

  my @cid;

  my $data_length = scalar(@$data);

  my ($i, $j);

  my $route_length = scalar(@$route);

  my $radius = 10 * $route_length;
  my $margin = 100;

  my $image = GD::Image->new($map_width + $margin, $map_height + $margin);
  print "radius margin " . $radius . " " . $margin . "\n";

  my $states_length = scalar(@$route);
  my $segment_size = 2 * pi / $states_length;
  print "s " . $segment_size . "\n";
  my $angle = 0;
  my ($x,$y);
  my @xcoords;
  my @ycoords;
  my @coords;

  my $white = $image->colorAllocate(255,255,255);       
  my $black = $image->colorAllocate(0,0,0);       

  my $cal = calculator->new;

  my @distances;
  my $n = 0;
  my @temp = ();
  for($i = 0; $i < $states_length; $i++){

      if($i < $states_length - 1){
        push(@temp, @$route[$i]);
        push(@temp, @$route[$i+1]);
        push(@distances, $cal->routedistance( \@temp,$data));
      }
      else{
        push(@temp, @$route[$i]);
        push(@temp, @$route[0]);
        push(@distances, $cal->routedistance( \@temp,$data));
      }

      @temp = ();
  }

  my ($textposx, $textposy);
  my @textcoords;

  my ($distposx, $distposy);

  $n = 0;
my $citycircleradius = 24;


  while($angle < 2 * pi){

### drawing the tsp route in a circle
    $x = round($radius * sin($angle)) + $map_width/2;
    $y = round($radius * cos($angle)) + $map_height/2;

    $image->arc($x,
                               $y,
                               $citycircleradius,
                               $citycircleradius,
                               0,
                               360,
                               $black);

## writing the names of the cities
    $textposx = round( ( $radius + 40 ) * sin($angle)) + $map_width/2;
    $textposy = round( ( $radius + 40 ) * cos($angle)) + $map_height/2;
    push(@textcoords, $textposx);
    push(@textcoords, $textposy);
#    push(@cid, $can->createText(($textcoords[0], $textcoords[1]), -text=> "$distances[$n]"));

## writing the distances between cities
    $distposx = round( ( $radius +30) * sin($angle + $segment_size/2)) + $map_width/2;
    $distposy = round( ( $radius +30) * cos($angle + $segment_size/2)) + $map_height/2;

    if ($n < $states_length){
      $image->string(gdSmallFont, $distposx, $distposy, "$distances[$n]", $black);
      $image->string(gdSmallFont, $textposx, $textposy, "@$data[$n]->{capital}" . " " . "@$data[$n]->{abbreviation}", $black);

    }
    print "tsp n " . $n . "\n";
    $n++;


    $angle += $segment_size;

    push(@coords, $x);
    push(@coords, $y);

  }
  # to get path closed
  push(@coords, $coords[0]);
  push(@coords, $coords[1]);

  my $ncoord = scalar(@xcoords);

  my $ncoords = scalar(@coords);
print "ncoords " . $ncoords . "\n";
print "i " . $i . "\n";
print "coords " . "@coords" . "\n";
  for($i = 0; $i < $ncoords; $i = $i + 2){
#    $image->line($coords[$i], $coords[$i+1], $coords[$i+2], $coords[$i+3], $black);
  }


  $n = 0;


  open(IMG, '>circlepic.png') or die $!;
  binmode IMG;
  print IMG $image->png;
  close(IMG);



return;


}


sub TSPdrawCities{
  my $can = shift;
  my $data = shift;
  my $states = shift;
  my $map_width = shift;
  my $map_height = shift;

  my ($i, $j);

  my @cid;


#print @$data[2][1] . "\n";

#print Dumper(@$data[2]->[2]);
  my $xmargin = 100;
  my $ymargin = 50;


  my $states_length = scalar(@$states);
  my $radius = 50;

#print "states " . $states_length . "\n";


  my $segment_size = 2 * pi / $states_length;
#print "s " . $segment_size . "\n";
  my $angle = 0;
  my ($x,$y);
  my @linecoords;
  my $n = 0;

  my $just = 20;
  for($i = 0; $i < $states_length; $i++){

#print round(($data[$i][1] - $radius)/1) . "\n";


#=comment
# print coordinates in list

    push(@cid, $can->createOval( round((@$data[@$states[$i]]->{xcoord} - $radius)/$just) + $xmargin,
                             $map_height - (round((@$data[@$states[$i]]->{ycoord} - $radius)/$just + $ymargin)),
                             ((@$data[@$states[$i]]->{xcoord} + $radius)/$just) + $xmargin,
                             $map_height - (round((@$data[@$states[$i]]->{ycoord} + $radius)/$just + $ymargin))));

    push(@cid, $can->createText( round((@$data[@$states[$i]]->{xcoord})/$just) + $xmargin + 5,
                             $map_height - (round((@$data[@$states[$i]]->{ycoord})/$just + $ymargin)),
                             -text => @$data[$n]->{capital},
                             -anchor => "w"));

    push(@linecoords, round(@$data[@$states[$i]]->{xcoord}/$just)+$xmargin);
    push(@linecoords, $map_height - round(@$data[@$states[$i]]->{ycoord}/$just + $ymargin));
    if($i < $states_length - 1){
      push(@linecoords, round(@$data[@$states[$i+1]]->{xcoord}/$just + $xmargin));
      push(@linecoords, $map_height - round(@$data[@$states[$i+1]]->{ycoord}/$just + $ymargin));
    }
    else{
      push(@linecoords, round(@$data[@$states[0]]->{xcoord}/$just + $xmargin));
      push(@linecoords, $map_height - round(@$data[@$states[0]]->{ycoord}/$just + $ymargin));
    }

    push(@cid, $can->createLine(@linecoords, -width => 0.5, -smooth => 0));

    $n++;
#=cut


  }


  return;

}


1;

