package evolutionary;
#!/usr/bin/perl -w

use warnings;
use strict;

use POSIX;
use List::Util 'shuffle';
use Math::Round;
use Data::Dumper;


sub new{
  my $class = shift;
  my $self = {
  };
  bless $self, $class;
  return $self;

}


sub tournament{
  my $self = shift;
  my $vector = shift;
  my $data = shift;
  my $tournaments = shift;

  my $nrows = scalar(@{$vector}); # number of rows
  my $ncols = scalar(@{$vector->[0]}); # number of columns

  my $cal = calculator->new;
  my @champ;
  my ($champ, $contender);
  my ($ch, $co);

  my @newpop;

  my ($i, $j);
  my ($distance1, $distance2);

  for($i = 0; $i < $nrows; $i++){

# regular tournament selection
    $ch = floor(rand() * $nrows);
    $champ = @{$vector}[$ch];

# tournament selection with elitism
#($ch, $champ) = $self->findshortestroute($vector, $data);

    for($j = 0; $j < $tournaments; $j++){

#=comment

      $co = floor(rand() * $nrows);
#print "tournament co " . "\n";
#print $co . "\n";

      $contender = @{$vector}[$co];

#  print "tou " . "\n";
#      if($cal->routedistance(\@contender, $data) > $cal->routedistance(\@champ, $data) ){
      if($cal->routedistance($contender, $data) < $cal->routedistance($champ, $data) ){

#$ch = $co;
#    @champ = @{@{$vector}[0]->[$co]};
    #$champ = @{$vector}[$co];
$champ = $contender;

      } # if co < ch
#=cut

    }  # for tournaments

#print "contender " . "\n";
#print Dumper($contender);

    push(@newpop, $self->copy_vector(\@{$champ}));

  } # for nrows


#print "newpop" . "\n";
#print "@newpop" . "\n";
#print "tournament2" . "\n";
#print Dumper(@newpop);

#  print $distance . "\n";
  return \@newpop;

}


sub findshortestroute{
    my $self = shift;
    my $pop = shift;
    my $data = shift;

    my $i;

    my $nrows = scalar(@{$pop});
    my $cal = calculator->new;

    my $mindist = $cal->routedistance(@{$pop}[0], $data);
    my $minindex = 0;

    for($i = 1; $i < $nrows; $i++){
	if($cal->routedistance(@{$pop}[$i], $data) < $mindist){
	    $mindist = $cal->routedistance(@{$pop}[$i], $data);
	    $minindex = $i;
	}
    }
#    print "findshortest " . $mindist . "\n";

    return ($minindex, @{$pop}[$minindex]);
}




sub printPopulation{  ## needs some work...
  my $self = shift;
  my $vector = shift;
#  my $clength = scalar(@$vector);
  my @v = @{$vector};  
  my $clength = scalar(@{$$vector[0]}); # prints number of rows in array of arrays

  my $dlength = scalar(@{$$vector[0]->[0]}); # prints number of columns in array of arrays

#  print @{$$vector[0]->[3]} . "\n";

#  print "v " . @{$v[0]}->[2] . "\n";
  my $w = @{$v[0]};

#  print "w " . $w->[2];

  my ($i, $j);
  my $v;
  my $temp;
  my @t;
  my @new_array;

for(my $row=0; $row<=$#{$vector}; $row++){
   for(my $col=0; $col<=$#{$vector->[$row]}; $col++){
#         push @new_array, $vector->[$row]->[$col];
#     print $vector->[$row]->[$col] . " ";
   }
}

my @s = @{@{$vector}[0]->[0]};
@s = @{@{$vector}[0]->[1]};


print "s " . "@s" . " " . "\n";
print "s " . $s[3] . " " . "\n";

@s = @{@{$vector}[0]->[2]};

print "s " . "@s" . " " . "\n";
print "s " . $s[3] . " " . "\n";


for($i = 0; $i < $clength; $i++){

my @s = @{@{$vector}[0]->[$i]};
#@s = @{@{$vector}[0]->[1]};

#print "s " . "@s" . " " . "\n";
#print "s " . $s[3] . " " . "\n";

}









my $arrayref;
my $element;
foreach $arrayref (@$vector) {
        foreach $element (@$arrayref) {
                print $element . " ";
        }
        print "\n";
}


#for(my $row=0; $row<=@{$vector}; $row++){
#   for(my $col=0; $col<=@{$vector->[$row]}; $col++){
#         push @new_array, $vector->[$row]->[$col];
#     print @{@{$vector}->[$row]->[$col]} . " ";
#   }
#}



#print "na " . "@new_array" . "\n";


  print "pp " . $clength . "\n";
  print "pp2 " . $dlength . "\n";

  for($i = 0; $i < $clength; $i++){

# http://www.perlmonks.org/?node_id=90647

#    print @$vector[$i]; # prints array reference
#    print @$vector[$i]->[0]; # prints array reference
#    print ${$vector[$i]}->[0]; # global symbol vector requires explicit package name

#    printVector(@$vector[$i]); # prints array reference
#    printVector(@$vector[$i]->[0]); # prints first array


    for($j = 0; $j < $dlength; $j++){

#print @$$vector[$i]->[$j] . " "; # not a scalar reference
#print @{$$vector[$i]->[$j]} . " "; # can't use an undefined value as an ARRAY reference
#print @${$vector[$i]->[$j]} . " "; # global symbol @vector requires explicit package name

#print @{$$vector[$i]}->[$j] . " "; # use of uninitialized value in concatenation
#print @${$vector[$i]}->[$j] . " "; # global symbol @vector requires explicit package name

#print @${@vector[$i]}->[$j] . " "; # scalar value @vector[$i] better written as $vector[$i]
#print @${$vector[$i]}[$j] . " "; # global symbol @vector requires explicit package name


#    print @$vector[$i] . " ";


#print @{${$vector[$i]}}[$j] . " "; # global symbol vector requires explicit package name
#print @{${$vector[$i]}[$j]} . " "; # global symbol vector requires explicit package name
#print @{${$vector[$i]}->[$j]} . " "; # global symbol vector requires explicit package name



#print @$$vector[$i]->[$j] . " ";
#print @$$vector[$i]->[$j] . " ";
#print @$$vector[$i]->[$j] . " ";
#print @$$vector[$i]->[$j] . " ";
#print @$$vector[$i]->[$j] . " ";







#      print @{@$vector[$i]->[$j]}; # prints all in one line
#      print @{@{$vector}[$i]->[$j]}; # prints all in one line

#      printVector(@{@$vector[$i]}->[$j]); # prints vector


#print "l " . "\n";

#      print @{$$vector[$i]}->[$j] . " "; # prints array references
#      print ${@$vector[$i]->[$j]}; # gives 'Not a scalar reference' message
#      print @{@$vector[$i][$j]};  # gives syntax error
#      print @{@$vector[$i]}->[$j]; # prints array references
#      print @{@$vector}[$i]->[$j]; # cant use strin as ARRAY ref
#      print ${${$vector[$i]}}[$j];  # global symbol @vector requires explicit package name
#      print @{${$vector[$i]}->[$j]}; # global symbol @vector requires explicit package name
#      print @{${$vector[$i]}}[$j];# global symbol @vector requires explicit package name
#      print ${${$vector[$i]}}->[$j];# global symbol @vector requires explicit package name



#      print @{${$vector[$i]}}[$j];
#      print @{${$vector[$i]}}[$j];
#      print @{${$vector[$i]}}[$j];




#      print "\n";
    }
  }  
  return;
}


sub printVector{
  my $vector = shift;
  my $clength = scalar(@$vector);

  my ($i, $j);
  for($i = 0; $i < $clength; $i++){
    print @$vector[$i] . " ";
  }
  print "\n";
  return;
}

sub popmutate{
  my $self = shift;
  my $pop = shift;
  my $mutation_rate = shift;

  my $popsize = scalar(@$pop);

  my $i;

  for($i = 0; $i < $popsize; $i++){

#if(rand() > 0.9){
#    $self->mutate(@{$pop}[$i], $mutation_rate); # regular mutation
#}
#else{
    $self->insertion_mutation(@{$pop}[$i], $mutation_rate); # regular mutation
#}


  }

  return $pop;

}

sub insertion_mutation{
  my $self = shift;
  my $pop = shift;
  my $mutation_rate = shift;

  if(rand() > $mutation_rate){ #skip mutation procedure if rand() too high
    return;
  }

#print Dumper($pop);
  my $popsize = scalar(@$pop);

  my $genepos = floor(rand()*$popsize);
  my $newpos = $genepos;

  while ($genepos == $newpos){  # make sure positions are different
    $newpos = floor(rand()*$popsize);
  }

#print "insertion " . $genepos . " " . $newpos . "\n";

  $self->displace($pop, $genepos, $newpos);


  return $pop;

}

sub displace{
  my $self = shift;
  my $pop = shift;
  my $genepos = shift;
  my $newpos = shift;

#  print "pop " . "@$pop" . "\n";

  my $distance = $newpos - $genepos;

#  print "displace " . "genepos: " . $genepos  . ", newpos: " . $newpos . ", distance: " . $distance . "\n";

  my $popsize = scalar(@{$pop});
  my ($s1, $s2, $s3, $s4, $s5);
  my $newpop;
  if($distance > 0){

    @{$s1} = @{$pop}[0 .. ($genepos - 1)];
    @{$s2} = @{$pop}[($genepos + 1) .. $newpos];
    @{$s3} = @{$pop}[$genepos];
    @{$s4} = @{$pop}[($newpos + 1) .. ($popsize-1)];

#print "slice1 " . "@{$s1}" . "\n";
#print "slice2 " . "@{$s2}" . "\n";
#print "slice3 " . "@{$s3}" . "\n";
#print "slice4 " . "@{$s4}" . "\n";

@{$newpop} = (@{$s1}, @{$s2}, @{$s3}, @{$s4});
#print "newpop " . "@{$newpop}" . "\n";


  } else {

    @{$s1} = @{$pop}[0 .. ($newpos - 1)];
    @{$s2} = @{$pop}[$genepos];
    @{$s3} = @{$pop}[($newpos) .. ($genepos-1)];
    @{$s4} = @{$pop}[($genepos + 1) .. ($popsize-1)];


#    $a = splice(@{$pop}, $genepos, $popsize + $distance);

#print "displace " . "$a" . "\n";
#print "slice1 " . "@{$s1}" . "\n";
#print "slice2 " . "@{$s2}" . "\n";
#print "slice3 " . "@{$s3}" . "\n";
#print "slice4 " . "@{$s4}" . "\n";

@{$newpop} = (@{$s1}, @{$s2}, @{$s3}, @{$s4});

#print "newpop " . "@{$newpop}" . "\n";

  }

  @{$pop} = @{$newpop};

  return;
}



sub mutate{
  my $self = shift;
  my $vector = shift;
  my $mutation_rate = shift;

  if(rand() > $mutation_rate){ #skip mutation procedure if rand() too high
    return;
  }

  my $vector_length = scalar(@$vector);
  my $pos1 = floor(rand()*$vector_length);
  my $pos2 = $pos1;

  while ($pos2 == $pos1){  # make sure positions are different
    $pos2 = floor(rand()*$vector_length);
  }

  swap1($vector, $pos1, $pos2);
  return;

}

sub swap1{             # swap elements in one vector
  my $vector = shift;
#  my $vector2 = shift;
  my $pos1 = shift;
  my $pos2 = shift;
  my $temp;

  $temp = @$vector[$pos1];
  @$vector[$pos1] = @$vector[$pos2];
  @$vector[$pos2] = $temp;

  return;
}


sub popcrossover{
  my $self = shift;
  my $pop = shift;
  my $xorate = shift;

  my $popsize = scalar(@$pop);
  my $ngenes = scalar(@{$pop->[0]});

#  print "popcrossover" . "\n";
#  print "popsize " . $popsize . ", ngenes " . $ngenes . "\n";

  my $i;
  my ($xostart, $xolength, $xoend);
  my ($v1, $v2);

# $i<pop-1 to handle odd population sizes

  for($i = 0; $i < $popsize-1; $i += 2){
     if(rand() < $xorate){
#	 print "test" . "\n";
	 $xostart = floor(rand() * ($ngenes - 1));
	 $xolength = floor(rand() * ($ngenes - $xostart));

#	 print "start " . $xostart . ",length " . $xolength  . "\n";
	 while($xolength == 0){
	   $xolength = floor(rand() * ($ngenes - $xostart));
	 }
	 $xoend = $xostart + $xolength;

#	 print "popcrossover" . "\n";
#	 print "start " . $xostart . ",length " . $xolength . ",end " . $xoend . "\n";



	 $v1 = @{$pop}[$i];
	 $v2 = @{$pop}[$i+1];


	 $self->pmx($v1, $v2, $xostart, $xoend);
     }

  }

  my $cpop = $pop;
  return $cpop;
}


sub pmx{
    my $self = shift;
  my $vector1 = shift;
  my $vector2 = shift;
  my $xostart = shift;
  my $xoend = shift;

  my (@vector1, @vector2);

#  print "pmx" . "\n";
#  print Dumper($vector1);
#  print Dumper($vector2);
  my ($i, $j, $k);
  my ($element1, $element2);
  my ($e1pos, $e2pos);

  my $vector_start = 0;
  my $vector_length = scalar(@$vector1);

#    print "pmx vector length" . "\n";
#    print $vector_length . "\n";

  my $new_vector1 = $self->copy_vector($vector1);
#    print "pmx new vector 1" . "\n";
#    print Dumper($new_vector1);
  my $new_vector2 = $self->copy_vector($vector2);
#    print "pmx new vector 2" . "\n";
#    print Dumper($new_vector2);

  my (@xoelements1, @xoelements2);
  my $xoelements1 = \@xoelements1;
  my $xoelements2 = \@xoelements2;


#    print "the for loop: " . "start " . $xostart . ", end " . $xoend . "\n";
  for($i = $xostart; $i < $xoend; $i++){

# fix this for vector references
    push($xoelements1, $vector1->[$i]); # crossover elements on vector 1
#    print "pmx i vector1" . "\n";
#    print @{$vector1}->[$i] . "\n";
    push($xoelements2, $vector2->[$i]); # crossover elements on vector 2
#    print "pmx i vector2" . "\n";
#    print @{$vector2}->[$i] . "\n";

# works with vectors
#    push(@xoelements1, $vector1[$i]); # crossover elements on vector 1
#    push(@xoelements2, $vector2[$i]); # crossover elements on vector 2


    $self->swap2($new_vector1, $new_vector2, $i, $i);
  }

#    print "pmx xoelements" . "\n";
#    print Dumper($xoelements1);
#    print Dumper($xoelements2);


  my $xolength = scalar(@xoelements1);

  for($k = 0; $k < 2; $k++){

    for($i = 0; $i < $vector_length; $i++){
      if($i == $xoend){
#	  last; # don't do this
      }
      if($i == $xostart){
        $i = $xoend - 1;
        next;
      }

# first vector 1

      for($j = 0; $j < $xolength; $j++){


        if($new_vector1->[$i] == $xoelements2->[$j]){
          $e1pos = find(0, $vector_length, $vector2, $new_vector1->[$i]);
          $new_vector1->[$i] = $vector1->[$e1pos]

# works for vectors
#        if(@$new_vector1[$i] == $xoelements2[$j]){
#          $e1pos = find(0, $vector_length, $vector2, @$new_vector1[$i]);
#          @$new_vector1[$i] = @$vector1[$e1pos]



        }
      }

      for($j = 0; $j < $xolength; $j++){


        if($new_vector2->[$i] == $xoelements1->[$j]){
          $e2pos = find(0, $vector_length, $vector1, $new_vector2->[$i]);
          $new_vector2->[$i] = $vector2->[$e2pos];

# works for vectors
#        if(@$new_vector2[$i] == $xoelements1[$j]){
#          $e2pos = find(0, $vector_length, $vector1, @$new_vector2[$i]);
#          @$new_vector2[$i] = @$vector2[$e2pos];

        }
      }
    }
  }

#    print "return new_vector1, new_vector2" . "\n";
#    print Dumper($new_vector1);
#    print Dumper($new_vector2);

  return ($new_vector1, $new_vector2);

}

sub swap2{              # swap elements between two vectors
  my $self = shift;
  my $vector1 = shift;
  my $vector2 = shift;
  my $pos1 = shift;
  my $pos2 = shift;
  my $temp;

#  print "before swap2, " . $pos1 . ", " . $pos2 . "\n";
#  print Dumper($vector1);
#  print Dumper($vector2);

# make work with array refs
  $temp = $vector1->[$pos1];
#  print "swap2 temp " . $temp . "\n";
  $vector1->[$pos1] = $vector2->[$pos2];
  $vector2->[$pos2] = $temp;

# works with arrays
#  $temp = @$vector1[$pos1];
#  @$vector1[$pos1] = @$vector2[$pos2];
#  @$vector2[$pos2] = $temp;

#  print "after swap2" . "\n";
#  print Dumper($vector1);
#  print Dumper($vector2);

  return;
}

sub find{
  my $start = shift;
  my $end = shift;
  my $vector = shift;
  my $element = shift;
  my ($i, $pos);
  for($i = $start; $i < $end; $i++){
    if(@$vector[$i] == $element){
      $pos = $i;
      last;
    }
  }
  return $pos;
}




sub createPopulation{
  my $self = shift;
  my $popsize = shift;
  my $vector = shift;

  my ($i, $tmp);
  my @population;
my $tmp;
#my $pop;

#print "createPopulation1 " . "\n";
#print Dumper($vector);
  for($i = 0; $i < $popsize; $i++){
$tmp = $self->createRandomRoute($vector);
    push(@population, $tmp);

  }
#print "createPopulation2 " . "\n";
#print Dumper(@population);
#print "\n";

  return \@population;
}

sub createRandomRoute{
  my $self = shift;
  my $range = shift;
#print "createRandomRoute1" . "\n";
#print Dumper($range);
  my $route = $self->copy_vector($range);  
  fisher_yates_shuffle($route);
#print "createRandomRoute2" . "\n";
#print Dumper($route);


  return $route;
}

# randomly permutate @array in place
sub fisher_yates_shuffle{
    my $array = shift;
    my $i = @$array;
#    print "fy " . $i . "\n";
    while ( --$i )
    {
        my $j = int rand( $i+1 );
        @$array[$i,$j] = @$array[$j,$i];
    }
    return $array;
}

sub copy_vector{
  my $self = shift;
  my $vector = shift;
#print "copy_vector1" . "\n";
#print Dumper($vector);

#  print "copy vector" . "\n";
#  print $vector . "\n";
  my @new_vector = ();
  my $i;
  my $vector_length = scalar(@$vector);
  for($i = 0; $i < $vector_length; $i++){
    $new_vector[$i] = @$vector[$i];
  }
#print "copy_vector2" . "\n";
  my $new_vector_ref = \@new_vector;
#print Dumper(@new_vector);
#print Dumper($new_vector_ref);

#  print $new_vector_ref . "\n";

  return $new_vector_ref;

}

1;
