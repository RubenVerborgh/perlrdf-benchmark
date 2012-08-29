#!/usr/bin/env perl
use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../lib/", "$Bin/../perlrdf/RDF-Trine/lib";
use Benchmark_Parser;
use RDF::Trine::Parser;

benchmark_parser(RDF::Trine::Parser->new('turtle'),
                 'category_labels_en.ttl', @ARGV);
