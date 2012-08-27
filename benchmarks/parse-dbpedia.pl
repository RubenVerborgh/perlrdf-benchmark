#!/usr/bin/env perl
use strict;
use warnings;

use autodie;
use Benchmark qw(:all);
use FindBin qw($Bin);
use lib "$Bin/../perlrdf/RDF-Trine/lib";
use RDF::Trine::Parser;

# Test file settings
my $dbpedia_downloads_uri = 'http://downloads.dbpedia.org/3.8/en/';
my $test_filename = 'category_labels_en.ttl';

# Fetch the test file if it doesn't exist
my $tmp_dir = "$Bin/../tmp/";
my $test_file = "$tmp_dir$test_filename";
unless (-e $test_file) {
  # Create tmp directory
  mkdir $tmp_dir unless -e $tmp_dir;

  # Download and unzip file
  system "wget $dbpedia_downloads_uri$test_filename.bz2 -O $tmp_dir$test_filename.bz2";
  system "bunzip2 $tmp_dir$test_filename.bz2";
}

# Read test file
my $file;
open $file, $test_file;

# Parse test file
my $result = timeit(1, sub {
  my $total = 0;
  my $parser = RDF::Trine::Parser->new('turtle');
  $parser->parse_file(undef, $file, sub {
    print ++$total, "\n";
  });
});

print "Parsing took", timestr($result), "\n";
