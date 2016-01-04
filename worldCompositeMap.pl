#!/usr/bin/perl -w
# worldCompositeMap.pl - overlay text, images and shapes on map image
use strict;
use GD;

die "specify: pixelFile dataFile sourceImage destImage" unless @ARGV == 4;

my $newMap = newFromPng GD::Image( $ARGV[2] );

my $imageWidth = $newMap->width();
my $imageHeight = $newMap->height();
my $topMargin = 110;
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
my $textX = 25;
my $textY = 20;
my $annotateRowIncrement = 150;

for my $dataLine ( @data )
{
  my( undef, undef, $pointX, $pointY) =  split " ", $pixels[$posCount];

  my( $text, $faceImgName ) = split '##', $dataLine;

  $blankMap->stringFT( $black, '/usr/share/fonts/bitstream-vera/Vera.ttf',
    8,0,$textX,$textY, "$text", 
    {   linespacing=>0.6,
        charmap  => 'Unicode',
    });


  $blankMap->rectangle( $textX-10, 5, $textX+120, 100, $black);
  $blankMap->line($textX+50, 100, $pointX, $pointY+$topMargin, $black );

  my $faceImg = newFromPng GD::Image( $faceImgName );
  $blankMap->copyResized( $faceImg, $textX,$textY+10, 0,0, 60,60, 115,115 );

  $textX += $annotateRowIncrement;
  $posCount++;

}#for each data line

open( TILEOUT,"> $ARGV[3]") or die "can't write $ARGV[3]";
  print TILEOUT $blankMap->png;
close(TILEOUT);

