#!/usr/bin/perl -w
# stateCompositeMap.pl - overlay text, images and shapes on map image
use strict;
use GD;

die "specify: pixelFile dataFile sourceImage destImage" unless @ARGV == 4;

my $newMap = newFromPng GD::Image( $ARGV[2] );

my $imageWidth = 2092;
my $imageHeight = 1420;
my $topMargin = 300;
my $blankMap = new GD::Image($imageWidth, $imageHeight+$topMargin);

my $white = $blankMap->colorAllocate(255,255,255);
my $black = $blankMap->colorAllocate(0,0,0);

$blankMap->copy( $newMap, 0,$topMargin, 0,0, $imageWidth,$imageHeight );

my @pixels = ();
my @data = ();
open( PIXELFILE, "$ARGV[0]" ) or die "can't open pixels file";
  while( my $line = <PIXELFILE> ){ push @pixels, $line }
close(PIXELFILE);

open( DATAFILE, "$ARGV[1]" ) or die "can't open data file";
  while( my $line = <DATAFILE> ){ push @data, $line }
close(DATAFILE);

my $posCount = 0;
my $textX = 20;
my $annotateRowIncrement = 360;
my $textY = 40;
for my $dataLine ( @data )
{
  my( undef, undef, $pointX, $pointY) =  split " ", $pixels[$posCount];
  my( $text, $faceImgName ) = split '##', $dataLine;

  $blankMap->stringFT( $black, '/usr/share/fonts/bitstream-vera/Vera.ttf',
    25,0,$textX,$textY, "$text", 
    {   linespacing=>0.6,
        charmap  => 'Unicode',
    });

  $blankMap->rectangle( $textX-10, 5, $textX+$topMargin-10, $topMargin-10, $black);
  $blankMap->line($textX+50, $topMargin-10, $pointX, $pointY+$topMargin, $black );

  my $faceImg = newFromPng GD::Image( $faceImgName );
  $blankMap->copyResized( $faceImg, $textX,$textY+15, 0,0, $topMargin-85, $topMargin-85, 115,115 );

  $textX += $annotateRowIncrement;
  $posCount++;
}

open( TILEOUT,"> $ARGV[3]") or die "can't write $ARGV[3]";
  print TILEOUT $blankMap->png;
close(TILEOUT);

