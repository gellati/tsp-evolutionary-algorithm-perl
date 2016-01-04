#!/usr/bin/perl -w

use strict;
use warnings;

#use Test::Simple 'no_plan';
use Test::Class; #'no_plan';
use Test::More;
use Test::Deep;
use parser;
use calculator;
use Data::Dumper;


my $parser = parser->new;
my $data = $parser->parsexjson('48uscaps.json');

print Dumper($data);

my @subs = qw( new routedistance );

use_ok('calculator', @subs);

can_ok(__PACKAGE__, 'new');
can_ok(__PACKAGE__, 'routedistance');


my $route = [[0,1], [2, 3]];

my $is_integer = re('^-?\d+$');

my $cal = calculator->new;
my $distance = $cal->routedistance($route, $data);

ok($distance eq $is_integer, 'is integer');

#sub HelloWorld{
#  return "Hello world";
#}


#ok( HelloWorld() eq "Hello world");

