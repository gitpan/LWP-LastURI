use ExtUtils::MakeMaker;
require 5.006;

WriteMakefile(
    NAME         => 'LWP::LastURI',
    AUTHOR       => 'William Hererra (whererra@skylightview.com)',
    ABSTRACT     => 'Find the last real LWP request URI regardless of redirects',
    VERSION_FROM => 'lib/LWP/LastURI.pm', # finds $VERSION
    PREREQ_PM    => { LWP => 0, LWP::Debug => 0, Test::More => 0, },
);


