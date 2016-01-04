#!/usr/bin/perl -w

use warnings;
use strict;

use parser;

use Data::Dumper;

my $file = '48uscaps.json';

my $p = parser->new();

my $cities = $p->parsexjson($file);
#print Dumper($cities);

$p->distance_matrix($cities);


