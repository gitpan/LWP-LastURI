package LWP::LastURI;

use strict;
no warnings;
use vars qw($VERSION);
$VERSION = 0.04;

use LWP::Debug;

$LWP::Debug::current_level{'trace'} = 1;

my @requests;

sub LWP::Debug::_log
{
    push @requests, shift;
}

sub last_uri { 
    my $type = shift || 'ALL';
    foreach my $msg (reverse @requests) {
        return $1 if( 
            ($type eq 'GET'  and $msg =~ m#GET\s+(https?://\S+)#) or
            ($type eq 'POST' and $msg =~ m#POST\s+(https?://\S+)#) or
            ($type eq 'ALL'  and $msg =~ m#(?:GET|POST)\s+(https?://\S+)#)
        );
    }
    return;
}

1;

__END__

=head1 NAME

LWP::LastURI - routine for getting last URI visited despite redirects

=head1 SYNOPSIS

    use LWP::LastURI;

    my $agent = new WWW::Mechanize;
    
    # not that LWP user agents such as WWW::Mechanize may do redirection that 
    # will not be reflected in the return value of $agent->uri. 
    # This module offers a way to see the final URI after redirection.
    
    ... do stuff that involves redirection
    
    my $redirected_final = LWP::LastURI::last_uri;
    my $redirected_final_post = LWP::LastURI::last_uri('POST');
    my $redirected_final_get  = LWP::LastURI::last_uri('GET');

=head1 DESCRIPTION

If you want to see just what LWP is doing during a redirect, this program makes 
available a trace of sites visited. After a redirect, the site finally visited 
last can be retrived via a call to LWP::LastURI::last_uri. The optional 
argument can specify whether the latest 'GET' or 'POST' request is wanted. 
Otherwise, either a GET or POST uri is returned, whichever was latest. 

Note that this module was written to work around a bug in certain versions 
of WWW::Mechanize prior to version 1.20.  If you use a more recent 
version of WWW::Mechanize, after version 1.19, this module is now redundant 
unless you using it for some other purpose than just getting the last 
redirected URI.

=head1 IMPLEMENTATION

=over 4

=item B<last_uri>

This module works by using LWP::Debug to push all GET and POST requests onto a 
static array. There is only one stack of such requests for all of LWP's HTTP
and/or HTTPS requests. 

=back

=head1 SEE ALSO

L<LWP::Debug>

=head1 COPYRIGHT 

Copyright (c) 2005 William Herrera

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 AUTHOR

William Herrera <wherrera@skylightview.com>
