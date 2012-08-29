use strict;
use warnings;

use autodie;
use Benchmark qw(:all);

my $dbpedia_downloads_uri = 'http://downloads.dbpedia.org/3.8/en/';

sub benchmark_parser {
  my $parser = shift;
  my $test_filename = shift;

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
    $parser->parse_file(undef, $file, sub {
      print ++$total, "\n";
    });
  });

  print "Parsing took", timestr($result), "\n";
}
