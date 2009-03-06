package t::Util;
use strict;
use warnings;
use base 'Exporter';
use CGI;
use HTML::Shakan;

our @EXPORT = qw(query trim);

sub import {
    strict->import;
    warnings->import;

    __PACKAGE__->export_to_level(1);
}

sub query { CGI->new(@_) }

sub trim {
    local $_ = shift;
    s/\n$//;
    $_;
}


1;
