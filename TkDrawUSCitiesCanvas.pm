#!/usr/bin/perl -w
package TkDrawUSCitiesCanvas;

use warnings;
use strict;

#no warnings;
use Math::Round;
use Tk;
use Tk::PNG;
use Tk::Pane;
use Data::Dumper;
use JSON;
use Math::Trig;

#use googleV3GeoCode;
use parser;
use calculator;

sub new{
    my $class = shift;
    my $self = {
    };
    bless $self, $class;
    return $self;
}


sub drawTSPcanvas{
  my $self = shift;
  my $data = shift;
  my $route = shift;
  my $map_width = shift;
  my $map_height = shift;

  my @cid;

#print "hello" . "\n";

#my @route = (1,2,3);

#  my @states = (1, 4, 13, 2, 25);

#print routedistance(\@route, $data);

=comment
  my $winMain = MainWindow->new();
  $winMain->title( 'TSP route cities on US map' );
  my $frmCan1 = $winMain->Frame();
  $frmCan1->pack(-side => 'top', -fill => 'both', -expand => 'yes');


  my $can1 = $frmCan1->Canvas(-width => $map_width,
                            -height => $map_height,
  );
  $can1->pack(-expand => 'yes', -fill => 'both');
=cut


  my $winMain2 = MainWindow->new();
  $winMain2->title( 'TSP cities on circle map' );

#  my $frmCan2 = $winMain2->Frame();
  my $frmCan2 = $winMain2->Scrolled('Pane', -scrollbars =>'osoe')->pack;

  $frmCan2->pack(-side => 'top', -fill => 'both', -expand => 'yes');

  my $can2 = $frmCan2->Canvas(-width => $map_width,
                            -height => $map_height,
  );


  $can2->pack(-expand => 'yes', -fill => 'both');


#TSPdrawCities($can1, $data, $route, $map_width, $map_height);
TSPcircleMap($can2, $data, $route, $map_width, $map_height);


#doClear($can);
#sleep 0.5;
#}

MainLoop();


}

# transform x, y to plot coordinates
#

sub transform{ #($$){
    my( $x, $y, $unit, $margin ) = @_;
    $x = $unit *($x+1) + $margin;
    $y = $unit *($y+1) + $margin;
    return( $x.'c', $y.'c' );
}


sub TSPcircleMap{
  my $can = shift;
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

  my $states_length = scalar(@$route);
  my $segment_size = 2 * pi / $states_length;
  print "s " . $segment_size . "\n";
  my $angle = 0;
  my ($x,$y);
  my @xcoords;
  my @ycoords;
  my @coords;

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
my $citycircleradius = 12;


  while($angle < 2 * pi){

### drawing the tsp route in a circle
    $x = round($radius * sin($angle)) + $map_width/2;
    $y = round($radius * cos($angle)) + $map_height/2;

    push(@cid, $can->createOval($x - $citycircleradius,
                               $y - $citycircleradius,
                               $x + $citycircleradius,
                               $y + $citycircleradius));
#print "x " . $x . " y " . $y . "\n";
## writing the names of the cities
    $textposx = round( ( $radius + 50 ) * sin($angle)) + $map_width/2;
    $textposy = round( ( $radius + 50 ) * cos($angle)) + $map_height/2;
    push(@textcoords, $textposx);
    push(@textcoords, $textposy);
#    push(@cid, $can->createText(($textcoords[0], $textcoords[1]), -text=> "$distances[$n]"));

## writing the distances between cities
    $distposx = round( ( $radius + 20 ) * sin($angle + $segment_size/2)) + $map_width/2;
    $distposy = round( ( $radius + 20 ) * cos($angle + $segment_size/2)) + $map_height/2;

    if ($n < $states_length){
      push(@cid, $can->createText(($distposx, $distposy), -text=> "$distances[$n]"));
   push(@cid, $can->createText(($textposx, $textposy), -text=> "@$data[$n]->{capital}" . " " . "@$data[$n]->{abbreviation}"));

    }
#    print "tsp n " . $n . "\n";
    $n++;


    $angle += $segment_size;

    push(@coords, $x);
    push(@coords, $y);

  }
  # to get path closed
  push(@coords, $coords[0]);
  push(@coords, $coords[1]);

  my $ncoord = scalar(@xcoords);

  push(@cid, $can->createLine(@coords, -width => 0.5, -smooth => 0));

  $n = 0;

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


=comment
# draw all coordinates in json file
push(@cid, $can->createOval( round((@$data[$i]->{xcoord} - $radius)/20) + $margin,
                             300 - (round((@$data[$i]->{ycoord} - $radius)/20)),
                             ((@$data[$i]->{xcoord} + $radius)/20) + $margin,
                             300 - (round((@$data[$i]->{ycoord} + $radius)/20))));

push(@cid, $can->createText( round((@$data[$i]->{xcoord})/20) + $margin + 5,
                             300 - (round((@$data[$i]->{ycoord})/20)),
                             -text => @$data[$i]->{capital},
                             -anchor => "w"));

=cut

=comment
push(@cid, $can->createOval( round((@$data[$i]->[1] - $radius)/20) + $margin,
                             300 - (round((@$data[$i]->[2] - $radius)/20)),
                             ((@$data[$i]->[1] + $radius)/20) + $margin,
                             300 - (round((@$data[$i]->[2] + $radius)/20))));

push(@cid, $can->createText( round((@$data[$i]->[1])/20) + $margin + 5,
                             300 - (round((@$data[$i]->[2])/20)),
                             -text => $i,
                             -anchor => "w"));
=cut


  }
  return;

}




#sub doClear{
#    my( $can ) = shift;
#    $can->delete( @cid );
#    @cid = ();
#}



sub retrieve_by_id{
  my $id = shift;
  my $data = shift;

  my ($i, $j);
  my $data_length = scalar(@$data);

#  for($i


}

1;

