package LWP::LastURI;

use strict;
no warnings;
use vars qw($VERSION);
$VERSION = 0.03;

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

=head1 IMPLEMENTATION

This module works by using LWP::Debug to push all GET and POST requests onto a 
static array. There is only one stack of such requests for all of LWP's HTTP
and/or HTTPS requests. 

=head1 SEE ALSO

L<LWP::Debug>

=head1 COPYRIGHT 

Copyright (c) 2005 William Herrera

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 AUTHOR

William Herrera <wherrera@skylightview.com>
