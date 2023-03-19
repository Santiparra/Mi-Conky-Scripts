#!/usr/bin/perl 

use strict; 
use warnings; 
my $n = (`pacman -Qu | wc -l`); 
chomp ($n); 
if ($n == 0) 
{ 
print "Actualizado" 
} 
else 
{ 
print "$n Disponibles " 
} 