# t/01_test.t - check module loading, etc

require 5.006;
use Test::More tests => 1;

BEGIN { use_ok( 'LWP::LastURI' ); }

