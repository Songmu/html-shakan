package t::Util;
use strict;
use warnings;
use base 'Exporter';
use CGI;

our @EXPORT = qw(query trim);

sub query { CGI->new(@_) }

sub trim {
    local $_ = shift;
    s/\n$//;
    $_;
}

1;
