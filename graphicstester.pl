#!/usr/bin/perl -w
use warnings;
use strict;

use Tk;
# draw citu coordinates

# If there's nothing to do, draw.
#glutIdleFunc(\&cbRenderScene);

#glutMainLoop();

#exit 0;





#setupScreen();

#  my $winMain = MainWindow->new();

#$winMain->repeat(0.5, \&renderScreen());


#renderScreen();

MainLoop();

exit 0;



sub renderScreen
{
	eval {do 'draw_xy_coords.pl';};
	print $@ . "\r";
	
	# Take a quick nap to avoid wasting CPU
	select (undef,undef,undef,0.5);
}

